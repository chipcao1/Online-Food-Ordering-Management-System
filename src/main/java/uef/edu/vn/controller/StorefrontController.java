package uef.edu.vn.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import uef.edu.vn.service.CategoryService;
import uef.edu.vn.service.FoodItemService;

@Controller
public class StorefrontController {
    @Autowired private FoodItemService foodItemService;
    @Autowired private CategoryService categoryService;

    @GetMapping("/")
    public String home() { return "redirect:/menu"; }

    @GetMapping("/menu")
    public String menu(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        model.addAttribute("categories", categoryService.getAll());
        java.util.List<uef.edu.vn.model.FoodItem> foods = foodItemService.getAll().stream().filter(f -> f.isActive()).toList();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.toLowerCase();
            foods = foods.stream().filter(f -> f.getFoodName().toLowerCase().contains(kw)).toList();
            model.addAttribute("keyword", keyword);
        }
        model.addAttribute("foodItems", foods);
        // Trỏ vào ruột menu và load layout
        model.addAttribute("body", "/WEB-INF/views/customer/menu.jsp");
        return "customer/layouts/main"; 
    }
}