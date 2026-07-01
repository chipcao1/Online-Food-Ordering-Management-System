<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="card border-0 shadow-sm rounded-4 mt-4" style="max-width: 680px; margin: auto;">
    <div class="card-body p-4">
        <h4 class="card-title fw-bold text-dark mb-4">
            <i class="bi bi-person-plus"></i> Tạo tài khoản mới
        </h4>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/accounts/saveNew" method="POST" novalidate
              onsubmit="return validateAccountForm(this)">

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label fw-bold">Username <span class="text-danger">*</span></label>
                    <input type="text" name="username" class="form-control" required
                           minlength="3" maxlength="50"
                           placeholder="Tên đăng nhập (ít nhất 3 ký tự)">
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold">Email <span class="text-danger">*</span></label>
                    <input type="email" name="email" class="form-control" required
                           placeholder="example@email.com">
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold">Mật khẩu <span class="text-danger">*</span></label>
                    <input type="password" name="password" class="form-control" required
                           minlength="6" placeholder="Ít nhất 6 ký tự">
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold">Số điện thoại</label>
                    <input type="tel" name="phone" class="form-control"
                           pattern="0[0-9]{9}"
                           title="10 chữ số, bắt đầu bằng 0"
                           placeholder="0xxxxxxxxx (10 số)">
                    <small class="text-muted">Bắt buộc nếu role là CUSTOMER</small>
                </div>

                <%-- Thêm trường fullName - dùng khi role = CUSTOMER --%>
                <div class="col-12" id="customerFields">
                    <div class="card bg-light border-0 p-3 rounded-3">
                        <label class="form-label fw-bold text-primary">
                            <i class="bi bi-person-circle"></i>
                            Thông tin khách hàng
                            <small class="text-muted fw-normal">(chỉ cần điền khi role là CUSTOMER)</small>
                        </label>
                        <div class="row g-2">
                            <div class="col-md-6">
                                <label class="form-label">Họ và tên đầy đủ</label>
                                <input type="text" name="fullName" id="fullNameInput" class="form-control"
                                       placeholder="VD: Nguyễn Văn A">
                                <small class="text-muted">Không chứa ký tự số</small>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Địa chỉ</label>
                                <input type="text" name="address" class="form-control"
                                       placeholder="Địa chỉ giao hàng mặc định">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <label class="form-label fw-bold">Phân quyền <span class="text-danger">*</span></label>
                    <select name="roleId" class="form-select" id="roleSelect" onchange="toggleCustomerFields(this)">
                        <c:forEach var="r" items="${roles}">
                            <option value="${r.id}">${r.roleName} — ${r.description}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-2 mt-4">
                <a href="${pageContext.request.contextPath}/admin/accounts" class="btn btn-outline-secondary px-4">
                    Hủy
                </a>
                <button type="submit" class="btn btn-primary px-5">
                    <i class="bi bi-save"></i> Tạo tài khoản
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function toggleCustomerFields(select) {
    // Hiện ô fullName/address khi chọn CUSTOMER
    const opt = select.options[select.selectedIndex];
    const isCustomer = opt.text.includes('CUSTOMER');
    const box = document.getElementById('customerFields');
    const fnInput = document.getElementById('fullNameInput');
    if (isCustomer) {
        box.style.display = '';
    } else {
        box.style.display = 'none';
        fnInput.value = '';
    }
}

function validateAccountForm(form) {
    const username = form.username.value.trim();
    const email = form.email.value.trim();
    const password = form.password.value;
    const phone = form.phone.value.trim();
    const fullName = form.fullName ? form.fullName.value.trim() : '';

    if (!username || username.length < 3) {
        alert('Username phải có ít nhất 3 ký tự!'); return false;
    }
    if (!email) {
        alert('Email không được để trống!'); return false;
    }
    if (!password || password.length < 6) {
        alert('Mật khẩu phải có ít nhất 6 ký tự!'); return false;
    }
    if (phone && !/^0\d{9}$/.test(phone)) {
        alert('Số điện thoại phải 10 chữ số bắt đầu bằng 0!'); return false;
    }
    if (fullName && /\d/.test(fullName)) {
        alert('Họ tên không được chứa ký tự số!'); return false;
    }
    return true;
}

// Init: hiện/ẩn customer fields theo role hiện tại
document.addEventListener('DOMContentLoaded', function() {
    const sel = document.getElementById('roleSelect');
    if (sel) toggleCustomerFields(sel);
});
</script>
