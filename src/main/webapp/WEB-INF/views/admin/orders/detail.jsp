<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="card border-0 shadow-sm rounded-4 mt-4">
    <div class="card-body p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="card-title fw-bold text-dark m-0">
                <i class="bi bi-receipt text-success"></i> Chi tiết đơn hàng: #${order.orderCode}
            </h4>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
        </div>

        <div class="row mb-4">
            <div class="col-md-6 mb-3 mb-md-0">
                <h6 class="fw-bold text-muted border-bottom pb-2">Thông tin khách hàng</h6>
                <p class="mb-1"><strong>Tên:</strong> ${order.customer.fullName}</p>
                <p class="mb-1"><strong>Điện thoại:</strong> ${order.deliveryPhone}</p>
                <p class="mb-1"><strong>Địa chỉ giao:</strong> ${order.deliveryAddress}</p>
                <c:if test="${not empty order.note}">
                    <p class="mb-1"><strong>Ghi chú:</strong> <em class="text-muted">${order.note}</em></p>
                </c:if>
            </div>
            <div class="col-md-6">
                <h6 class="fw-bold text-muted border-bottom pb-2">Thông tin đơn hàng</h6>
                <p class="mb-1"><strong>Trạng thái đơn:</strong>
                    <span class="badge bg-${order.status == 'COMPLETED' ? 'success' : order.status == 'CANCELED' ? 'danger' : order.status == 'DELIVERING' ? 'info' : order.status == 'CONFIRMED' ? 'primary' : 'warning text-dark'}">
                        ${order.status}
                    </span>
                </p>
                <p class="mb-1"><strong>Thanh toán:</strong>
                    ${order.paymentMethod} &nbsp;
                    <span class="badge bg-${order.paymentStatus == 'PAID' ? 'success' : 'warning text-dark'}">
                        ${order.paymentStatus}
                    </span>
                </p>
                <p class="mb-1"><strong>Ngày đặt:</strong> ${order.createdAt}</p>
            </div>
        </div>

        <%-- Thông báo lỗi khi chưa gán shipper --%>
        <c:if test="${not empty shipperError}">
            <div class="alert alert-danger d-flex align-items-center gap-2 mb-3" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <span>${shipperError}</span>
            </div>
        </c:if>

        <%-- Hành động thay đổi trạng thái đơn --%>
        <div class="d-flex gap-2 mb-4 flex-wrap">
            <c:choose>
                <c:when test="${order.status == 'PENDING'}">
                    <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status" style="display:inline;">
                        <input type="hidden" name="id" value="${order.id}">
                        <input type="hidden" name="status" value="CONFIRMED">
                        <input type="hidden" name="fromDetail" value="true">
                        <button type="submit" class="btn btn-primary btn-sm"><i class="bi bi-check-circle"></i> Xác nhận đơn</button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status" style="display:inline;">
                        <input type="hidden" name="id" value="${order.id}">
                        <input type="hidden" name="status" value="CANCELED">
                        <input type="hidden" name="fromDetail" value="true">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Hủy đơn hàng này?')"><i class="bi bi-x-circle"></i> Hủy đơn</button>
                    </form>
                </c:when>
                <c:when test="${order.status == 'CONFIRMED'}">
                    <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status" style="display:inline;">
                        <input type="hidden" name="id" value="${order.id}">
                        <input type="hidden" name="status" value="DELIVERING">
                        <input type="hidden" name="fromDetail" value="true">
                        <button type="submit" class="btn btn-info text-white btn-sm"><i class="bi bi-truck"></i> Giao hàng</button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status" style="display:inline;">
                        <input type="hidden" name="id" value="${order.id}">
                        <input type="hidden" name="status" value="CANCELED">
                        <input type="hidden" name="fromDetail" value="true">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Hủy đơn hàng này?')"><i class="bi bi-x-circle"></i> Hủy đơn</button>
                    </form>
                </c:when>
                <c:when test="${order.status == 'DELIVERING'}">
                    <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status" style="display:inline;">
                        <input type="hidden" name="id" value="${order.id}">
                        <input type="hidden" name="status" value="COMPLETED">
                        <input type="hidden" name="fromDetail" value="true">
                        <button type="submit" class="btn btn-success btn-sm"><i class="bi bi-bag-check"></i> Hoàn thành</button>
                    </form>
                </c:when>
            </c:choose>

            <%-- THÊM MỚI: Xác nhận thanh toán (Staff / Admin / Manager) --%>
            <c:if test="${order.paymentStatus != 'PAID' && order.status != 'CANCELED'}">
                <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-payment-status" style="display:inline;">
                    <input type="hidden" name="id" value="${order.id}">
                    <input type="hidden" name="paymentStatus" value="PAID">
                    <button type="submit" class="btn btn-success btn-sm"
                            onclick="return confirm('Xác nhận đã thu tiền cho đơn hàng này?')">
                        <i class="bi bi-cash-coin"></i> Xác nhận đã thanh toán
                    </button>
                </form>
            </c:if>
            <c:if test="${order.paymentStatus == 'PAID'}">
                <span class="badge bg-success align-self-center px-3 py-2">
                    <i class="bi bi-check-circle"></i> Đã thanh toán
                </span>
            </c:if>
        </div>

        <%-- Assign Shipper — hiện khi đơn đang CONFIRMED hoặc DELIVERING --%>
        <c:if test="${order.status == 'CONFIRMED' || order.status == 'DELIVERING'}">
            <div class="card border-0 bg-light rounded-3 p-3 mb-4">
                <h6 class="fw-bold text-dark mb-3">
                    <i class="bi bi-person-badge text-primary me-1"></i> Nhân viên giao hàng
                </h6>
                <c:choose>
                    <c:when test="${delivery != null && delivery.deliveryStaff != null}">
                        <p class="mb-2">
                            <span class="badge bg-success px-3 py-2">
                                <i class="bi bi-check-circle me-1"></i>${delivery.deliveryStaff.fullName}
                            </span>
                            <small class="text-muted ms-2">đang phụ trách đơn này</small>
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted mb-2"><i class="bi bi-exclamation-circle text-warning me-1"></i>Chưa có shipper được gán.</p>
                    </c:otherwise>
                </c:choose>
                <form method="post" action="${pageContext.request.contextPath}/admin/orders/assign-shipper"
                      class="d-flex gap-2 align-items-center flex-wrap">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <select name="employeeId" class="form-select form-select-sm" style="max-width:260px;" required>
                        <option value="">-- Chọn shipper --</option>
                        <c:forEach var="s" items="${deliveryStaffs}">
                            <option value="${s.id}"
                                ${delivery != null && delivery.deliveryStaff != null && delivery.deliveryStaff.id == s.id ? 'selected' : ''}>
                                ${s.fullName}
                                <c:if test="${not empty s.phone}"> (${s.phone})</c:if>
                            </option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="bi bi-person-check me-1"></i>
                        ${delivery != null && delivery.deliveryStaff != null ? 'Đổi shipper' : 'Gán shipper'}
                    </button>
                </form>
            </div>
        </c:if>

        <%-- Danh sách món ăn --%>
        <h6 class="fw-bold text-muted border-bottom pb-2">Các món đã đặt</h6>
        <div class="table-responsive">
            <table class="table table-bordered align-middle text-center">
                <thead class="table-light">
                    <tr>
                        <th class="text-start">Tên món</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.items}">
                        <tr>
                            <td class="fw-semibold text-start">${item.foodNameSnapshot}</td>
                            <td>$${item.unitPrice}</td>
                            <td>${item.quantity}</td>
                            <td class="fw-bold text-danger">$${item.subtotal}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty order.items}">
                        <tr><td colspan="4" class="text-muted">Không có dữ liệu món ăn.</td></tr>
                    </c:if>
                </tbody>
                <tfoot>
                    <tr><td colspan="3" class="text-end fw-semibold text-muted">Tạm tính:</td><td class="fw-semibold">$${order.subtotal}</td></tr>
                    <tr><td colspan="3" class="text-end fw-semibold text-muted">Phí giao hàng:</td><td class="fw-semibold text-danger">+$${order.shippingFee}</td></tr>
                    <tr class="table-light">
                        <td colspan="3" class="text-end fw-bold fs-5">Tổng cộng:</td>
                        <td class="fw-bold fs-5 text-success">$${order.totalAmount}</td>
                    </tr>
                </tfoot>
            </table>
        </div>

    </div>
</div>
