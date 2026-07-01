package uef.edu.vn.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<CartItem> items;
    private BigDecimal totalAmount;

    public Cart() {
        this.items = new ArrayList<>();
        this.totalAmount = BigDecimal.ZERO;
    }

    public void addItem(FoodItem foodItem, int quantity) {
        if (quantity <= 0) return;
        for (CartItem item : items) {
            if (item.getFoodItem().getId().equals(foodItem.getId())) {
                item.setQuantity(item.getQuantity() + quantity);
                calculateTotal();
                return;
            }
        }
        items.add(new CartItem(foodItem, quantity));
        calculateTotal();
    }

    public void removeItem(Long foodItemId) {
        items.removeIf(item -> item.getFoodItem().getId().equals(foodItemId));
        calculateTotal();
    }

    // ĐÃ SỬA: đổi thành public để CartController có thể gọi sau khi update quantity qua stream
    public void recalculate() {
        calculateTotal();
    }

    private void calculateTotal() {
        totalAmount = BigDecimal.ZERO;
        for (CartItem item : items) {
            if (item.getSubtotal() != null) {
                totalAmount = totalAmount.add(item.getSubtotal());
            }
        }
    }

    public List<CartItem> getItems() { return items; }
    public BigDecimal getTotalAmount() { return totalAmount; }
}
