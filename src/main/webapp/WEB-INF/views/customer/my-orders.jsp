<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<section class="cart-section layout_padding">
  <div class="container">
    <div class="heading_container heading_center mb-5">
      <h2>Lịch sử đơn hàng</h2>
    </div>

    <div class="card border-0 shadow-sm rounded-4" style="background: white;">
      <div class="card-body p-4">
        <div class="table-responsive">
          <table class="table table-hover align-middle text-center">
            <thead style="background-color: #222831; color: white;">
              <tr>
                <th>Mã đơn hàng</th>
                <th>Ngày đặt</th>
                <th>Trạng thái đơn</th>
                <th>Thanh toán</th>
                <th>Tổng tiền</th>
                <th>Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="o" items="${orders}">
                <tr>
                  <td class="fw-bold text-primary">${o.orderCode}</td>
                  <td class="text-muted small">${o.createdAt}</td>
                  <td>
                    <c:choose>
                      <c:when test="${o.status == 'COMPLETED'}">
                        <span class="badge bg-success px-3 py-2">✓ Hoàn thành</span>
                      </c:when>
                      <c:when test="${o.status == 'CANCELED'}">
                        <span class="badge bg-danger px-3 py-2">✗ Đã hủy</span>
                      </c:when>
                      <c:when test="${o.status == 'DELIVERING'}">
                        <span class="badge bg-info text-dark px-3 py-2">🚚 Đang giao</span>
                      </c:when>
                      <c:when test="${o.status == 'CONFIRMED'}">
                        <span class="badge bg-primary px-3 py-2">✓ Đã xác nhận</span>
                      </c:when>
                      <c:otherwise>
                        <span class="badge bg-warning text-dark px-3 py-2">⏳ Chờ xử lý</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <span class="badge bg-${o.paymentStatus == 'PAID' ? 'success' : 'warning'} text-${o.paymentStatus == 'PAID' ? 'white' : 'dark'}">
                      ${o.paymentStatus == 'PAID' ? 'Đã TT' : 'Chưa TT'}
                    </span>
                    <br><small class="text-muted">${o.paymentMethod}</small>
                  </td>
                  <td class="text-danger fw-bold">$${o.totalAmount}</td>
                  <td>
                    <div class="d-flex justify-content-center gap-2 flex-wrap">
                      <a href="${pageContext.request.contextPath}/order-detail?id=${o.id}"
                         class="btn btn-sm btn-outline-warning rounded-pill px-3">
                        <i class="fa fa-eye me-1"></i>Xem
                      </a>
                      <c:if test="${o.status == 'PENDING'}">
                        <form action="${pageContext.request.contextPath}/cancel-order" method="POST"
                              onsubmit="return confirm('Hủy đơn hàng ${o.orderCode}?')">
                          <input type="hidden" name="id" value="${o.id}">
                          <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                            <i class="fa fa-times me-1"></i>Hủy
                          </button>
                        </form>
                      </c:if>
                    </div>
                  </td>
                </tr>
              </c:forEach>
              <c:if test="${empty orders}">
                <tr>
                  <td colspan="6" class="text-muted py-5">
                    <i class="fa fa-file-text-o fa-3x mb-3 d-block"></i>
                    Bạn chưa có đơn hàng nào.
                  </td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>

        <div class="text-center mt-4">
          <a href="${pageContext.request.contextPath}/menu" class="btn btn-warning text-white rounded-pill px-5 py-2">
            <i class="fa fa-plus me-2"></i>Đặt món ngay
          </a>
        </div>
      </div>
    </div>
  </div>
</section>
