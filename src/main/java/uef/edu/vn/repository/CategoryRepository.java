package uef.edu.vn.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import uef.edu.vn.model.Category;

@Repository
public class CategoryRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private Category mapRow(ResultSet rs, int rowNum) throws SQLException {
        Category category = new Category();
        category.setId(rs.getLong("Id"));
        category.setCategoryName(rs.getString("CategoryName"));
        category.setDescription(rs.getString("Description"));
        category.setImageUrl(rs.getString("ImageUrl"));
        category.setDisplayOrder(rs.getInt("DisplayOrder"));
        category.setActive(rs.getBoolean("Active"));
        return category;
    }

    public List<Category> findAll() {
        return jdbcTemplate.query("SELECT * FROM Categories ORDER BY DisplayOrder ASC", this::mapRow);
    }

    // ĐÃ SỬA: dùng query() + isEmpty() thay queryForObject() để tránh EmptyResultDataAccessException
    public Category findById(Long id) {
        String sql = "SELECT * FROM Categories WHERE Id = ?";
        List<Category> list = jdbcTemplate.query(sql, this::mapRow, id);
        return list.isEmpty() ? null : list.get(0);
    }

    public void save(Category category) {
        String sql = "INSERT INTO Categories (CategoryName, Description, ImageUrl, DisplayOrder, Active) VALUES (?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                category.getCategoryName(), category.getDescription(),
                category.getImageUrl(), category.getDisplayOrder(), category.isActive());
    }

    public void update(Category category) {
        String sql = "UPDATE Categories SET CategoryName=?, Description=?, ImageUrl=?, DisplayOrder=?, Active=? WHERE Id=?";
        jdbcTemplate.update(sql,
                category.getCategoryName(), category.getDescription(),
                category.getImageUrl(), category.getDisplayOrder(), category.isActive(),
                category.getId());
    }

    public void delete(Long id) {
        jdbcTemplate.update("DELETE FROM Categories WHERE Id=?", id);
    }

    public List<Category> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return findAll();
        String sql = "SELECT * FROM Categories WHERE CategoryName LIKE ? ORDER BY DisplayOrder ASC";
        return jdbcTemplate.query(sql, this::mapRow, "%" + keyword + "%");
    }
}
