package uef.edu.vn.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import uef.edu.vn.enums.DeliveryStatus; // Chú ý package enum

public class Delivery {

    private Long id;
    private Order order;
    private Employee deliveryStaff;
    private DeliveryStatus deliveryStatus;
    private BigDecimal deliveryFee;
    private String trackingCode;
    private LocalDateTime assignedAt;
    private LocalDateTime deliveredAt;

    public Delivery() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }
    public Employee getDeliveryStaff() { return deliveryStaff; }
    public void setDeliveryStaff(Employee deliveryStaff) { this.deliveryStaff = deliveryStaff; }
    public DeliveryStatus getDeliveryStatus() { return deliveryStatus; }
    public void setDeliveryStatus(DeliveryStatus deliveryStatus) { this.deliveryStatus = deliveryStatus; }
    public BigDecimal getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(BigDecimal deliveryFee) { this.deliveryFee = deliveryFee; }
    public String getTrackingCode() { return trackingCode; }
    public void setTrackingCode(String trackingCode) { this.trackingCode = trackingCode; }
    public LocalDateTime getAssignedAt() { return assignedAt; }
    public void setAssignedAt(LocalDateTime assignedAt) { this.assignedAt = assignedAt; }
    public LocalDateTime getDeliveredAt() { return deliveredAt; }
    public void setDeliveredAt(LocalDateTime deliveredAt) { this.deliveredAt = deliveredAt; }
}