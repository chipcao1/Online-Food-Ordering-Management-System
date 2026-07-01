package uef.edu.vn.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import uef.edu.vn.model.Order;
import uef.edu.vn.enums.OrderStatus;
import uef.edu.vn.repository.AccountRepository;
import uef.edu.vn.repository.DeliveryRepository;
import uef.edu.vn.service.OrderService;

@Controller
@RequestMapping("/admin/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private DeliveryRepository deliveryRepository;

    @Autowired
    private AccountRepository accountRepository;

    // CHUẨN HÓA ĐƯỜNG DẪN (Viết hoa để đồng nhất)
    private final String PATH = "/WEB-INF/views/admin/orders/";
    private final String VIEW_PATH = "admin/layouts/main";

    @GetMapping
    public String list(
            @RequestParam(value = "keyword",       defaultValue = "") String keyword,
            @RequestParam(value = "status",        defaultValue = "") String status,
            @RequestParam(value = "paymentStatus", defaultValue = "") String paymentStatus,
            Model model) {

        boolean hasFilter = !keyword.isBlank() || !status.isBlank() || !paymentStatus.isBlank();
        model.addAttribute("orders",
            hasFilter ? orderService.search(keyword, status, paymentStatus)
                      : orderService.getAllOrders());
        model.addAttribute("keyword",       keyword);
        model.addAttribute("filterStatus",  status);
        model.addAttribute("filterPayment", paymentStatus);
        model.addAttribute("body", PATH + "list.jsp");
        return VIEW_PATH;
    }

    @GetMapping("/detail")
    public String detail(@RequestParam Long id, Model model) {
        Order order = orderService.getOrderById(id);
        model.addAttribute("order", order);
        // Truyền delivery record (nếu có) và danh sách shipper để gán
        model.addAttribute("delivery", deliveryRepository.findByOrderId(id));
        model.addAttribute("deliveryStaffs", accountRepository.findDeliveryStaff());
        model.addAttribute("body", PATH + "detail.jsp");
        return VIEW_PATH;
    }

    @PostMapping("/update-status")
    public String updateStatus(@RequestParam("id") Long id,
                               @RequestParam("status") String status,
                               @RequestParam(value = "fromDetail", defaultValue = "false") boolean fromDetail,
                               Model model) {
        // Ràng buộc: chuyển sang DELIVERING phải có shipper được gán trước
        if ("DELIVERING".equals(status)) {
            uef.edu.vn.model.Delivery delivery = deliveryRepository.findByOrderId(id);
            if (delivery == null || delivery.getDeliveryStaff() == null) {
                // Reload detail page with error
                Order order = orderService.getOrderById(id);
                model.addAttribute("order", order);
                model.addAttribute("delivery", delivery);
                model.addAttribute("deliveryStaffs", accountRepository.findDeliveryStaff());
                model.addAttribute("shipperError", "Vui lòng gán shipper trước khi chuyển sang trạng thái Đang giao.");
                model.addAttribute("body", PATH + "detail.jsp");
                return VIEW_PATH;
            }
        }
        orderService.updateStatus(id, status);
        // Nếu action từ trang detail thì redirect về detail, không thì về list
        if (fromDetail || "DELIVERING".equals(status) || "COMPLETED".equals(status)) {
            return "redirect:/admin/orders/detail?id=" + id;
        }
        return "redirect:/admin/orders";
    }

    @GetMapping("/delete")
    public String delete(@RequestParam Long id) {
        orderService.delete(id);
        return "redirect:/admin/orders"; // SỬA: Thêm /admin
    }

    // THÊM MỚI: Staff xác nhận thanh toán (Lập hóa đơn / xác nhận đã thu tiền)
    @PostMapping("/update-payment-status")
    public String updatePaymentStatus(@RequestParam("id") Long id,
                                      @RequestParam("paymentStatus") String paymentStatus) {
        orderService.updatePaymentStatus(id, paymentStatus);
        return "redirect:/admin/orders/detail?id=" + id;
    }

    // THÊM MỚI: Gán shipper cho đơn hàng
    @PostMapping("/assign-shipper")
    public String assignShipper(@RequestParam("orderId")    Long orderId,
                                @RequestParam("employeeId") Long employeeId) {
        deliveryRepository.assignShipper(orderId, employeeId);
        return "redirect:/admin/orders/detail?id=" + orderId;
    }
}