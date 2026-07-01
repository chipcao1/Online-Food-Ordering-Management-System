package uef.edu.vn.controller;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import uef.edu.vn.model.Category;
import uef.edu.vn.service.CategoryService;

@Controller
@RequestMapping("/admin/categories")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;
    
    // CHUẨN HÓA ĐƯỜNG DẪN
    private final String PATH = "/WEB-INF/views/admin/categories/";
    private final String VIEW_PATH = "admin/layouts/main";

    @GetMapping
    public String listCategories(@RequestParam(name = "keyword", required = false) String keyword, Model model) {
        List<Category> categories = (keyword != null && !keyword.isBlank()) 
            ? categoryService.search(keyword) 
            : categoryService.getAll();
        
        model.addAttribute("categories", categories);
        model.addAttribute("keyword", keyword);
        model.addAttribute("body", PATH + "list.jsp");
        return VIEW_PATH;
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("category", new Category());
        model.addAttribute("body", PATH + "form.jsp");
        return VIEW_PATH;
    }

    @PostMapping("/save")
    public String saveCategory(@Valid @ModelAttribute("category") Category category, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("body", PATH + "form.jsp");
            return VIEW_PATH;
        }

        if (category.getId() == null || category.getId() == 0) {
            categoryService.add(category);
        } else {
            categoryService.update(category);
        }
        return "redirect:/admin/categories";
    }
}