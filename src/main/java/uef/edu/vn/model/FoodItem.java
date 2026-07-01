// File: uef/edu/vn/model/FoodItem.java
package uef.edu.vn.model;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class FoodItem {
    private Long id;

    @NotNull(message = "Danh mục không được để trống")
    private Category category;

    @NotBlank(message = "Tên món ăn không được để trống")
    private String foodName;

    private String description;

    @NotNull(message = "Giá gốc không được để trống")
    @DecimalMin(value = "0.00", inclusive = true, message = "Giá gốc không được âm")
    private BigDecimal basePrice;

    @DecimalMin(value = "0.00", inclusive = true, message = "Giá sale không được âm")
    private BigDecimal salePrice;

    @Min(value = 0, message = "Số lượng tồn kho không được âm")
    private int stockQuantity;

    private String unit;
    private String thumbnailUrl;
    private boolean isFeatured;
    private boolean isActive = true;
    private LocalDateTime createdAt;

    public FoodItem() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }
    public BigDecimal getSalePrice() { return salePrice; }
    public void setSalePrice(BigDecimal salePrice) { this.salePrice = salePrice; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }
    public boolean isFeatured() { return isFeatured; }
    public void setFeatured(boolean featured) { isFeatured = featured; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
