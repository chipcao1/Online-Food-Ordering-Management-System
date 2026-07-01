package uef.edu.vn.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import uef.edu.vn.model.*;
import uef.edu.vn.enums.*;
import uef.edu.vn.repository.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Random;

@Controller
public class CheckoutController {

    @Autowired private OrderRepository orderRepository;
    @Autowired private OrderItemRepository orderItemRepository;

    @PostMapping("/checkout")
    public String processCheckout(
            @RequestParam("address") String address,
            @RequestParam("phone") String phone,
            @RequestParam("paymentMethod") String paymentMethodStr,
            @RequestParam(value = "note", defaultValue = "") String note,
            HttpSession session, Model model) {

        Account user = (Account) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) return "redirect:/menu";

        // Validate phone
        if (phone == null || !phone.matches("^0\\d{9}$")) {
            model.addAttribute("error", "Số điện thoại không hợp lệ.");
            model.addAttribute("cart", cart);
            model.addAttribute("body", "/WEB-INF/views/customer/cart.jsp");
            return "customer/layouts/main";
        }

        // Build Order
        String orderCode = "ORD-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmm"))
                + "-" + (new Random().nextInt(9000) + 1000);

        Order order = new Order();
        order.setOrderCode(orderCode);
        Customer customer = new Customer();
        customer.setId(user.getId());
        order.setCustomer(customer);
        order.setDeliveryAddress(address);
        order.setDeliveryPhone(phone);
        order.setNote(note);
        order.setStatus(OrderStatus.PENDING);

        PaymentMethod paymentMethod;
        try {
            paymentMethod = PaymentMethod.valueOf(paymentMethodStr);
        } catch (IllegalArgumentException e) {
            paymentMethod = PaymentMethod.COD;
        }
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus(PaymentStatus.UNPAID);

        BigDecimal shippingFee = new BigDecimal("5.00");
        order.setSubtotal(cart.getTotalAmount());
        order.setShippingFee(shippingFee);
        order.setDiscountAmount(BigDecimal.ZERO);
        order.setTotalAmount(cart.getTotalAmount().add(shippingFee));

        orderRepository.save(order);

        // Load saved order to get auto-generated ID
        Order savedOrder = orderRepository.findByOrderCode(orderCode);
        if (savedOrder != null) {
            for (CartItem cartItem : cart.getItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(savedOrder.getId());
                orderItem.setFoodItem(cartItem.getFoodItem());
                orderItem.setFoodNameSnapshot(cartItem.getFoodItem().getFoodName());
                orderItem.setQuantity(cartItem.getQuantity());
                BigDecimal price = (cartItem.getFoodItem().getSalePrice() != null
                        && cartItem.getFoodItem().getSalePrice().compareTo(BigDecimal.ZERO) > 0)
                        ? cartItem.getFoodItem().getSalePrice()
                        : cartItem.getFoodItem().getBasePrice();
                orderItem.setUnitPrice(price);
                orderItem.setSubtotal(cartItem.getSubtotal());
                orderItemRepository.save(orderItem);
            }
            // Load items để hiển thị trên hóa đơn
            List<OrderItem> items = orderItemRepository.findByOrderId(savedOrder.getId());
            savedOrder.setItems(items);
            model.addAttribute("order", savedOrder);
        }

        session.removeAttribute("cart");

        model.addAttribute("body", "/WEB-INF/views/customer/invoice.jsp");
        return "customer/layouts/main";
    }
}
