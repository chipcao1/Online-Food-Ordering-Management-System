<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="#">
            <i class="bi bi-shop"></i> Employee Portal
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#employeeNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="employeeNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <c:if test="${sessionScope.role == 'STAFF'}">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/staff/orders"><i class="bi bi-receipt"></i> Orders</a>
                    </li>
                </c:if>
                
                <c:if test="${sessionScope.role == 'DELIVERY_STAFF'}">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/delivery/tasks"><i class="bi bi-truck"></i> Deliveries</a>
                    </li>
                </c:if>
            </ul>
            
            <div class="d-flex align-items-center text-white">
                <span class="me-3"><i class="bi bi-person-circle"></i> <c:out value="${sessionScope.loggedInUser.username}"/></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">Logout</a>
            </div>
        </div>
    </div>
</nav>