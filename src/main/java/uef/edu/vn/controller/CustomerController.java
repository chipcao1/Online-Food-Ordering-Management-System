package uef.edu.vn.controller;

import jakarta.validation.Valid;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import uef.edu.vn.model.Customer;
import uef.edu.vn.service.CustomerService;

@Controller
@RequestMapping("/admin/customers")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    // CHUẨN HÓA ĐƯỜNG DẪN
    private final String PATH = "/WEB-INF/views/admin/customers/";
    private final String VIEW_PATH = "admin/layouts/main";

    @GetMapping
    public String list(@RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "keyword", required = false) String keyword,
            Model model) {
        
        int size = 5;
        List<Customer> paginatedCustomers = customerService.getCustomersByPage(keyword, page, size);
        int totalPages = customerService.countPages(keyword, size);

        model.addAttribute("customers", paginatedCustomers);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("currentPage", page);
        model.addAttribute("keyword", keyword);
        
        // SỬA: Đã thêm 'admin/customers' vào đường dẫn
        model.addAttribute("body", PATH + "list.jsp");
        return VIEW_PATH;
    }

    @GetMapping("/add")
    public String add(Model model) {
        model.addAttribute("customer", new Customer());
        model.addAttribute("body", PATH + "form.jsp");
        return VIEW_PATH;
    }

    @PostMapping("/save")
    public String save(@ModelAttribute("customer") @Valid Customer customer, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("body", PATH + "form.jsp");
            return VIEW_PATH;
        }
        
        if (customer.getId() == null || customer.getId() == 0) {
            customerService.add(customer);
        } else {
            customerService.update(customer);
        }
        return "redirect:/admin/customers"; // SỬA: Thêm /admin
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        model.addAttribute("customer", customerService.findById(id));
        model.addAttribute("body", PATH + "form.jsp");
        return VIEW_PATH;
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        customerService.deleteById(id);
        return "redirect:/admin/customers"; // SỬA: Thêm /admin
    }
}