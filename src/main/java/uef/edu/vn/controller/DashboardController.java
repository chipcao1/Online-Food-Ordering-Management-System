package uef.edu.vn.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import uef.edu.vn.service.StatisticsService;

@Controller
@RequestMapping("/admin/dashboard") // Đồng bộ đường dẫn Admin
public class DashboardController {

    @Autowired
    private StatisticsService statisticsService;

    @GetMapping
    public String dashboard(Model model) {
        
        // Truyền các biến thống kê ra View
        model.addAttribute("dailyRevenue", statisticsService.getTodayRevenue());
        model.addAttribute("monthlyRevenue", statisticsService.getCurrentMonthRevenue());
        model.addAttribute("yearlyRevenue", statisticsService.getCurrentYearRevenue());
        model.addAttribute("topFoods", statisticsService.getTopSellingFoods());
        model.addAttribute("topCustomers", statisticsService.getTopCustomers());

        // Sử dụng cấu trúc Layout Admin
        model.addAttribute("body", "/WEB-INF/views/admin/dashboard.jsp");
        return "admin/layouts/main";
    }
}