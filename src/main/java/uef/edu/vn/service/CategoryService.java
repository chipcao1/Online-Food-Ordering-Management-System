package uef.edu.vn.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import uef.edu.vn.model.Category;
import uef.edu.vn.repository.CategoryRepository;

@Service
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    public List<Category> getAll() {
        return categoryRepository.findAll();
    }

    public Category getById(Long id) { // Đã đổi sang Long
        return categoryRepository.findById(id);
    }

    public void add(Category category) {
        categoryRepository.save(category);
    }

    public void update(Category category) {
        categoryRepository.update(category);
    }

    public void delete(Long id) { // Đã đổi sang Long
        categoryRepository.delete(id);
    }

    public List<Category> search(String keyword) {
        return categoryRepository.search(keyword);
    }
}