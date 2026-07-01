package uef.edu.vn.model;

import java.math.BigDecimal;

public class CartItem {
    private FoodItem foodItem;
    private int quantity;
    private BigDecimal subtotal;

    public CartItem() {}

    public CartItem(FoodItem foodItem, int quantity) {
        this.foodItem = foodItem;
        this.quantity = quantity;
        calculateSubtotal();
    }

    public void calculateSubtotal() {
        if (foodItem != null && foodItem.getBasePrice() != null) {
            // Nếu có giá khuyến mãi thì lấy giá khuyến mãi, không thì lấy giá gốc
            BigDecimal currentPrice = (foodItem.getSalePrice() != null && foodItem.getSalePrice().compareTo(BigDecimal.ZERO) > 0) 
                                      ? foodItem.getSalePrice() 
                                      : foodItem.getBasePrice();
                                      
            this.subtotal = currentPrice.multiply(new BigDecimal(this.quantity));
        }
    }

    // Getters and Setters
    public FoodItem getFoodItem() { return foodItem; }
    public void setFoodItem(FoodItem foodItem) { this.foodItem = foodItem; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { 
        this.quantity = quantity; 
        calculateSubtotal(); // Tính lại tiền mỗi khi đổi số lượng
    }
    
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
}