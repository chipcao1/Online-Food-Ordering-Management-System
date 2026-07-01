package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import uef.edu.vn.model.Account;
import uef.edu.vn.service.AccountService;

@Controller
public class AuthController {

    @Autowired
    private AccountService accountService;

    @GetMapping("/login")
    public String loginPage() {
        return "admin/auth/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password,
                        HttpSession session, Model model) {
        Account account = accountService.login(username, password);
        if (account != null) {
            session.setAttribute("loggedInUser", account);
            String roleStr = account.getRole() != null && account.getRole().getRoleName() != null
                    ? account.getRole().getRoleName().name() : "CUSTOMER";
            session.setAttribute("role", roleStr);

            switch (roleStr) {
                case "ADMIN":   return "redirect:/admin/dashboard";
                case "MANAGER": return "redirect:/admin/dashboard";
                case "STAFF":   return "redirect:/admin/orders";
                case "DELIVERY_STAFF": return "redirect:/admin/deliveries";
                case "CUSTOMER": return "redirect:/menu";
                default:        return "redirect:/login";
            }
        }
        model.addAttribute("error", "Sai tên đăng nhập hoặc mật khẩu, hoặc tài khoản đã bị khóa!");
        return "admin/auth/login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "admin/auth/register";
    }

    /**
     * ĐÃ SỬA: thêm fullName, address để tạo bản ghi Customer sau khi đăng ký.
     * Service trả về "ok" hoặc thông báo lỗi cụ thể.
     */
    @PostMapping("/register")
    public String register(
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam String password,
            @RequestParam(defaultValue = "") String fullName,
            @RequestParam(defaultValue = "") String address,
            Model model) {

        String result = accountService.register(username, email, phone, password, fullName, address);

        if ("ok".equals(result)) {
            return "redirect:/login?registered=true";
        }

        model.addAttribute("error", result);
        return "admin/auth/register";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
