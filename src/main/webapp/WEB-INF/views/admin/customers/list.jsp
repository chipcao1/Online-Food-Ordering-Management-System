<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<main class="dashboard-content">
    <div class="container-fluid px-3 px-lg-4 py-4">
        <div class="page-heading">
            <div class="page-heading-copy">
                <span class="page-icon"><i class="bi bi-people"></i></span>
                <div><p class="eyebrow mb-1">Customer Management</p><h1 class="h3 mb-1">Customers</h1></div>
            </div>
            <a href="${pageContext.request.contextPath}/admin/customers/add" class="btn btn-primary"><i class="bi bi-plus-circle"></i> Add Customer</a>
        </div>

        <section class="panel">
            <div class="panel-header">
                <form method="get" action="${pageContext.request.contextPath}/admin/customers" class="d-flex gap-2">
                    <input type="search" name="keyword" value="${keyword}" class="form-control" placeholder="Search name, email, phone">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i></button>
                </form>
            </div>
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Address</th><th class="text-end">Action</th></tr></thead>
                    <tbody>
                        <c:forEach var="c" items="${customers}">
                            <tr>
                                <td>${c.id}</td>
                                <td class="fw-semibold"><c:out value="${c.fullName}"/></td>
                                <td><c:out value="${c.email}"/></td>
                                <td><c:out value="${c.phone}"/></td>
                                <td><c:out value="${c.address}"/></td>
                                <td class="text-end">
                                    <a class="btn btn-warning btn-sm" href="${pageContext.request.contextPath}/admin/customers/edit/${c.id}"><i class="bi bi-pencil"></i></a> 
                                    <a class="btn btn-danger btn-sm" href="${pageContext.request.contextPath}/admin/customers/delete/${c.id}" onclick="return confirm('Delete this customer?')"><i class="bi bi-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</main>