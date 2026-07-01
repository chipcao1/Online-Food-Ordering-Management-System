package uef.edu.vn.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import uef.edu.vn.service.StatisticsService;

@Controller
@RequestMapping("/admin/reports")
public class ReportController {

    @Autowired
    private StatisticsService statisticsService;

    @GetMapping
    public String report(Model model) {

        model.addAttribute("totalOrders", statisticsService.getTotalOrders());
        model.addAttribute("totalCustomers", statisticsService.getTotalCustomers());
        model.addAttribute("totalFoods", statisticsService.getTotalFoods());
        model.addAttribute("completedOrders", statisticsService.getCompletedOrders());
        model.addAttribute("pendingOrders", statisticsService.getPendingOrders());
        model.addAttribute("lowStockFoods", statisticsService.getLowStockFoods());
        model.addAttribute("dailyRevenue", statisticsService.getTodayRevenue());
        model.addAttribute("monthlyRevenue", statisticsService.getCurrentMonthRevenue());
        model.addAttribute("yearlyRevenue", statisticsService.getCurrentYearRevenue());
        model.addAttribute("topFoods", statisticsService.getTopSellingFoods());
        model.addAttribute("topCustomers", statisticsService.getTopCustomers());

        model.addAttribute("body", "/WEB-INF/views/admin/report.jsp");
        return "admin/layouts/main";
    }
}