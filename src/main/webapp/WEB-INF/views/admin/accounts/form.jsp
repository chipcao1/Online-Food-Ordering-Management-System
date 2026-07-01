<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="card border-0 shadow-sm rounded-4 mt-4" style="max-width: 600px; margin: auto;">
    <div class="card-body p-4">
        <h4 class="card-title fw-bold text-dark mb-4">Grant Role Permissions</h4>
        
        <form action="${pageContext.request.contextPath}/admin/accounts/update" method="POST">
            <input type="hidden" name="id" value="${account.id}">
            
            <div class="mb-3">
                <label class="form-label text-muted">Username (Read-only)</label>
                <input type="text" class="form-control" value="${account.username}" disabled>
            </div>
            
            <div class="mb-3">
                <label class="form-label fw-bold">Select Role</label>
                <select name="roleId" class="form-select">
                    <c:forEach var="r" items="${roles}">
                        <option value="${r.id}" ${r.id == account.role.id ? 'selected' : ''}>
                            ${r.roleName} - ${r.description}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-4 form-check form-switch">
                <input class="form-check-input" type="checkbox" name="active" value="true" ${account.active ? 'checked' : ''} style="width: 40px; height: 20px;">
                <label class="form-check-label ms-2 fw-bold" style="margin-top: 2px;">Account is Active (Unlock)</label>
                <div class="form-text">Turn off to lock this account from logging in.</div>
            </div>

            <div class="d-flex justify-content-end gap-2">
                <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-outline-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary"><i class="bi bi-shield-check"></i> Save Permissions</button>
            </div>
        </form>
    </div>
</div>