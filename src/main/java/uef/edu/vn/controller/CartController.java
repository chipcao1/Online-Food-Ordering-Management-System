package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import uef.edu.vn.model.Account;
import uef.edu.vn.model.Cart;
import uef.edu.vn.model.Customer;
import uef.edu.vn.model.FoodItem;
import uef.edu.vn.repository.CustomerRepository;
import uef.edu.vn.service.FoodItemService;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private FoodItemService foodItemService;

    @Autowired
    private CustomerRepository customerRepository;

    private Cart getCartFromSession(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        model.addAttribute("cart", getCartFromSession(session));

        // Pre-fill checkout form với dữ liệu đã đăng ký
        Account user = (Account) session.getAttribute("loggedInUser");
        if (user != null) {
            Customer customer = customerRepository.findById(user.getId());
            if (customer != null) {
                model.addAttribute("prefillAddress", customer.getAddress() != null ? customer.getAddress() : "");
                model.addAttribute("prefillPhone",
                    (customer.getPhone() != null && !customer.getPhone().isBlank())
                        ? customer.getPhone()
                        : (user.getPhone() != null ? user.getPhone() : ""));
            } else {
                // Không có record customer (ví dụ admin/staff xem giỏ) — dùng phone từ account
                model.addAttribute("prefillAddress", "");
                model.addAttribute("prefillPhone", user.getPhone() != null ? user.getPhone() : "");
            }
        }

        model.addAttribute("body", "/WEB-INF/views/customer/cart.jsp");
        return "customer/layouts/main";
    }

    @PostMapping("/add")
    public String addToCart(@RequestParam("foodId") Long foodId,
                            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                            HttpSession session) {
        FoodItem food = foodItemService.getById(foodId);
        if (food != null && food.isActive()) {
            getCartFromSession(session).addItem(food, quantity);
        }
        return "redirect:/menu";
    }

    @PostMapping("/remove")
    public String removeFromCart(@RequestParam("foodId") Long foodId, HttpSession session) {
        getCartFromSession(session).removeItem(foodId);
        return "redirect:/cart";
    }

    /**
     * ĐÃ SỬA: sau khi cập nhật quantity qua stream, gọi cart.recalculate()
     * để cập nhật totalAmount trong session.
     */
    @PostMapping("/update")
    public String updateQuantity(@RequestParam("foodId") Long foodId,
                                 @RequestParam("quantity") int quantity,
                                 HttpSession session) {
        Cart cart = getCartFromSession(session);
        if (quantity <= 0) {
            cart.removeItem(foodId);
        } else {
            cart.getItems().stream()
                .filter(item -> item.getFoodItem().getId().equals(foodId))
                .findFirst()
                .ifPresent(item -> item.setQuantity(quantity));
            // ĐÃ THÊM: recalculate tổng tiền sau khi stream update
            cart.recalculate();
        }
        return "redirect:/cart";
    }
}
