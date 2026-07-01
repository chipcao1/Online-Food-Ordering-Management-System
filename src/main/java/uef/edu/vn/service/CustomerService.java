package uef.edu.vn.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import uef.edu.vn.model.Customer;
import uef.edu.vn.repository.CustomerRepository;

import java.util.List;

@Service
public class CustomerService {

    @Autowired
    private CustomerRepository customerRepository;

    public List<Customer> getCustomersByPage(String keyword, int page, int size) {
        if (page < 1) page = 1; 
        int offset = (page - 1) * size;
        return customerRepository.findCustomers(keyword, size, offset);
    }

    public int countPages(String keyword, int size) {
        int totalRecords = customerRepository.countCustomers(keyword);
        return (int) Math.ceil((double) totalRecords / size);
    }

    public Customer findById(Long id) {
        return customerRepository.findById(id);
    }

    public void add(Customer customer) {
        customerRepository.add(customer);
    }

    public void update(Customer customer) {
        customerRepository.update(customer);
    }

    public void deleteById(Long id) {
        customerRepository.deleteById(id);
    }
}