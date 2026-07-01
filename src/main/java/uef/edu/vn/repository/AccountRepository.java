package uef.edu.vn.repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import uef.edu.vn.model.Account;
import uef.edu.vn.model.Role;
import uef.edu.vn.enums.RoleName;

@Repository
public class AccountRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private Account mapRow(ResultSet rs, int rowNum) throws SQLException {
        Account acc = new Account();
        acc.setId(rs.getLong("id"));
        acc.setUsername(rs.getString("username"));
        acc.setPassword(rs.getString("password_hash"));
        acc.setEmail(rs.getString("email"));
        // ĐÃ FIX: phone giờ có trong bảng account
        acc.setPhone(rs.getString("phone"));
        acc.setActive(rs.getBoolean("active"));

        Role role = new Role();
        role.setId(rs.getLong("role_id"));
        String roleNameStr = rs.getString("role_name");
        if (roleNameStr != null) role.setRoleName(RoleName.valueOf(roleNameStr));
        acc.setRole(role);
        return acc;
    }

    public Account findByUsername(String username) {
        String sql = "SELECT a.*, r.role_name FROM account a JOIN `role` r ON a.role_id = r.id WHERE a.username = ?";
        List<Account> list = jdbcTemplate.query(sql, this::mapRow, username);
        return list.isEmpty() ? null : list.get(0);
    }

    public Account findByEmail(String email) {
        String sql = "SELECT a.*, r.role_name FROM account a JOIN `role` r ON a.role_id = r.id WHERE a.email = ?";
        List<Account> list = jdbcTemplate.query(sql, this::mapRow, email);
        return list.isEmpty() ? null : list.get(0);
    }

    public Account findByPhone(String phone) {
        String sql = "SELECT a.*, r.role_name FROM account a JOIN `role` r ON a.role_id = r.id WHERE a.phone = ?";
        List<Account> list = jdbcTemplate.query(sql, this::mapRow, phone);
        return list.isEmpty() ? null : list.get(0);
    }

    public Account findById(Long id) {
        String sql = "SELECT a.*, r.role_name FROM account a JOIN `role` r ON a.role_id = r.id WHERE a.id = ?";
        List<Account> list = jdbcTemplate.query(sql, this::mapRow, id);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Account> findAll() {
        String sql = "SELECT a.*, r.role_name FROM account a JOIN `role` r ON a.role_id = r.id ORDER BY a.id ASC";
        return jdbcTemplate.query(sql, this::mapRow);
    }

    public Long findRoleIdByName(RoleName roleName) {
        List<Long> ids = jdbcTemplate.queryForList("SELECT id FROM `role` WHERE role_name = ?", Long.class, roleName.name());
        return ids.isEmpty() ? null : ids.get(0);
    }

    // Lưu và trả về ID được sinh ra (dùng khi đăng ký để tạo customer cùng ID)
    public Long saveAndGetId(Account account, Long roleId) {
        String sql = "INSERT INTO account(username, password_hash, email, phone, role_id, active) VALUES(?,?,?,?,?,?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, account.getUsername());
            ps.setString(2, account.getPassword());
            ps.setString(3, account.getEmail());
            ps.setString(4, account.getPhone());
            ps.setObject(5, roleId);
            ps.setBoolean(6, true);
            return ps;
        }, keyHolder);
        Number key = keyHolder.getKey();
        return key != null ? key.longValue() : null;
    }

    // Giữ lại hàm save cũ dùng cho admin tạo account (không cần lấy ID)
    public void save(Account account, Long roleId) {
        String sql = "INSERT INTO account(username, password_hash, email, phone, role_id, active) VALUES(?,?,?,?,?,?)";
        jdbcTemplate.update(sql,
                account.getUsername(), account.getPassword(), account.getEmail(),
                account.getPhone(), roleId, true);
    }

    public List<Role> findAllRoles() {
        return jdbcTemplate.query("SELECT * FROM `role`", (rs, rowNum) -> {
            Role r = new Role();
            r.setId(rs.getLong("id"));
            r.setRoleName(RoleName.valueOf(rs.getString("role_name")));
            r.setDescription(rs.getString("description"));
            return r;
        });
    }

    public void updateRoleAndStatus(Long accountId, Long roleId, boolean active) {
        jdbcTemplate.update("UPDATE account SET role_id = ?, active = ? WHERE id = ?", roleId, active, accountId);
    }

    public void deleteById(Long id) {
        jdbcTemplate.update("DELETE FROM account WHERE id = ?", id);
    }

    // Lấy danh sách nhân viên giao hàng (DELIVERY_STAFF) đang active để gán shipper
    public List<uef.edu.vn.model.Employee> findDeliveryStaff() {
        String sql = "SELECT e.id, e.full_name, e.phone, e.email " +
                     "FROM employee e " +
                     "JOIN account a ON a.id = e.id " +
                     "JOIN `role` r ON a.role_id = r.id " +
                     "WHERE r.role_name = 'DELIVERY_STAFF' AND a.active = TRUE";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            uef.edu.vn.model.Employee emp = new uef.edu.vn.model.Employee();
            emp.setId(rs.getLong("id"));
            emp.setFullName(rs.getString("full_name"));
            emp.setPhone(rs.getString("phone"));
            emp.setEmail(rs.getString("email"));
            return emp;
        });
    }
}
