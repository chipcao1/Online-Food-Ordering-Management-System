package uef.edu.vn.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import uef.edu.vn.model.Account;
import uef.edu.vn.service.AccountService;

@Controller
@RequestMapping("/admin/accounts")
public class AccountController {

    @Autowired
    private AccountService accountService;

    private static final String PATH      = "/WEB-INF/views/admin/accounts/";
    private static final String VIEW_PATH = "admin/layouts/main";

    @GetMapping
    public String list(Model model) {
        model.addAttribute("accounts", accountService.getAll());
        model.addAttribute("body", PATH + "list.jsp");
        return VIEW_PATH;
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        model.addAttribute("account", accountService.getById(id));
        model.addAttribute("roles", accountService.getAllRoles());
        model.addAttribute("body", PATH + "form.jsp");
        return VIEW_PATH;
    }

    @PostMapping("/update")
    public String update(@RequestParam("id") Long id,
                         @RequestParam("roleId") Long roleId,
                         @RequestParam(value = "active", defaultValue = "false") boolean active) {
        accountService.updateRoleAndStatus(id, roleId, active);
        return "redirect:/admin/accounts";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        accountService.deleteAccount(id);
        return "redirect:/admin/accounts";
    }

    @GetMapping("/add")
    public String addAccountForm(Model model) {
        model.addAttribute("account", new Account());
        model.addAttribute("roles", accountService.getAllRoles());
        model.addAttribute("body", PATH + "add.jsp");
        return VIEW_PATH;
    }

    /**
     * Tạo account mới.
     * Nhận thêm fullName + address để tạo Customer record khi role = CUSTOMER.
     */
    @PostMapping("/saveNew")
    public String saveNew(@ModelAttribute Account account,
                          @RequestParam("roleId") Long roleId,
                          @RequestParam(value = "fullName", defaultValue = "") String fullName,
                          @RequestParam(value = "address",  defaultValue = "") String address,
                          Model model) {

        // Server-side validation
        if (account.getUsername() == null || account.getUsername().trim().length() < 3) {
            model.addAttribute("error", "Username phải có ít nhất 3 ký tự!");
            model.addAttribute("roles", accountService.getAllRoles());
            model.addAttribute("body", PATH + "add.jsp");
            return VIEW_PATH;
        }
        if (account.getPassword() == null || account.getPassword().length() < 6) {
            model.addAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            model.addAttribute("roles", accountService.getAllRoles());
            model.addAttribute("body", PATH + "add.jsp");
            return VIEW_PATH;
        }
        if (account.getEmail() == null || account.getEmail().isBlank()) {
            model.addAttribute("error", "Email không được để trống!");
            model.addAttribute("roles", accountService.getAllRoles());
            model.addAttribute("body", PATH + "add.jsp");
            return VIEW_PATH;
        }
        if (fullName.matches(".*\\d.*")) {
            model.addAttribute("error", "Họ tên không được chứa ký tự số!");
            model.addAttribute("roles", accountService.getAllRoles());
            model.addAttribute("body", PATH + "add.jsp");
            return VIEW_PATH;
        }

        String result = accountService.createAccountWithRole(account, roleId, fullName, address);
        if (!"ok".equals(result)) {
            model.addAttribute("error", result);
            model.addAttribute("roles", accountService.getAllRoles());
            model.addAttribute("body", PATH + "add.jsp");
            return VIEW_PATH;
        }
        return "redirect:/admin/accounts";
    }
}
