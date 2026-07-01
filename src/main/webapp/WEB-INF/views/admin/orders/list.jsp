<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="card border-0 shadow-sm rounded-4 mt-4">
    <div class="card-body p-4">
        <h4 class="card-title fw-bold text-dark mb-4">
            <i class="bi bi-receipt text-success"></i> Order Management
        </h4>

        <%-- Search & Filter --%>
        <form method="GET" action="${pageContext.request.contextPath}/admin/orders" class="row g-2 mb-4">
            <div class="col-12 col-md-4">
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                    <input type="text" name="keyword" class="form-control"
                           placeholder="Mã đơn hoặc tên khách hàng..."
                           value="${keyword}">
                </div>
            </div>
            <div class="col-6 col-md-3">
                <select name="status" class="form-select">
                    <option value="">-- Trạng thái đơn --</option>
                    <option value="PENDING"    ${filterStatus == 'PENDING'    ? 'selected' : ''}>Chờ xử lý</option>
                    <option value="CONFIRMED"  ${filterStatus == 'CONFIRMED'  ? 'selected' : ''}>Đã xác nhận</option>
                    <option value="DELIVERING" ${filterStatus == 'DELIVERING' ? 'selected' : ''}>Đang giao</option>
                    <option value="COMPLETED"  ${filterStatus == 'COMPLETED'  ? 'selected' : ''}>Hoàn thành</option>
                    <option value="CANCELED"   ${filterStatus == 'CANCELED'   ? 'selected' : ''}>Đã hủy</option>
                </select>
            </div>
            <div class="col-6 col-md-3">
                <select name="paymentStatus" class="form-select">
                    <option value="">-- Thanh toán --</option>
                    <option value="UNPAID" ${filterPayment == 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                    <option value="PAID"   ${filterPayment == 'PAID'   ? 'selected' : ''}>Đã thanh toán</option>
                </select>
            </div>
            <div class="col-12 col-md-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-fill">
                    <i class="bi bi-funnel me-1"></i>Lọc
                </button>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary" title="Xóa bộ lọc">
                    <i class="bi bi-x-lg"></i>
                </a>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-hover align-middle text-center">
                <thead class="table-dark">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Ngày đặt</th>
                        <th>Trạng thái đơn</th>
                        <th>Thanh toán</th>
                        <th>Tổng tiền</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td class="fw-bold text-primary">${o.orderCode}</td>
                            <td>${o.customer != null ? o.customer.fullName : 'N/A'}</td>
                            <td class="text-muted small">${o.createdAt}</td>
                            <td>
                                <span class="badge bg-${o.status == 'COMPLETED' ? 'success' : o.status == 'CANCELED' ? 'danger' : o.status == 'DELIVERING' ? 'info text-dark' : o.status == 'CONFIRMED' ? 'primary' : 'warning text-dark'}">
                                    ${o.status}
                                </span>
                            </td>
                            <td>
                                <span class="badge bg-${o.paymentStatus == 'PAID' ? 'success' : 'warning text-dark'}">
                                    ${o.paymentStatus}
                                </span>
                                <br><small class="text-muted">${o.paymentMethod}</small>
                            </td>
                            <td class="text-danger fw-bold">$${o.totalAmount}</td>
                            <td>
                                <div class="d-flex gap-1 justify-content-center flex-wrap">
                                    <%-- Cập nhật trạng thái đơn --%>
                                    <c:choose>
                                        <c:when test="${o.status == 'PENDING'}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status" style="display:inline;">
                                                <input type="hidden" name="id" value="${o.id}">
                                                <input type="hidden" name="status" value="CONFIRMED">
                                                <button type="submit" class="btn btn-primary btn-sm" title="Xác nhận">
                                                    <i class="bi bi-check-circle"></i>
                                                </button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status" style="display:inline;">
                                                <input type="hidden" name="id" value="${o.id}">
                                                <input type="hidden" name="status" value="CANCELED">
                                                <button type="submit" class="btn btn-danger btn-sm" title="Hủy"
                                                        onclick="return confirm('Hủy đơn hàng này?')">
                                                    <i class="bi bi-x-circle"></i>
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:when test="${o.status == 'CONFIRMED'}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status" style="display:inline;">
                                                <input type="hidden" name="id" value="${o.id}">
                                                <input type="hidden" name="status" value="DELIVERING">
                                                <button type="submit" class="btn btn-info text-white btn-sm" title="Giao hàng">
                                                    <i class="bi bi-truck"></i>
                                                </button>
                                            </form>
                                        </c:when>
                                    </c:choose>

                                    <%-- THÊM MỚI: Xác nhận thanh toán nhanh từ danh sách --%>
                                    <c:if test="${o.paymentStatus != 'PAID' && o.status != 'CANCELED'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-payment-status" style="display:inline;">
                                            <input type="hidden" name="id" value="${o.id}">
                                            <input type="hidden" name="paymentStatus" value="PAID">
                                            <button type="submit" class="btn btn-success btn-sm" title="Xác nhận đã thanh toán"
                                                    onclick="return confirm('Xác nhận đã thu tiền?')">
                                                <i class="bi bi-cash-coin"></i>
                                            </button>
                                        </form>
                                    </c:if>

                                    <%-- Xem chi tiết --%>
                                    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.id}" title="Xem chi tiết">
                                        <i class="bi bi-eye"></i>
                                    </a>

                                    <%-- Xóa (chỉ Admin) --%>
                                    <c:if test="${sessionScope.role == 'ADMIN'}">
                                        <a class="btn btn-outline-danger btn-sm"
                                           href="${pageContext.request.contextPath}/admin/orders/delete?id=${o.id}"
                                           onclick="return confirm('Xóa đơn hàng này?')"
                                           title="Xóa">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr><td colspan="7" class="text-muted py-4">Không có đơn hàng nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
