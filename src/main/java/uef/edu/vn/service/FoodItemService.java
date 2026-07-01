package uef.edu.vn.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import uef.edu.vn.model.FoodItem;
import uef.edu.vn.repository.FoodItemRepository;

@Service
@Transactional // Khuyên dùng cho tất cả Service có thao tác thay đổi DB (Insert/Update/Delete)
public class FoodItemService {

    @Autowired
    private FoodItemRepository foodItemRepository;

    @Transactional(readOnly = true)
    public List<FoodItem> getAll() {
        return foodItemRepository.findAll();
    }

    @Transactional(readOnly = true)
    public FoodItem getById(Long id) {
        return foodItemRepository.findById(id);
    }

    public void add(FoodItem foodItem) {
        foodItemRepository.save(foodItem);
    }

    public void update(FoodItem foodItem) {
        foodItemRepository.update(foodItem);
    }

    public void deleteById(Long id) {
        foodItemRepository.delete(id);
    }

    @Transactional(readOnly = true)
    public List<FoodItem> search(String keyword, Long categoryId) {
        return foodItemRepository.search(keyword, categoryId);
    }
}