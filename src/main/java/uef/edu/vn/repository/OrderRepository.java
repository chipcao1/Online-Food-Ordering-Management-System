package uef.edu.vn.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Customer;
import uef.edu.vn.model.Order;
import uef.edu.vn.enums.OrderStatus;
import uef.edu.vn.enums.PaymentMethod;
import uef.edu.vn.enums.PaymentStatus;

@Repository
public class OrderRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ĐÃ SỬA: mapRow nhận thêm full_name từ JOIN customer
    private Order mapRow(ResultSet rs, int rowNum) throws SQLException {
        Order order = new Order();
        order.setId(rs.getLong("id"));
        order.setOrderCode(rs.getString("order_code"));

        long customerId = rs.getLong("customer_id");
        if (!rs.wasNull()) {
            Customer customer = new Customer();
            customer.setId(customerId);
            // Lấy fullName từ LEFT JOIN với bảng customer
            try { customer.setFullName(rs.getString("full_name")); } catch (SQLException ignore) {}
            order.setCustomer(customer);
        }

        order.setDeliveryAddress(rs.getString("delivery_address"));
        order.setDeliveryPhone(rs.getString("delivery_phone"));

        String statusStr = rs.getString("status");
        if (statusStr != null) order.setStatus(OrderStatus.valueOf(statusStr));

        String paymentMethodStr = rs.getString("payment_method");
        if (paymentMethodStr != null) {
            try { order.setPaymentMethod(PaymentMethod.valueOf(paymentMethodStr)); } catch (IllegalArgumentException ignore) {}
        }

        String paymentStatusStr = rs.getString("payment_status");
        if (paymentStatusStr != null) order.setPaymentStatus(PaymentStatus.valueOf(paymentStatusStr));

        order.setSubtotal(rs.getBigDecimal("subtotal"));
        order.setShippingFee(rs.getBigDecimal("shipping_fee"));
        order.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setNote(rs.getString("note"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) order.setCreatedAt(createdAt.toLocalDateTime());

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) order.setUpdatedAt(updatedAt.toLocalDateTime());

        return order;
    }

    // ĐÃ SỬA: LEFT JOIN customer để lấy full_name
    public List<Order> findAll() {
        String sql = "SELECT o.*, c.full_name FROM orders o LEFT JOIN customer c ON o.customer_id = c.id ORDER BY o.created_at DESC";
        return jdbcTemplate.query(sql, this::mapRow);
    }

    public Order findById(Long id) {
        String sql = "SELECT o.*, c.full_name FROM orders o LEFT JOIN customer c ON o.customer_id = c.id WHERE o.id = ?";
        List<Order> list = jdbcTemplate.query(sql, this::mapRow, id);
        return list.isEmpty() ? null : list.get(0);
    }

    public void save(Order order) {
        String sql = "INSERT INTO orders (order_code, customer_id, delivery_address, delivery_phone, status, payment_method, payment_status, subtotal, shipping_fee, discount_amount, total_amount, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                order.getOrderCode(),
                order.getCustomer() != null ? order.getCustomer().getId() : null,
                order.getDeliveryAddress(),
                order.getDeliveryPhone(),
                order.getStatus() != null ? order.getStatus().name() : OrderStatus.PENDING.name(),
                order.getPaymentMethod() != null ? order.getPaymentMethod().name() : null,
                order.getPaymentStatus() != null ? order.getPaymentStatus().name() : PaymentStatus.UNPAID.name(),
                order.getSubtotal(),
                order.getShippingFee(),
                order.getDiscountAmount(),
                order.getTotalAmount(),
                order.getNote()
        );
    }

    public void updateStatus(Long id, String status) {
        jdbcTemplate.update("UPDATE orders SET status = ? WHERE id = ?", status, id);

        if ("DELIVERING".equals(status)) {
            Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM deliveries WHERE order_id = ?", Integer.class, id);
            if (count != null && count == 0) {
                String trackingCode = "TRK-" + System.currentTimeMillis();
                Double shippingFee = 0.0;
                try {
                    shippingFee = jdbcTemplate.queryForObject(
                        "SELECT shipping_fee FROM orders WHERE id = ?", Double.class, id);
                } catch (Exception ignore) {}
                if (shippingFee == null) shippingFee = 0.0;
                jdbcTemplate.update(
                    "INSERT INTO deliveries (order_id, tracking_code, delivery_fee, delivery_status) VALUES (?, ?, ?, 'DELIVERING')",
                    id, trackingCode, shippingFee);
            }
        }
    }

    public void delete(Long id) {
        jdbcTemplate.update("DELETE FROM orders WHERE id = ?", id);
    }

    public Order findByOrderCode(String orderCode) {
        String sql = "SELECT o.*, c.full_name FROM orders o LEFT JOIN customer c ON o.customer_id = c.id WHERE o.order_code = ?";
        List<Order> list = jdbcTemplate.query(sql, this::mapRow, orderCode);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Order> findByCustomerId(Long customerId) {
        String sql = "SELECT o.*, c.full_name FROM orders o LEFT JOIN customer c ON o.customer_id = c.id WHERE o.customer_id = ? ORDER BY o.id DESC";
        return jdbcTemplate.query(sql, this::mapRow, customerId);
    }

    // THÊM MỚI: cập nhật trạng thái thanh toán (Staff xác nhận thanh toán)
    public void updatePaymentStatus(Long id, String paymentStatus) {
        jdbcTemplate.update("UPDATE orders SET payment_status = ? WHERE id = ?", paymentStatus, id);
    }

    // Tìm kiếm đơn hàng theo mã đơn, tên khách, trạng thái, trạng thái TT
    public List<Order> search(String keyword, String status, String paymentStatus) {
        StringBuilder sql = new StringBuilder(
            "SELECT o.*, c.full_name FROM orders o LEFT JOIN customer c ON o.customer_id = c.id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (o.order_code LIKE ? OR c.full_name LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND o.status = ?");
            params.add(status);
        }
        if (paymentStatus != null && !paymentStatus.isBlank()) {
            sql.append(" AND o.payment_status = ?");
            params.add(paymentStatus);
        }
        sql.append(" ORDER BY o.created_at DESC");
        return jdbcTemplate.query(sql.toString(), this::mapRow, params.toArray());
    }
}