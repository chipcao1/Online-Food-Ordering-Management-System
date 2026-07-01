
package uef.edu.vn.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import uef.edu.vn.enums.OrderStatus;
import uef.edu.vn.enums.PaymentMethod;
import uef.edu.vn.enums.PaymentStatus;

public class Order {
    private Long id;
    private String orderCode;
    private Customer customer;
    
    // Thuộc tính Address: Nếu bạn có model Address riêng thì dùng kiểu Address, 
    // nếu chưa có (như hiện tại) thì lưu chuỗi tạm thời hoặc tạo thêm model Address.
    // Ở đây mình ví dụ dùng String cho đơn giản theo yêu cầu tối giản, nếu bạn có bảng Address riêng thì đổi kiểu.
    private String deliveryAddress; 
    private String deliveryPhone;

    private OrderStatus status;
    private PaymentMethod paymentMethod; // Thêm từ Enum
    private PaymentStatus paymentStatus; // Thêm từ Enum
    
    private BigDecimal subtotal;
    private BigDecimal shippingFee;
    private BigDecimal discountAmount;
    private BigDecimal totalAmount;
    private String note;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Order() {}

    // Getters và Setters (Bạn tạo tự động trong IDE nhé)
    // (Bao gồm getter/setter cho các trường mới: deliveryAddress, deliveryPhone, paymentMethod, paymentStatus)
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }
    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }
    public String getDeliveryPhone() { return deliveryPhone; }
    public void setDeliveryPhone(String deliveryPhone) { this.deliveryPhone = deliveryPhone; }
    public OrderStatus getStatus() { return status; }
    public void setStatus(OrderStatus status) { this.status = status; }
    public PaymentMethod getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(PaymentMethod paymentMethod) { this.paymentMethod = paymentMethod; }
    public PaymentStatus getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    public BigDecimal getShippingFee() { return shippingFee; }
    public void setShippingFee(BigDecimal shippingFee) { this.shippingFee = shippingFee; }
    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    // Bổ sung danh sách món ăn của đơn hàng
    private java.util.List<OrderItem> items;

    public java.util.List<OrderItem> getItems() {
        return items;
    }

    public void setItems(java.util.List<OrderItem> items) {
        this.items = items;
    }
}