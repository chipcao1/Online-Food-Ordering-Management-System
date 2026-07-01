package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import uef.edu.vn.model.Order;
import uef.edu.vn.model.OrderItem;
import uef.edu.vn.enums.OrderStatus;
import uef.edu.vn.repository.OrderItemRepository;
import uef.edu.vn.repository.OrderRepository;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    public Order getOrderById(Long id) {
        Order order = orderRepository.findById(id);
        
        if (order != null) {
            // Lấy danh sách chi tiết món ăn và gán vào Order
            List<OrderItem> items = orderItemRepository.findByOrderId(id);
            order.setItems(items); 
        }
        
        return order;
    }

    public void updateStatus(Long id, String status) {
        orderRepository.updateStatus(id, status);
    }

    public void delete(Long id) {
        // Tối ưu hóa: Xóa tất cả các OrderItem bằng 1 câu lệnh SQL duy nhất thay vì vòng lặp
        String deleteItemsSql = "DELETE FROM order_items WHERE order_id = ?";
        jdbcTemplate.update(deleteItemsSql, id);
        
        // Sau đó xóa Order chính
        orderRepository.delete(id);
    }

    // THÊM MỚI: cập nhật trạng thái thanh toán
    public void updatePaymentStatus(Long id, String paymentStatus) {
        orderRepository.updatePaymentStatus(id, paymentStatus);
    }

    // Tìm kiếm đơn hàng
    public List<Order> search(String keyword, String status, String paymentStatus) {
        return orderRepository.search(keyword, status, paymentStatus);
    }
}