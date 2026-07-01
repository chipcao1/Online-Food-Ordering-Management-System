package uef.edu.vn.service;

import java.math.BigDecimal;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.repository.StatisticsRepository;

@Service
public class StatisticsService {

    @Autowired
    private StatisticsRepository statisticsRepository;

    public Integer getTotalOrders() {
        return statisticsRepository.getTotalOrders();
    }

    public Integer getTotalCustomers() {
        return statisticsRepository.getTotalCustomers();
    }

    public Integer getTotalFoods() {
        return statisticsRepository.getTotalFoods();
    }

    public Integer getCompletedOrders() {
        return statisticsRepository.getCompletedOrders();
    }

    public Integer getPendingOrders() {
        return statisticsRepository.getPendingOrders();
    }

    public List<Object[]> getLowStockFoods() {
        return statisticsRepository.getLowStockFoods();
    }

    public BigDecimal getTodayRevenue() {
        return statisticsRepository.getTodayRevenue();
    }

    public BigDecimal getCurrentMonthRevenue() {
        return statisticsRepository.getCurrentMonthRevenue();
    }

    public BigDecimal getCurrentYearRevenue() {
        return statisticsRepository.getCurrentYearRevenue();
    }

    public List<Object[]> getTopSellingFoods() {
        return statisticsRepository.getTopSellingFoods();
    }

    public List<Object[]> getTopCustomers() {
        return statisticsRepository.getTopCustomers();
    }
}
