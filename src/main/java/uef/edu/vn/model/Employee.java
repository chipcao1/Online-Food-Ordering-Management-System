package uef.edu.vn.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public class Employee {
    private Long id;

    @NotBlank(message = "Họ tên không được để trống")
    // ĐÃ THÊM: ràng buộc tên không chứa ký tự số
    @Pattern(regexp = "^[^\\d]+$", message = "Họ tên không được chứa ký tự số")
    private String fullName;

    // ĐÃ THÊM: ràng buộc phone đúng định dạng
    @Pattern(regexp = "^(0\\d{9})?$", message = "Số điện thoại không hợp lệ (10 chữ số, bắt đầu bằng 0)")
    private String phone;

    private String email;

    public Employee() {}

    public Long getId()                      { return id; }
    public void setId(Long id)               { this.id = id; }
    public String getFullName()              { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhone()                 { return phone; }
    public void setPhone(String phone)       { this.phone = phone; }
    public String getEmail()                 { return email; }
    public void setEmail(String email)       { this.email = email; }
}
