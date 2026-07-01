<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-lg-8">

      <%-- Header xác nhận --%>
      <div class="text-center mb-5">
        <div style="width:80px;height:80px;background:#28a745;border-radius:50%;display:inline-flex;align-items:center;justify-content:center;margin-bottom:16px;">
          <i class="fa fa-check" style="font-size:36px;color:#fff;"></i>
        </div>
        <h2 class="fw-bold text-dark">Đặt hàng thành công!</h2>
        <p class="text-muted">Đơn hàng của bạn đang được xử lý và sẽ sớm được giao.</p>
      </div>

      <div class="card border-0 shadow-sm rounded-4">
        <div class="card-header bg-warning text-white rounded-top-4 py-3">
          <div class="d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-bold"><i class="fa fa-receipt me-2"></i>HÓA ĐƠN ĐẶT HÀNG</h5>
            <span class="badge bg-white text-warning fw-bold fs-6">${order.orderCode}</span>
          </div>
        </div>

        <div class="card-body p-4">

          <%-- Thông tin giao hàng & thanh toán --%>
          <div class="row mb-4">
            <div class="col-md-6 mb-3 mb-md-0">
              <h6 class="fw-bold text-muted border-bottom pb-2">THÔNG TIN GIAO HÀNG</h6>
              <p class="mb-1"><i class="fa fa-map-marker me-2 text-danger"></i><strong>Địa chỉ:</strong> ${order.deliveryAddress}</p>
              <p class="mb-1"><i class="fa fa-phone me-2 text-success"></i><strong>Điện thoại:</strong> ${order.deliveryPhone}</p>
              <c:if test="${not empty order.note}">
                <p class="mb-1"><i class="fa fa-sticky-note me-2 text-info"></i><strong>Ghi chú:</strong> ${order.note}</p>
              </c:if>
            </div>
            <div class="col-md-6">
              <h6 class="fw-bold text-muted border-bottom pb-2">THÔNG TIN THANH TOÁN</h6>
              <p class="mb-1"><strong>Phương thức:</strong>
                <span class="badge bg-info text-white">${order.paymentMethod}</span>
              </p>
              <p class="mb-1"><strong>Trạng thái TT:</strong>
                <span class="badge bg-${order.paymentStatus == 'PAID' ? 'success' : 'warning'} text-white">
                  ${order.paymentStatus == 'PAID' ? 'Đã thanh toán' : 'Chưa thanh toán'}
                </span>
              </p>
              <p class="mb-1"><strong>Trạng thái đơn:</strong>
                <span class="badge bg-warning text-dark">PENDING - Đang chờ xác nhận</span>
              </p>
            </div>
          </div>

          <%-- Danh sách món ăn --%>
          <h6 class="fw-bold text-muted border-bottom pb-2 mb-3">CHI TIẾT MÓN ĂN</h6>
          <div class="table-responsive mb-4">
            <table class="table table-bordered align-middle text-center">
              <thead style="background-color:#f8f9fa;">
                <tr>
                  <th class="text-start">Món ăn</th>
                  <th>Đơn giá</th>
                  <th>Số lượng</th>
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
                  <td class="fw-semibold">$<fmt:formatNumber value="${order.subtotal}" pattern="#,##0.00"/></td>
                </tr>
                <tr>
                  <td colspan="3" class="text-end text-muted">Phí giao hàng:</td>
                  <td class="fw-semibold">+$<fmt:formatNumber value="${order.shippingFee}" pattern="#,##0.00"/></td>
                </tr>
                <c:if test="${order.discountAmount != null && order.discountAmount > 0}">
                  <tr>
                    <td colspan="3" class="text-end text-muted">Giảm giá:</td>
                    <td class="fw-semibold text-success">-$<fmt:formatNumber value="${order.discountAmount}" pattern="#,##0.00"/></td>
                  </tr>
                </c:if>
                <tr style="background-color:#fff3cd;">
                  <td colspan="3" class="text-end fw-bold fs-5">TỔNG CỘNG:</td>
                  <td class="fw-bold fs-5 text-danger">$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                </tr>
              </tfoot>
            </table>
          </div>

          <%-- Nút hành động --%>
          <div class="d-flex gap-3 justify-content-center flex-wrap">
            <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-secondary rounded-pill px-4">
              <i class="fa fa-list me-2"></i>Xem đơn hàng của tôi
            </a>
            <a href="${pageContext.request.contextPath}/menu" class="btn btn-warning text-white rounded-pill px-4">
              <i class="fa fa-plus me-2"></i>Đặt thêm món
            </a>
          </div>

        </div>
      </div>

    </div>
  </div>
</div>
