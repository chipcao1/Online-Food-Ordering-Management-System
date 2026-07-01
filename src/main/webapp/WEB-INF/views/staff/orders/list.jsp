<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<h4 class="mb-4">Kitchen & Order Management</h4>

<div class="row">
    <c:forEach var="o" items="${orders}">
        <c:if test="${o.status != 'COMPLETED' && o.status != 'CANCELED'}">
            <div class="col-12 col-md-6 col-lg-4">
                <div class="card mobile-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="card-title text-primary fw-bold mb-0">#<c:out value="${o.orderCode}"/></h5>
                            <span class="badge bg-warning text-dark">${o.status}</span>
                        </div>
                        <p class="mb-1"><strong><i class="bi bi-person"></i></strong> <c:out value="${o.customer.fullName}"/></p>
                        <p class="mb-1"><strong><i class="bi bi-clock"></i></strong> ${o.createdAt}</p>
                        <p class="mb-3"><strong><i class="bi bi-cash"></i></strong> $${o.totalAmount} (${o.paymentMethod})</p>
                        
                        <form method="post" action="${pageContext.request.contextPath}/staff/orders/update-status">
                            <input type="hidden" name="id" value="${o.id}">
                            <div class="d-grid gap-2">
                                <c:choose>
                                    <c:when test="${o.status == 'PENDING'}">
                                        <input type="hidden" name="status" value="CONFIRMED">
                                        <button type="submit" class="btn btn-success"><i class="bi bi-check-circle"></i> Confirm Order</button>
                                    </c:when>
                                    <c:when test="${o.status == 'CONFIRMED'}">
                                        <input type="hidden" name="status" value="DELIVERING">
                                        <button type="submit" class="btn btn-info text-white"><i class="bi bi-box-seam"></i> Send to Delivery</button>
                                    </c:when>
                                </c:choose>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:if>
    </c:forEach>
</div>