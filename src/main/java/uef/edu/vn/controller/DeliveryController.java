package uef.edu.vn.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import uef.edu.vn.service.DeliveryService;

@Controller
@RequestMapping("/admin/deliveries")
public class DeliveryController {

    @Autowired
    private DeliveryService deliveryService;

    private static final String PATH      = "/WEB-INF/views/admin/deliveries/";
    private static final String VIEW_PATH = "admin/layouts/main";

    @GetMapping
    public String getAllDeliveries(Model model) {
        model.addAttribute("deliveries", deliveryService.getAllDeliveries());
        model.addAttribute("body", PATH + "list.jsp");
        return VIEW_PATH;
    }

    // ĐÃ SỬA: bỏ getDeliveryById() trỏ vào detail.jsp không tồn tại
    // Thay bằng redirect về danh sách để tránh lỗi 500

    @PostMapping("/update-status")
    public String updateStatus(@RequestParam("id") Long id, @RequestParam("status") String status) {
        deliveryService.updateStatus(id, status);
        return "redirect:/admin/deliveries";
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") Long id) {
        deliveryService.delete(id);
        return "redirect:/admin/deliveries";
    }
}
