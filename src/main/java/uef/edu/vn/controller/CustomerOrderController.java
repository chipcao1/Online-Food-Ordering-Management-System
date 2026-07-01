package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import uef.edu.vn.model.Account;
import uef.edu.vn.model.Order;
import uef.edu.vn.repository.OrderRepository;
import uef.edu.vn.service.OrderService;

@Controller
public class CustomerOrderController {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderService orderService;

    @GetMapping("/my-orders")
    public String myOrders(HttpSession session, Model model) {
        Account loggedInUser = (Account) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/login";

        model.addAttribute("orders", orderRepository.findByCustomerId(loggedInUser.getId()));
        model.addAttribute("body", "/WEB-INF/views/customer/my-orders.jsp");
        return "customer/layouts/main";
    }

    /**
     * Chi tiết đơn hàng cho Customer.
     * Bảo mật: chỉ xem được đơn hàng của chính mình.
     */
    @GetMapping("/order-detail")
    public String orderDetail(@RequestParam("id") Long id, HttpSession session, Model model) {
        Account loggedInUser = (Account) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/login";

        Order order = orderService.getOrderById(id); // loads items
        if (order == null) return "redirect:/my-orders";

        // Kiểm tra đơn hàng thuộc về đúng customer đang đăng nhập
        if (order.getCustomer() == null || !order.getCustomer().getId().equals(loggedInUser.getId())) {
            return "redirect:/my-orders";
        }

        model.addAttribute("order", order);
        model.addAttribute("body", "/WEB-INF/views/customer/order-detail.jsp");
        return "customer/layouts/main";
    }

    /**
     * Hủy đơn hàng — chỉ cho phép khi status = PENDING và đúng chủ đơn.
     */
    @PostMapping("/cancel-order")
    public String cancelOrder(@RequestParam("id") Long id, HttpSession session) {
        Account loggedInUser = (Account) session.getAttribute("loggedInUser");
        if (loggedInUser == null) return "redirect:/login";

        Order order = orderRepository.findById(id);
        if (order == null) return "redirect:/my-orders";

        // Bảo mật: chỉ hủy đơn của chính mình
        if (order.getCustomer() == null || !order.getCustomer().getId().equals(loggedInUser.getId())) {
            return "redirect:/my-orders";
        }

        // Chỉ hủy được khi đơn đang ở trạng thái PENDING
        if (order.getStatus() != null && "PENDING".equals(order.getStatus().name())) {
            orderRepository.updateStatus(id, "CANCELED");
        }

        return "redirect:/order-detail?id=" + id;
    }
}
