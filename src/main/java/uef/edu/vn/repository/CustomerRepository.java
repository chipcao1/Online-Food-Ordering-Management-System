package uef.edu.vn.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Customer;
import java.util.List;

@Repository
public class CustomerRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Customer> customerRowMapper = (rs, rowNum) -> {
        Customer customer = new Customer();
        customer.setId(rs.getLong("id"));
        customer.setFullName(rs.getString("full_name"));
        customer.setAddress(rs.getString("address"));
        // email và phone lấy từ account nếu JOIN, hoặc null nếu không có
        try { customer.setEmail(rs.getString("email")); } catch (Exception ignore) {}
        try { customer.setPhone(rs.getString("phone")); } catch (Exception ignore) {}
        return customer;
    };

    /**
     * ĐÃ SỬA: dùng LEFT JOIN để customer không có account vẫn hiển thị.
     * Đây đảm bảo customer vừa tạo (qua Account creation) luôn xuất hiện trong list.
     */
    public List<Customer> findCustomers(String keyword, int limit, int offset) {
        String base = "SELECT c.id, c.full_name, c.address, a.email, a.phone " +
                      "FROM customer c LEFT JOIN account a ON c.id = a.id";
        if (keyword != null && !keyword.isBlank()) {
            String sql = base + " WHERE (c.full_name LIKE ? OR a.email LIKE ? OR a.phone LIKE ?) " +
                         "ORDER BY c.id DESC LIMIT ? OFFSET ?";
            String kw = "%" + keyword.trim() + "%";
            return jdbcTemplate.query(sql, customerRowMapper, kw, kw, kw, limit, offset);
        } else {
            String sql = base + " ORDER BY c.id DESC LIMIT ? OFFSET ?";
            return jdbcTemplate.query(sql, customerRowMapper, limit, offset);
        }
    }

    public int countCustomers(String keyword) {
        if (keyword != null && !keyword.isBlank()) {
            String sql = "SELECT COUNT(c.id) FROM customer c LEFT JOIN account a ON c.id = a.id " +
                         "WHERE (c.full_name LIKE ? OR a.email LIKE ? OR a.phone LIKE ?)";
            String kw = "%" + keyword.trim() + "%";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, kw, kw, kw);
            return count != null ? count : 0;
        } else {
            Integer count = jdbcTemplate.queryForObject("SELECT COUNT(id) FROM customer", Integer.class);
            return count != null ? count : 0;
        }
    }

    public Customer findById(Long id) {
        String sql = "SELECT c.id, c.full_name, c.address, a.email, a.phone " +
                     "FROM customer c LEFT JOIN account a ON c.id = a.id WHERE c.id = ?";
        List<Customer> list = jdbcTemplate.query(sql, customerRowMapper, id);
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * ĐÃ SỬA: nếu customer.id != null và > 0 → INSERT với explicit id (từ account creation).
     * Nếu id null/0 → INSERT không có id → MySQL AUTO_INCREMENT.
     */
    public void add(Customer customer) {
        if (customer.getId() != null && customer.getId() > 0) {
            // Từ account creation: id = account.id (phải khớp để JOIN hoạt động)
            String sql = "INSERT INTO customer (id, full_name, address) VALUES (?, ?, ?)";
            jdbcTemplate.update(sql, customer.getId(), customer.getFullName(), customer.getAddress());
        } else {
            // Tạo trực tiếp từ admin form (không qua account)
            String sql = "INSERT INTO customer (full_name, address) VALUES (?, ?)";
            jdbcTemplate.update(sql, customer.getFullName(), customer.getAddress());
        }
    }

    public void update(Customer customer) {
        jdbcTemplate.update("UPDATE customer SET full_name = ?, address = ? WHERE id = ?",
                customer.getFullName(), customer.getAddress(), customer.getId());
        // Cập nhật email/phone trên account nếu account tồn tại
        jdbcTemplate.update("UPDATE account SET email = ?, phone = ? WHERE id = ?",
                customer.getEmail(), customer.getPhone(), customer.getId());
    }

    public void deleteById(Long id) {
        jdbcTemplate.update("DELETE FROM customer WHERE id = ?", id);
    }
}
