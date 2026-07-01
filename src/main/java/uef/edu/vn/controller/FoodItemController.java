package uef.edu.vn.controller;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import uef.edu.vn.model.FoodItem;
import uef.edu.vn.service.CategoryService;
import uef.edu.vn.service.FoodItemService;

@Controller
@RequestMapping("/admin/food-items")
public class FoodItemController {

    @Autowired private FoodItemService foodItemService;
    @Autowired private CategoryService categoryService;

    private final String PATH = "/WEB-INF/views/admin/food-items/";
    private final String VIEW_PATH = "admin/layouts/main";

    // Thư mục lưu ảnh upload (relative to webapp root)
    private static final String UPLOAD_DIR_REL = "/feane/images/food/";

    @GetMapping
    public String listFoodItems(@RequestParam(name = "keyword", required = false) String keyword,
                                @RequestParam(name = "categoryId", required = false) Long categoryId,
                                Model model) {
        model.addAttribute("foodItems", foodItemService.search(keyword, categoryId));
        model.addAttribute("categories", categoryService.getAll());
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("body", PATH + "list.jsp");
        return VIEW_PATH;
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("foodItem", new FoodItem());
        model.addAttribute("categories", categoryService.getAll());
        model.addAttribute("body", PATH + "form.jsp");
        return VIEW_PATH;
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model) {
        FoodItem foodItem = foodItemService.getById(id);
        if (foodItem == null) return "redirect:/admin/food-items";
        model.addAttribute("foodItem", foodItem);
        model.addAttribute("categories", categoryService.getAll());
        model.addAttribute("body", PATH + "form.jsp");
        return VIEW_PATH;
    }

    @PostMapping("/save")
    public String saveFoodItem(
            @ModelAttribute("foodItem") @Valid FoodItem foodItem,
            BindingResult result,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "thumbnailUrlText", required = false) String thumbnailUrlText,
            HttpServletRequest request,
            Model model) {

        if (result.hasErrors()) {
            List<String> formErrors = result.getAllErrors().stream()
                    .map(e -> e.getDefaultMessage())
                    .collect(Collectors.toList());
            model.addAttribute("formErrors", formErrors);
            model.addAttribute("categories", categoryService.getAll());
            model.addAttribute("body", PATH + "form.jsp");
            return VIEW_PATH;
        }

        // Xử lý ảnh: ưu tiên file upload > URL text > giữ nguyên
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                String uploadPath = request.getServletContext().getRealPath(UPLOAD_DIR_REL);
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String originalName = imageFile.getOriginalFilename();
                String ext = (originalName != null && originalName.contains("."))
                        ? originalName.substring(originalName.lastIndexOf('.'))
                        : ".jpg";
                String fileName = UUID.randomUUID().toString() + ext;
                imageFile.transferTo(new File(uploadDir, fileName));
                foodItem.setThumbnailUrl(UPLOAD_DIR_REL + fileName);
            } catch (IOException e) {
                model.addAttribute("uploadError", "Không thể upload ảnh: " + e.getMessage());
                model.addAttribute("categories", categoryService.getAll());
                model.addAttribute("body", PATH + "form.jsp");
                return VIEW_PATH;
            }
        } else if (thumbnailUrlText != null && !thumbnailUrlText.isBlank()) {
            foodItem.setThumbnailUrl(thumbnailUrlText);
        }
        // else: giữ nguyên thumbnailUrl từ hidden field (edit mode)

        // Validate giá không âm (backup nếu @DecimalMin bị bypass)
        boolean hasManualError = false;
        if (foodItem.getBasePrice() != null && foodItem.getBasePrice().compareTo(BigDecimal.ZERO) < 0) {
            result.rejectValue("basePrice", "min", "Giá gốc không được âm");
            hasManualError = true;
        }
        if (foodItem.getSalePrice() != null && foodItem.getSalePrice().compareTo(BigDecimal.ZERO) < 0) {
            result.rejectValue("salePrice", "min", "Giá sale không được âm");
            hasManualError = true;
        }
        if (foodItem.getStockQuantity() < 0) {
            result.rejectValue("stockQuantity", "min", "Số lượng tồn kho không được âm");
            hasManualError = true;
        }
        if (hasManualError) {
            List<String> formErrors = result.getAllErrors().stream()
                    .map(e -> e.getDefaultMessage())
                    .collect(Collectors.toList());
            model.addAttribute("formErrors", formErrors);
            model.addAttribute("categories", categoryService.getAll());
            model.addAttribute("body", PATH + "form.jsp");
            return VIEW_PATH;
        }

        if (foodItem.getId() == null) {
            foodItemService.add(foodItem);
        } else {
            foodItemService.update(foodItem);
        }
        return "redirect:/admin/food-items";
    }

    @GetMapping("/delete/{id}")
    public String deleteFoodItem(@PathVariable("id") Long id) {
        foodItemService.deleteById(id);
        return "redirect:/admin/food-items";
    }
}
