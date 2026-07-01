<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng ký | Feane</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/feane/css/bootstrap.css">
    <style>
        body {
            background: linear-gradient(135deg, #222831 0%, #393e46 100%);
            min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
            padding: 20px;
        }
        .register-card {
            background: #fff;
            border-radius: 18px;
            padding: 40px 36px;
            box-shadow: 0 20px 60px rgba(0,0,0,.4);
            width: 100%; max-width: 480px;
        }
        .register-card .logo {
            font-size: 1.8rem; font-weight: 900; color: #222831;
            letter-spacing: -1px;
        }
        .register-card .logo span { color: #ffc107; }
        .section-label {
            font-size: .72rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 1px; color: #adb5bd;
            border-bottom: 1px solid #f0f0f0; padding-bottom: 6px; margin-bottom: 14px;
        }
        .form-control {
            border-radius: 10px; border: 1.5px solid #dee2e6;
            padding: 10px 14px; font-size: .92rem;
        }
        .form-control:focus { border-color: #ffc107; box-shadow: 0 0 0 .2rem rgba(255,193,7,.2); }
        .form-control.is-invalid { border-color: #dc3545; }
        .form-control.is-valid   { border-color: #28a745; }
        .input-hint { font-size: .75rem; color: #adb5bd; margin-top: 3px; }
        .input-hint.error { color: #dc3545; }
        .btn-register {
            background: #ffc107; color: #222; border: none;
            border-radius: 10px; padding: 12px; font-weight: 700; font-size: 1rem;
            width: 100%; transition: background .2s;
        }
        .btn-register:hover { background: #e0a800; }
        .strength-bar { height: 4px; border-radius: 4px; margin-top: 5px; transition: all .3s; }
        .pw-req { font-size: .72rem; color: #adb5bd; margin-top: 4px; list-style: none; padding: 0; }
        .pw-req li::before { content: '✗ '; color: #dc3545; }
        .pw-req li.ok::before { content: '✓ '; color: #28a745; }
        .pw-req li.ok { color: #28a745; }
    </style>
</head>
<body>
<div class="register-card">
    <div class="text-center mb-4">
        <div class="logo">FE<span>ANE</span></div>
        <p class="text-muted mb-0" style="font-size:.85rem">Tạo tài khoản mới</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger py-2 px-3" style="font-size:.88rem; border-radius:10px;">
            <i class="bi bi-exclamation-triangle me-1"></i>${error}
        </div>
    </c:if>

    <form id="registerForm" action="${pageContext.request.contextPath}/register" method="POST" novalidate onsubmit="return validateForm()">

        <p class="section-label">Thông tin đăng nhập</p>

        <div class="mb-3">
            <label class="form-label fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
            <input type="text" name="username" id="username"
                   class="form-control" placeholder="Ít nhất 3 ký tự"
                   minlength="3" required autocomplete="username"
                   value="${param.username}">
            <div class="input-hint" id="usernameHint">Chỉ dùng chữ cái, số, dấu gạch dưới. Ít nhất 3 ký tự.</div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
            <div class="position-relative">
                <input type="password" name="password" id="password"
                       class="form-control" placeholder="Ít nhất 6 ký tự"
                       minlength="6" required autocomplete="new-password"
                       oninput="checkPassword(this.value)">
                <button type="button" onclick="togglePw('password', this)"
                        style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;color:#aaa;cursor:pointer;font-size:.9rem;">
                    Hiện
                </button>
            </div>
            <div class="strength-bar bg-light" id="strengthBar"></div>
            <ul class="pw-req" id="pwReqs">
                <li id="req-len">Ít nhất 6 ký tự</li>
            </ul>
        </div>

        <div class="mb-4">
            <label class="form-label fw-semibold">Xác nhận mật khẩu <span class="text-danger">*</span></label>
            <input type="password" name="confirmPassword" id="confirmPassword"
                   class="form-control" placeholder="Nhập lại mật khẩu"
                   required autocomplete="new-password"
                   oninput="checkConfirm()">
            <div class="input-hint error" id="confirmHint" style="display:none">Mật khẩu không khớp</div>
        </div>

        <p class="section-label">Thông tin cá nhân</p>

        <div class="mb-3">
            <label class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
            <input type="text" name="fullName" id="fullName"
                   class="form-control" placeholder="VD: Nguyễn Văn A"
                   required value="${param.fullName}">
            <div class="input-hint">Không chứa chữ số.</div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
            <input type="email" name="email" id="email"
                   class="form-control" placeholder="example@email.com"
                   required value="${param.email}">
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
            <input type="tel" name="phone" id="phone"
                   class="form-control" placeholder="0xxxxxxxxx"
                   required pattern="0[0-9]{9}"
                   oninput="checkPhone(this.value)"
                   value="${param.phone}">
            <div class="input-hint" id="phoneHint">10 chữ số, bắt đầu bằng 0. Mỗi số điện thoại chỉ đăng ký được 1 lần.</div>
        </div>

        <div class="mb-4">
            <label class="form-label fw-semibold">Địa chỉ giao hàng <span class="text-danger">*</span></label>
            <input type="text" name="address"
                   class="form-control" placeholder="Số nhà, tên đường, quận/huyện..."
                   required value="${param.address}">
        </div>

        <button type="submit" class="btn-register">Tạo tài khoản</button>

        <p class="text-center mt-3 mb-0" style="font-size:.85rem; color:#adb5bd;">
            Đã có tài khoản?
            <a href="${pageContext.request.contextPath}/login" style="color:#ffc107; font-weight:700; text-decoration:none;">Đăng nhập</a>
        </p>
    </form>
</div>

<script>
function togglePw(id, btn) {
    var el = document.getElementById(id);
    if (el.type === 'password') { el.type = 'text'; btn.textContent = 'Ẩn'; }
    else { el.type = 'password'; btn.textContent = 'Hiện'; }
}

function checkPassword(val) {
    var bar = document.getElementById('strengthBar');
    var reqLen = document.getElementById('req-len');
    var ok = val.length >= 6;
    reqLen.className = ok ? 'ok' : '';

    var strength = 0;
    if (val.length >= 6)  strength++;
    if (val.length >= 10) strength++;
    if (/[A-Z]/.test(val) && /[a-z]/.test(val)) strength++;
    if (/\d/.test(val))   strength++;
    if (/[^A-Za-z0-9]/.test(val)) strength++;

    var colors = ['#dee2e6','#dc3545','#fd7e14','#ffc107','#28a745'];
    var widths  = ['0%','25%','50%','75%','100%'];
    bar.style.background = colors[strength];
    bar.style.width = widths[strength];

    checkConfirm();
}

function checkConfirm() {
    var pw = document.getElementById('password').value;
    var cf = document.getElementById('confirmPassword').value;
    var hint = document.getElementById('confirmHint');
    if (cf.length > 0) hint.style.display = (pw !== cf) ? 'block' : 'none';
}

function checkPhone(val) {
    var hint = document.getElementById('phoneHint');
    if (val.length > 0 && !/^0\d{9}$/.test(val)) {
        hint.className = 'input-hint error';
        hint.textContent = 'Số điện thoại phải đúng 10 chữ số và bắt đầu bằng 0.';
    } else {
        hint.className = 'input-hint';
        hint.textContent = '10 chữ số, bắt đầu bằng 0. Mỗi số điện thoại chỉ đăng ký được 1 lần.';
    }
}

function validateForm() {
    var username = document.getElementById('username').value.trim();
    var password = document.getElementById('password').value;
    var confirm  = document.getElementById('confirmPassword').value;
    var fullName = document.getElementById('fullName').value.trim();
    var email    = document.getElementById('email').value.trim();
    var phone    = document.getElementById('phone').value.trim();

    if (username.length < 3) { alert('Tên đăng nhập phải có ít nhất 3 ký tự!'); return false; }
    if (password.length < 6) { alert('Mật khẩu phải có ít nhất 6 ký tự!'); return false; }
    if (password !== confirm) { alert('Mật khẩu xác nhận không khớp!'); return false; }
    if (!fullName) { alert('Vui lòng nhập họ và tên!'); return false; }
    if (/\d/.test(fullName)) { alert('Họ tên không được chứa chữ số!'); return false; }
    if (!email) { alert('Vui lòng nhập email!'); return false; }
    if (!/^0\d{9}$/.test(phone)) { alert('Số điện thoại phải đúng 10 chữ số, bắt đầu bằng 0!'); return false; }
    return true;
}
</script>
</body>
</html>
