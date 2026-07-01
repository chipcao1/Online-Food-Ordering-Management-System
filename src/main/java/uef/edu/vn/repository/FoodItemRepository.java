package uef.edu.vn.repository;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Category;
import uef.edu.vn.model.FoodItem;

@Repository
public class FoodItemRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // BASE SQL: JOIN với bảng "Categories" (tên thực trong DB), alias cột về snake_case
    private static final String BASE_SQL =
        "SELECT fi.*, c.Id AS cat_id, c.CategoryName AS category_name " +
        "FROM food_item fi LEFT JOIN Categories c ON fi.category_id = c.Id";

    private FoodItem mapRow(ResultSet rs, int rowNum) throws SQLException {
        FoodItem foodItem = new FoodItem();
        foodItem.setId(rs.getLong("id"));

        // Map category kèm tên từ JOIN
        long categoryId = rs.getLong("category_id");
        if (!rs.wasNull()) {
            Category category = new Category();
            category.setId(categoryId);
            category.setCategoryName(rs.getString("category_name"));
            foodItem.setCategory(category);
        }

        foodItem.setFoodName(rs.getString("food_name"));
        foodItem.setDescription(rs.getString("description"));
        foodItem.setBasePrice(rs.getBigDecimal("base_price"));
        foodItem.setSalePrice(rs.getBigDecimal("sale_price"));
        foodItem.setStockQuantity(rs.getInt("stock_quantity"));
        foodItem.setUnit(rs.getString("unit"));
        foodItem.setThumbnailUrl(rs.getString("thumbnail_url"));
        foodItem.setFeatured(rs.getBoolean("is_featured"));
        foodItem.setActive(rs.getBoolean("is_active"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) foodItem.setCreatedAt(createdAt.toLocalDateTime());
        return foodItem;
    }

    public List<FoodItem> findAll() {
        return jdbcTemplate.query(BASE_SQL, this::mapRow);
    }

    public FoodItem findById(Long id) {
        String sql = BASE_SQL + " WHERE fi.id = ?";
        List<FoodItem> list = jdbcTemplate.query(sql, this::mapRow, id);
        return list.isEmpty() ? null : list.get(0);
    }

    public void save(FoodItem f) {
        String sql = "INSERT INTO food_item (category_id, food_name, description, base_price, sale_price, stock_quantity, unit, thumbnail_url, is_featured, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                f.getCategory() != null ? f.getCategory().getId() : null,
                f.getFoodName(), f.getDescription(), f.getBasePrice(), f.getSalePrice(),
                f.getStockQuantity(), f.getUnit(), f.getThumbnailUrl(), f.isFeatured(), f.isActive());
    }

    public void update(FoodItem f) {
        String sql = "UPDATE food_item SET category_id = ?, food_name = ?, description = ?, base_price = ?, sale_price = ?, stock_quantity = ?, unit = ?, thumbnail_url = ?, is_featured = ?, is_active = ? WHERE id = ?";
        jdbcTemplate.update(sql,
                f.getCategory() != null ? f.getCategory().getId() : null,
                f.getFoodName(), f.getDescription(), f.getBasePrice(), f.getSalePrice(),
                f.getStockQuantity(), f.getUnit(), f.getThumbnailUrl(), f.isFeatured(), f.isActive(), f.getId());
    }

    public void delete(Long id) {
        String sql = "DELETE FROM food_item WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }

    public List<FoodItem> search(String keyword, Long categoryId) {
        StringBuilder sql = new StringBuilder(BASE_SQL + " WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (fi.food_name LIKE ? OR fi.description LIKE ?)");
            String kw = "%" + keyword + "%";
            params.add(kw);
            params.add(kw);
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND fi.category_id = ?");
            params.add(categoryId);
        }
        return jdbcTemplate.query(sql.toString(), this::mapRow, params.toArray());
    }
}