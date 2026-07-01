package uef.edu.vn.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Min;

public class Category {

    private Long id; // Đã đổi sang Long

    @NotBlank(message = "Tên danh mục không được để trống")
    private String categoryName;

    private String description;
    
    private String imageUrl;
    
    @Min(value = 0, message = "Thứ tự hiển thị phải lớn hơn hoặc bằng 0")
    private int displayOrder;
    
    private boolean active = true;

    public Category() {
    }

    public Category(Long id, String categoryName, String description, String imageUrl, int displayOrder, boolean active) {
        this.id = id;
        this.categoryName = categoryName;
        this.description = description;
        this.imageUrl = imageUrl;
        this.displayOrder = displayOrder;
        this.active = active;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}