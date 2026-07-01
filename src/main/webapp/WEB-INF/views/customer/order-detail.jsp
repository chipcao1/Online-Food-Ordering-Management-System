<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-lg-8">

      <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-dark mb-0">
          <i class="fa fa-receipt me-2 text-warning"></i>Chi tiết đơn hàng
        </h3>
        <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-secondary rounded-pill px-4">
          <i class="fa fa-arrow-left me-1"></i>Quay lại
        </a>
      </div>

      <div class="card border-0 shadow-sm rounded-4">

        <%-- Header đơn hàng --%>
        <div class="card-header bg-dark text-white rounded-top-4 py-3">
          <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
            <span class="fw-bold fs-5">${order.orderCode}</span>
            <span>
              <c:choose>
                <c:when test="${order.status == 'COMPLETED'}">
                  <span class="badge bg-success fs-6">✓ Hoàn thành</span>
                </c:when>
                <c:when test="${order.status == 'CANCELED'}">
                  <span class="badge bg-danger fs-6">✗ Đã hủy</span>
                </c:when>
                <c:when test="${order.status == 'DELIVERING'}">
                  <span class="badge bg-info text-dark fs-6">🚚 Đang giao</span>
                </c:when>
                <c:when test="${order.status == 'CONFIRMED'}">
                  <span class="badge bg-primary fs-6">✓ Đã xác nhận</span>
                </c:when>
                <c:otherwise>
                  <span class="badge bg-warning text-dark fs-6">⏳ Chờ xác nhận</span>
                </c:otherwise>
              </c:choose>
            </span>
          </div>
        </div>

        <div class="card-body p-4">

          <%-- Thông tin giao hàng & thanh toán --%>
          <div class="row mb-4">
            <div class="col-md-6 mb-3 mb-md-0">
              <h6 class="fw-bold text-muted text-uppercase border-bottom pb-2">Thông tin giao hàng</h6>
              <p class="mb-1"><i class="fa fa-map-marker me-2 text-danger"></i>${order.deliveryAddress}</p>
              <p class="mb-1"><i class="fa fa-phone me-2 text-success"></i>${order.deliveryPhone}</p>
              <c:if test="${not empty order.note}">
                <p class="mb-1 text-muted"><i class="fa fa-pencil me-2"></i><em>${order.note}</em></p>
              </c:if>
            </div>
            <div class="col-md-6">
              <h6 class="fw-bold text-muted text-uppercase border-bottom pb-2">Thanh toán</h6>
              <p class="mb-1"><strong>Phương thức:</strong>
                <span class="badge bg-secondary">${order.paymentMethod}</span>
              </p>
              <p class="mb-1"><strong>Trạng thái:</strong>
                <span class="badge bg-${order.paymentStatus == 'PAID' ? 'success' : 'warning'} text-${order.paymentStatus == 'PAID' ? 'white' : 'dark'}">
                  ${order.paymentStatus == 'PAID' ? 'Đã thanh toán' : 'Chưa thanh toán'}
                </span>
              </p>
              <p class="mb-1 text-muted small"><i class="fa fa-clock me-1"></i>
                Đặt lúc: ${order.createdAt}
              </p>
            </div>
          </div>

          <%-- Danh sách món ăn --%>
          <h6 class="fw-bold text-muted text-uppercase border-bottom pb-2 mb-3">Món đã đặt</h6>
          <div class="table-responsive mb-4">
            <table class="table table-bordered align-middle text-center">
              <thead class="table-light">
                <tr>
                  <th class="text-start">Món ăn</th>
                  <th>Đơn giá</th>
                  <th>SL</th>
                  <th>Thành tiền</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="item" items="${order.items}">
                  <tr>
                    <td class="text-start fw-semibold">${item.foodNameSnapshot}</td>
                    <td>$<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                    <td>${item.quantity}</td>
                    <td class="fw-bold text-danger">$<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                  </tr>
                </c:forEach>
              </tbody>
              <tfoot>
                <tr>
                  <td colspan="3" class="text-end text-muted">Tạm tính:</td>
                  <td>$<fmt:formatNumber value="${order.subtotal}" pattern="#,##0.00"/></td>
                </tr>
                <tr>
                  <td colspan="3" class="text-end text-muted">Phí vận chuyển:</td>
                  <td>+$<fmt:formatNumber value="${order.shippingFee}" pattern="#,##0.00"/></td>
                </tr>
                <tr class="table-warning">
                  <td colspan="3" class="text-end fw-bold fs-6">TỔNG CỘNG:</td>
                  <td class="fw-bold fs-6 text-danger">$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                </tr>
              </tfoot>
            </table>
          </div>

          <div class="d-flex justify-content-center gap-3 flex-wrap">
            <a href="${pageContext.request.contextPath}/menu" class="btn btn-warning text-white rounded-pill px-5">
              <i class="fa fa-plus me-2"></i>Đặt thêm món
            </a>
            <c:if test="${order.status == 'PENDING'}">
              <form action="${pageContext.request.contextPath}/cancel-order" method="POST"
                    onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này không?')">
                <input type="hidden" name="id" value="${order.id}">
                <button type="submit" class="btn btn-outline-danger rounded-pill px-5">
                  <i class="fa fa-times me-2"></i>Hủy đơn hàng
                </button>
              </form>
            </c:if>
          </div>

        </div>
      </div>
    </div>
  </div>
</div>
