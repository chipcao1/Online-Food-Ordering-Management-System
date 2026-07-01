package uef.edu.vn.service;

import java.math.BigDecimal;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.model.OrderItem;
import uef.edu.vn.repository.OrderItemRepository;

@Service
public class OrderItemService {

    @Autowired
    private OrderItemRepository orderItemRepository;

    public List<OrderItem> getItemsByOrderId(Long orderId) {
        return orderItemRepository.findByOrderId(orderId);
    }

    public void save(OrderItem orderItem) {
        if (orderItem.getUnitPrice() != null && orderItem.getQuantity() > 0) {
            BigDecimal sub = orderItem.getUnitPrice().multiply(new BigDecimal(orderItem.getQuantity()));
            orderItem.setSubtotal(sub);
        }

        // Fix logic kiểm tra ID của Long (Tránh NullPointerException)
        if (orderItem.getId() == null) {
            orderItemRepository.save(orderItem);
        } else {
            orderItemRepository.update(orderItem);
        }
    }

    public void delete(Long id) {
        orderItemRepository.delete(id);
    }
}