<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<h4 class="mb-4">Delivery Tasks</h4>

<div class="row">
    <c:forEach var="d" items="${deliveries}">
        <c:if test="${d.deliveryStatus != 'DELIVERED'}">
            <div class="col-12 col-md-6 col-lg-4">
                <div class="card mobile-card border-start border-info border-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <h6 class="fw-bold text-dark mb-0">Order #<c:out value="${d.order.orderCode}"/></h6>
                            <span class="badge bg-info">${d.deliveryStatus}</span>
                        </div>
                        
                        <div class="bg-light p-2 rounded mb-3">
                            <p class="mb-1 text-danger fw-bold"><i class="bi bi-geo-alt-fill"></i> <c:out value="${d.order.deliveryAddress}"/></p>
                            <p class="mb-0"><i class="bi bi-telephone-fill"></i> <c:out value="${d.order.deliveryPhone}"/></p>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="text-muted small">Fee: <strong class="text-dark">$${d.deliveryFee}</strong></span>
                            <a href="tel:${d.order.deliveryPhone}" class="btn btn-outline-primary btn-sm"><i class="bi bi-telephone"></i> Call</a>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/delivery/tasks/update-status">
                            <input type="hidden" name="id" value="${d.id}">
                            <div class="d-grid">
                                <c:choose>
                                    <c:when test="${d.deliveryStatus == 'WAITING'}">
                                        <input type="hidden" name="status" value="DELIVERING">
                                        <button type="submit" class="btn btn-primary"><i class="bi bi-bicycle"></i> Start Delivery</button>
                                    </c:when>
                                    <c:when test="${d.deliveryStatus == 'DELIVERING'}">
                                        <input type="hidden" name="status" value="DELIVERED">
                                        <button type="submit" class="btn btn-success"><i class="bi bi-check2-all"></i> Mark as Delivered</button>
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