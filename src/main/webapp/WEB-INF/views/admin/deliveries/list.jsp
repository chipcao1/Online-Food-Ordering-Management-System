<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="card border-0 shadow-sm rounded-4 mt-4">
    <div class="card-body p-4">
        <h4 class="card-title fw-bold text-dark mb-4"><i class="bi bi-truck text-primary"></i> Delivery Management</h4>
        
        <div class="table-responsive">
            <table class="table table-hover align-middle text-center">
                <thead class="table-light">
                    <tr>
                        <th>Order Code</th>
                        <th>Shipper Name</th>
                        <th>Tracking Code</th>
                        <th>Fee</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="d" items="${deliveries}">
                        <tr>
                            <td class="fw-bold text-primary">#${d.order.orderCode}</td>
                            <td>${d.deliveryStaff != null ? d.deliveryStaff.fullName : 'Not Assigned'}</td>
                            <td>${d.trackingCode}</td>
                            <td class="text-danger fw-bold">$${d.deliveryFee}</td>
                            <td>
                                <span class="badge bg-${d.deliveryStatus == 'DELIVERED' ? 'success' : (d.deliveryStatus == 'DELIVERING' ? 'info text-dark' : 'warning text-dark')}">
                                    ${d.deliveryStatus}
                                </span>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <c:if test="${d.deliveryStatus == 'DELIVERING' or d.deliveryStatus == 'WAITING'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/deliveries/update-status" style="display:inline;">
                                            <input type="hidden" name="id" value="${d.id}">
                                            <input type="hidden" name="status" value="DELIVERED">
                                            <button type="submit" class="btn btn-success" title="Mark as Delivered" onclick="return confirm('Confirm delivery completed?')">
                                                <i class="bi bi-check-circle"></i> Delivered
                                            </button>
                                        </form>
                                    </c:if>

                                    <c:if test="${sessionScope.role == 'ADMIN' or sessionScope.role == 'MANAGER'}">
                                        <a href="${pageContext.request.contextPath}/admin/deliveries/delete?id=${d.id}" class="btn btn-danger ms-1" title="Delete Delivery" onclick="return confirm('Delete this delivery record?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty deliveries}">
                        <tr><td colspan="6" class="text-muted py-3">No delivery records found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>