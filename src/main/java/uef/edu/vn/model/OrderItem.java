// File: uef/edu/vn/model/OrderItem.java
package uef.edu.vn.model;

import java.math.BigDecimal;

public class OrderItem {
    private Long id;
    private Long orderId; // Liên kết về Order
    
    // Thay vì chỉ lưu tên (foodNameSnapshot), tài liệu yêu cầu có liên kết n-1 về FoodItem
    private FoodItem foodItem; 
    
    private String foodNameSnapshot; // Lưu tên lúc đặt (phòng khi món đổi tên sau này)
    private BigDecimal unitPrice;
    private int quantity;
    private BigDecimal discountAmount; // Bổ sung thêm trường giảm giá cho từng món
    private BigDecimal subtotal;

    public OrderItem() {}

    // Getters và Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public FoodItem getFoodItem() { return foodItem; }
    public void setFoodItem(FoodItem foodItem) { this.foodItem = foodItem; }
    public String getFoodNameSnapshot() { return foodNameSnapshot; }
    public void setFoodNameSnapshot(String foodNameSnapshot) { this.foodNameSnapshot = foodNameSnapshot; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
}