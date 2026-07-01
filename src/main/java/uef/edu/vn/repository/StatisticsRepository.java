package uef.edu.vn.repository;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class StatisticsRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public Integer getTotalOrders() {
        try {
            return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM orders", Integer.class);
        } catch (Exception e) { return 0; }
    }

    public Integer getTotalCustomers() {
        try {
            return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM customer", Integer.class);
        } catch (Exception e) { return 0; }
    }

    public Integer getTotalFoods() {
        try {
            return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM food_item", Integer.class);
        } catch (Exception e) { return 0; }
    }

    public Integer getCompletedOrders() {
        try {
            return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM orders WHERE status='COMPLETED'", Integer.class);
        } catch (Exception e) { return 0; }
    }

    public Integer getPendingOrders() {
        try {
            return jdbcTemplate.queryForObject("SELECT COUNT(*) FROM orders WHERE status='PENDING'", Integer.class);
        } catch (Exception e) { return 0; }
    }

    public BigDecimal getTodayRevenue() {
        try {
            String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                         "WHERE DATE(created_at) = CURDATE() " +
                         "AND payment_status = 'PAID' AND status != 'CANCELED'";
            return jdbcTemplate.queryForObject(sql, BigDecimal.class);
        } catch (Exception e) { return BigDecimal.ZERO; }
    }

    public BigDecimal getCurrentMonthRevenue() {
        try {
            String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                         "WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE()) " +
                         "AND payment_status = 'PAID' AND status != 'CANCELED'";
            return jdbcTemplate.queryForObject(sql, BigDecimal.class);
        } catch (Exception e) { return BigDecimal.ZERO; }
    }

    public BigDecimal getCurrentYearRevenue() {
        try {
            String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                         "WHERE YEAR(created_at) = YEAR(CURDATE()) " +
                         "AND payment_status = 'PAID' AND status != 'CANCELED'";
            return jdbcTemplate.queryForObject(sql, BigDecimal.class);
        } catch (Exception e) { return BigDecimal.ZERO; }
    }

    // Lấy TẤT CẢ món có stock_quantity < 10 (không lọc is_active, không giới hạn số lượng)
    public List<Object[]> getLowStockFoods() {
        try {
            String sql = "SELECT food_name, stock_quantity FROM food_item " +
                         "WHERE stock_quantity < 10 " +
                         "ORDER BY stock_quantity ASC";
            return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
                rs.getString("food_name"),
                rs.getInt("stock_quantity")
            });
        } catch (Exception e) { return new ArrayList<>(); }
    }

    public List<Object[]> getTopSellingFoods() {
        try {
            String sql = "SELECT oi.food_name_snapshot, SUM(oi.quantity) AS total_quantity " +
                         "FROM order_items oi " +
                         "JOIN orders o ON oi.order_id = o.id " +
                         "WHERE o.status != 'CANCELED' " +
                         "GROUP BY oi.food_name_snapshot " +
                         "ORDER BY total_quantity DESC LIMIT 5";
            return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
                rs.getString("food_name_snapshot"),
                rs.getInt("total_quantity")
            });
        } catch (Exception e) { return new ArrayList<>(); }
    }

    public List<Object[]> getTopCustomers() {
        try {
            String sql = "SELECT c.full_name, COUNT(o.id) as total_orders FROM customer c INNER JOIN orders o ON c.id = o.customer_id GROUP BY c.id, c.full_name ORDER BY total_orders DESC LIMIT 5";
            return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
                rs.getString("full_name"),
                rs.getInt("total_orders")
            });
        } catch (Exception e) { return new ArrayList<>(); }
    }
}
