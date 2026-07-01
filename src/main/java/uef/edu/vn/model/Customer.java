package uef.edu.vn.model;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import java.util.List;

public class Customer {
    private Long id;

    @NotBlank(message = "Họ tên không được để trống")
    // ĐÃ THÊM: ràng buộc tên không chứa ký tự số
    @Pattern(regexp = "^[^\\d]+$", message = "Họ tên không được chứa ký tự số")
    private String fullName;

    @Email(message = "Email không hợp lệ")
    private String email;

    // ĐÃ THÊM: ràng buộc phone đúng định dạng Việt Nam
    @Pattern(regexp = "^(0\\d{9})?$", message = "Số điện thoại không hợp lệ (10 chữ số, bắt đầu bằng 0)")
    private String phone;

    private String address;
    private List<Order> orders;

    public Customer() {}

    public Customer(Long id, String fullName, String email, String phone, String address) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

    public Long getId()                      { return id; }
    public void setId(Long id)               { this.id = id; }
    public String getFullName()              { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail()                 { return email; }
    public void setEmail(String email)       { this.email = email; }
    public String getPhone()                 { return phone; }
    public void setPhone(String phone)       { this.phone = phone; }
    public String getAddress()               { return address; }
    public void setAddress(String address)   { this.address = address; }
    public List<Order> getOrders()           { return orders; }
    public void setOrders(List<Order> orders){ this.orders = orders; }
}
