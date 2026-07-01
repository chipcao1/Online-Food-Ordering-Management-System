package uef.edu.vn.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.FoodItem;
import uef.edu.vn.model.OrderItem;

@Repository
public class OrderItemRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private OrderItem mapRow(ResultSet rs, int rowNum) throws SQLException {
        OrderItem item = new OrderItem();
        item.setId(rs.getLong("id"));
        item.setOrderId(rs.getLong("order_id")); // Cực kỳ quan trọng
        
        // Map thông tin FoodItem
        long foodItemId = rs.getLong("food_item_id");
        if (!rs.wasNull()) {
            FoodItem food = new FoodItem();
            food.setId(foodItemId);
            item.setFoodItem(food);
        }
        
        item.setFoodNameSnapshot(rs.getString("food_name_snapshot"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        item.setQuantity(rs.getInt("quantity"));
        item.setSubtotal(rs.getBigDecimal("subtotal"));
        return item;
    }

    // Các hàm findAll, findById, findByOrderId tương tự nhưng mapRow đã có đủ data
    public List<OrderItem> findByOrderId(Long orderId) {
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        return jdbcTemplate.query(sql, this::mapRow, orderId);
    }

    public void save(OrderItem orderItem) {
        // ĐÃ THÊM order_id và food_item_id
        String sql = "INSERT INTO order_items (order_id, food_item_id, food_name_snapshot, unit_price, quantity, subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, 
                orderItem.getOrderId(),
                orderItem.getFoodItem() != null ? orderItem.getFoodItem().getId() : null,
                orderItem.getFoodNameSnapshot(), 
                orderItem.getUnitPrice(), 
                orderItem.getQuantity(), 
                orderItem.getSubtotal());
    }

    public void update(OrderItem orderItem) {
        // ĐÃ THÊM order_id và food_item_id
        String sql = "UPDATE order_items SET order_id=?, food_item_id=?, food_name_snapshot=?, unit_price=?, quantity=?, subtotal=? WHERE id=?";
        jdbcTemplate.update(sql, 
                orderItem.getOrderId(),
                orderItem.getFoodItem() != null ? orderItem.getFoodItem().getId() : null,
                orderItem.getFoodNameSnapshot(), 
                orderItem.getUnitPrice(), 
                orderItem.getQuantity(), 
                orderItem.getSubtotal(), 
                orderItem.getId());
    }

    public void delete(Long id) {
        String sql = "DELETE FROM order_items WHERE id=?";
        jdbcTemplate.update(sql, id);
    }
}