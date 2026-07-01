<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="sidebar-backdrop" onclick="document.body.classList.remove('sidebar-open')"></div>

<aside id="adminSidebar" class="admin-sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="brand-mark">
            <div class="brand-icon">
                <i class="bi bi-shop"></i>
            </div>
            <div>
                <span class="brand-title">Feane Admin</span>
                <span class="brand-subtitle">Management System</span>
            </div>
        </a>
    </div>

    <div class="sidebar-user">
        <div class="avatar-img avatar-md sidebar-user-avatar d-inline-flex align-items-center justify-content-center text-white fw-bold fs-3" style="background: linear-gradient(135deg, #2563eb, #0f766e);">
            ${sessionScope.loggedInUser.username.substring(0,2).toUpperCase()}
        </div>
        <strong><c:out value="${sessionScope.loggedInUser.username}"/></strong>
        <small class="text-warning"><c:out value="${sessionScope.role}"/></small>
    </div>

    <ul class="sidebar-nav list-unstyled">
        <c:if test="${sessionScope.role == 'ADMIN' or sessionScope.role == 'MANAGER'}">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><div class="nav-icon"><i class="bi bi-speedometer2"></i></div><span class="nav-text">Dashboard</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/food-items" class="nav-link"><div class="nav-icon"><i class="bi bi-cup-hot"></i></div><span class="nav-text">Menu Items</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories" class="nav-link"><div class="nav-icon"><i class="bi bi-tags"></i></div><span class="nav-text">Categories</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/customers" class="nav-link"><div class="nav-icon"><i class="bi bi-people"></i></div><span class="nav-text">Customers</span></a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports" class="nav-link"><div class="nav-icon"><i class="bi bi-bar-chart"></i></div><span class="nav-text">Reports</span></a></li>
        </c:if>

        <c:if test="${sessionScope.role == 'ADMIN' or sessionScope.role == 'MANAGER' or sessionScope.role == 'STAFF'}">
            <li><a href="${pageContext.request.contextPath}/admin/orders" class="nav-link"><div class="nav-icon"><i class="bi bi-receipt"></i></div><span class="nav-text">Orders</span></a></li>
        </c:if>

        <c:if test="${sessionScope.role == 'ADMIN' or sessionScope.role == 'MANAGER' or sessionScope.role == 'DELIVERY_STAFF'}">
            <li><a href="${pageContext.request.contextPath}/admin/deliveries" class="nav-link"><div class="nav-icon"><i class="bi bi-truck"></i></div><span class="nav-text">Deliveries</span></a></li>
        </c:if>

        <c:if test="${sessionScope.role == 'ADMIN'}">
            <li class="mt-4 pt-3 border-top" style="border-color: var(--admin-sidebar-border) !important;"><a href="${pageContext.request.contextPath}/admin/accounts" class="nav-link"><div class="nav-icon"><i class="bi bi-person-badge"></i></div><span class="nav-text">Users & Roles</span></a></li>
        </c:if>
    </ul>
</aside>

<div class="admin-main">
    <nav class="navbar admin-navbar navbar-expand bg-white border-bottom shadow-sm py-3">
        <div class="container-fluid px-3 px-lg-4">
            <button class="sidebar-toggle d-lg-none me-2" type="button" onclick="document.body.classList.toggle('sidebar-open')">
                <span></span>
                <span></span>
                <span></span>
            </button>
            <div class="navbar-actions ms-auto">
                <a class="btn btn-danger btn-sm text-white px-3 rounded-pill" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
            </div>
        </div>
    </nav>