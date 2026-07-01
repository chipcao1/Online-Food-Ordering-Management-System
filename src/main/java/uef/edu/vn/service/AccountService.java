package uef.edu.vn.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.model.Account;
import uef.edu.vn.model.Customer;
import uef.edu.vn.model.Role;
import uef.edu.vn.enums.RoleName;
import uef.edu.vn.repository.AccountRepository;
import uef.edu.vn.repository.CustomerRepository;
import java.util.List;

@Service
public class AccountService {

    @Autowired private AccountRepository accountRepository;
    @Autowired private CustomerRepository customerRepository;

    public Account login(String username, String password) {
        Account account = accountRepository.findByUsername(username);
        if (account != null && account.isActive() && account.getPassword().equals(password)) {
            return account;
        }
        return null;
    }

    /**
     * Đăng ký từ trang public.
     * @return "ok" hoặc thông báo lỗi cụ thể
     */
    public String register(String username, String email, String phone,
                           String password, String fullName, String address) {
        if (username == null || username.trim().length() < 3)
            return "Tên đăng nhập phải có ít nhất 3 ký tự";
        if (phone == null || !phone.matches("^0\\d{9}$"))
            return "Số điện thoại không hợp lệ (phải 10 chữ số, bắt đầu bằng 0)";
        if (fullName == null || fullName.isBlank())
            return "Họ tên không được để trống";
        if (fullName.matches(".*\\d.*"))
            return "Họ tên không được chứa ký tự số";
        if (password == null || password.length() < 6)
            return "Mật khẩu phải có ít nhất 6 ký tự";
        if (email == null || email.isBlank())
            return "Email không được để trống";
        if (accountRepository.findByUsername(username) != null)
            return "Tên đăng nhập đã tồn tại";
        if (accountRepository.findByEmail(email) != null)
            return "Email đã được sử dụng";
        if (accountRepository.findByPhone(phone) != null)
            return "Số điện thoại đã được đăng ký";

        Long customerRoleId = accountRepository.findRoleIdByName(RoleName.CUSTOMER);
        if (customerRoleId == null) return "Lỗi hệ thống: Không tìm thấy Role CUSTOMER";

        Account newAccount = new Account();
        newAccount.setUsername(username.trim());
        newAccount.setEmail(email);
        newAccount.setPhone(phone);
        newAccount.setPassword(password);

        Long newId = accountRepository.saveAndGetId(newAccount, customerRoleId);
        if (newId == null) return "Lỗi hệ thống: Không thể tạo tài khoản";

        Customer customer = new Customer();
        customer.setId(newId);
        customer.setFullName(fullName);
        customer.setAddress(address != null ? address : "");
        customerRepository.add(customer);

        return "ok";
    }

    public List<Account> getAll() { return accountRepository.findAll(); }
    public Account getById(Long id) { return accountRepository.findById(id); }
    public List<Role> getAllRoles() { return accountRepository.findAllRoles(); }

    public void updateRoleAndStatus(Long id, Long roleId, boolean active) {
        accountRepository.updateRoleAndStatus(id, roleId, active);
    }

    public void deleteAccount(Long id) {
        accountRepository.deleteById(id);
    }

    /**
     * Admin tạo tài khoản mới — trả về "ok" hoặc thông báo lỗi.
     * Nhận thêm fullName và address để tạo Customer record đúng.
     */
    public String createAccountWithRole(Account account, Long roleId,
                                        String fullName, String address) {
        if (account.getUsername() == null || account.getUsername().trim().length() < 3)
            return "Username phải có ít nhất 3 ký tự!";
        if (account.getPassword() == null || account.getPassword().length() < 6)
            return "Mật khẩu phải có ít nhất 6 ký tự!";
        if (account.getEmail() == null || account.getEmail().isBlank())
            return "Email không được để trống!";

        if (accountRepository.findByUsername(account.getUsername()) != null)
            return "Username \"" + account.getUsername() + "\" đã tồn tại!";
        if (accountRepository.findByEmail(account.getEmail()) != null)
            return "Email \"" + account.getEmail() + "\" đã được sử dụng!";
        if (account.getPhone() != null && !account.getPhone().isBlank()) {
            if (!account.getPhone().matches("^0\\d{9}$"))
                return "Số điện thoại phải 10 chữ số, bắt đầu bằng 0!";
            if (accountRepository.findByPhone(account.getPhone()) != null)
                return "Số điện thoại \"" + account.getPhone() + "\" đã được đăng ký!";
        }

        account.setUsername(account.getUsername().trim());
        Long newId = accountRepository.saveAndGetId(account, roleId);
        if (newId == null) return "Lỗi hệ thống: Không thể lưu tài khoản!";

        // Nếu role = CUSTOMER → tạo customer record với đúng ID + fullName
        Long customerRoleId = accountRepository.findRoleIdByName(RoleName.CUSTOMER);
        if (customerRoleId != null && customerRoleId.equals(roleId)) {
            String displayName = (fullName != null && !fullName.isBlank())
                    ? fullName
                    : account.getUsername();
            Customer customer = new Customer();
            customer.setId(newId);
            customer.setFullName(displayName);
            customer.setAddress(address != null ? address : "");
            customerRepository.add(customer);
        }

        return "ok";
    }
}
