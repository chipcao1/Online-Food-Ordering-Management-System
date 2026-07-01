package uef.edu.vn.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import uef.edu.vn.model.Delivery;
import uef.edu.vn.model.Order;
import uef.edu.vn.model.Employee;
import uef.edu.vn.enums.DeliveryStatus;

@Repository
public class DeliveryRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private Delivery mapRow(ResultSet rs, int rowNum) throws SQLException {
        Delivery d = new Delivery();
        d.setId(rs.getLong("id"));
        d.setTrackingCode(rs.getString("tracking_code"));
        d.setDeliveryFee(rs.getBigDecimal("delivery_fee"));
        
        String statusStr = rs.getString("delivery_status");
        if (statusStr != null) {
            d.setDeliveryStatus(DeliveryStatus.valueOf(statusStr));
        }

        // Map Order
        Order o = new Order();
        o.setId(rs.getLong("order_id"));
        o.setOrderCode(rs.getString("order_code"));
        d.setOrder(o);

        // ĐÃ FIX: Đổi "delivery_staff_id" thành "employee_id" cho khớp bảng deliveries của bạn
        long staffId = rs.getLong("employee_id");
        if (staffId > 0) {
            Employee e = new Employee();
            e.setId(staffId);
            e.setFullName(rs.getString("full_name"));
            d.setDeliveryStaff(e);
        }

        return d;
    }

    public List<Delivery> findAll() {
        // ĐÃ FIX: Đổi bảng delivery -> deliveries, order -> orders
        String sql = "SELECT d.*, o.order_code, e.full_name " +
                     "FROM deliveries d " +
                     "JOIN orders o ON d.order_id = o.id " +
                     "LEFT JOIN employee e ON d.employee_id = e.id " +
                     "ORDER BY d.id DESC";
        return jdbcTemplate.query(sql, this::mapRow);
    }

    public Delivery findById(Long id) {
        // ĐÃ FIX TÊN BẢNG VÀ CỘT
        String sql = "SELECT d.*, o.order_code, e.full_name " +
                     "FROM deliveries d " +
                     "JOIN orders o ON d.order_id = o.id " +
                     "LEFT JOIN employee e ON d.employee_id = e.id " +
                     "WHERE d.id = ?";
        List<Delivery> list = jdbcTemplate.query(sql, this::mapRow, id);
        return list.isEmpty() ? null : list.get(0);
    }

    public void save(Delivery delivery) {
        // ĐÃ FIX TÊN BẢNG VÀ CỘT
        String sql = "INSERT INTO deliveries (order_id, employee_id, tracking_code, delivery_fee, delivery_status) VALUES (?, ?, ?, ?, ?)";
        Long staffId = delivery.getDeliveryStaff() != null ? delivery.getDeliveryStaff().getId() : null;
        String status = delivery.getDeliveryStatus() != null ? delivery.getDeliveryStatus().name() : "WAITING";
        
        jdbcTemplate.update(sql, delivery.getOrder().getId(), staffId, delivery.getTrackingCode(), delivery.getDeliveryFee(), status);
    }

    // HÀM QUAN TRỌNG: Cập nhật trạng thái
    public void updateStatus(Long deliveryId, String status) {
        // 1. Cập nhật bảng deliveries
        String sql1 = "UPDATE deliveries SET delivery_status = ? WHERE id = ?";
        jdbcTemplate.update(sql1, status, deliveryId);

        // 2. NẾU Shipper giao thành công -> Cập nhật bảng orders thành COMPLETED
        if ("DELIVERED".equals(status)) {
            String sql2 = "UPDATE orders SET status = 'COMPLETED' WHERE id = (SELECT order_id FROM deliveries WHERE id = ?)";
            jdbcTemplate.update(sql2, deliveryId);
        }
    }

    public void deleteById(Long id) {
        jdbcTemplate.update("DELETE FROM deliveries WHERE id = ?", id);
    }

    // Lấy bản ghi delivery theo order_id (một đơn có thể có 1 bản ghi delivery)
    public Delivery findByOrderId(Long orderId) {
        String sql = "SELECT d.*, o.order_code, e.full_name " +
                     "FROM deliveries d " +
                     "JOIN orders o ON d.order_id = o.id " +
                     "LEFT JOIN employee e ON d.employee_id = e.id " +
                     "WHERE d.order_id = ? LIMIT 1";
        List<Delivery> list = jdbcTemplate.query(sql, this::mapRow, orderId);
        return list.isEmpty() ? null : list.get(0);
    }

    // Gán shipper vào bản ghi delivery của đơn hàng
    public void assignShipper(Long orderId, Long employeeId) {
        jdbcTemplate.update("UPDATE deliveries SET employee_id = ? WHERE order_id = ?", employeeId, orderId);
    }
}