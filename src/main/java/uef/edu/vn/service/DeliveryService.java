package uef.edu.vn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.model.Delivery;
import uef.edu.vn.repository.DeliveryRepository;

@Service
public class DeliveryService {

    @Autowired
    private DeliveryRepository deliveryRepository;

    public List<Delivery> getAllDeliveries() {
        return deliveryRepository.findAll();
    }

    public Delivery getDeliveryById(Long id) {
        return deliveryRepository.findById(id);
    }

    public void save(Delivery delivery) {
        deliveryRepository.save(delivery);
    }

    public void updateStatus(Long id, String status) {
        deliveryRepository.updateStatus(id, status);
    }

    public void delete(Long id) {
        deliveryRepository.deleteById(id); 
    }
}