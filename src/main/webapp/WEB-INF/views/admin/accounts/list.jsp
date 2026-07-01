<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="card border-0 shadow-sm rounded-4 mt-4">
    <div class="card-body p-4">
        <h4 class="card-title fw-bold text-dark m-0"><i class="bi bi-person-badge text-primary"></i> System Users & Roles</h4>
        <a href="${pageContext.request.contextPath}/admin/accounts/add" class="btn btn-primary"><i class="bi bi-plus-circle"></i> Add Account</a>
        <div class="table-responsive">
            <table class="table table-hover align-middle text-center">
                <thead class="table-light">
                    <tr><th>ID</th><th>Username</th><th>Email</th><th>Role</th><th>Status</th><th>Action</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="acc" items="${accounts}">
                        <tr>
                            <td class="fw-bold">${acc.id}</td>
                            <td class="fw-semibold">${acc.username}</td>
                            <td>${acc.email}</td>
                            <td><span class="badge bg-${acc.role.roleName == 'ADMIN' ? 'danger' : (acc.role.roleName == 'MANAGER' ? 'warning text-dark' : 'primary')}">${acc.role.roleName}</span></td>
                            <td><span class="badge bg-${acc.active ? 'success' : 'secondary'}">${acc.active ? 'Active' : 'Locked'}</span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/accounts/edit/${acc.id}" class="btn btn-sm btn-warning"><i class="bi bi-pencil"></i> Edit</a>
                                <a href="${pageContext.request.contextPath}/admin/accounts/delete/${acc.id}" class="btn btn-sm btn-danger" onclick="return confirm('Delete this account?')"><i class="bi bi-trash"></i></a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>