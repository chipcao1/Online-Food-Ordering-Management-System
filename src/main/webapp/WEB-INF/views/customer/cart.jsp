<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<section class="cart-section layout_padding">
  <div class="container">
    <div class="heading_container heading_center mb-5"><h2>Your Shopping Cart</h2></div>
    <c:choose>
      <c:when test="${empty sessionScope.cart || empty sessionScope.cart.items}">
        <div class="text-center py-5">
          <i class="fa fa-shopping-basket fa-5x text-muted mb-4"></i>
          <h4 class="text-muted">Your cart is completely empty.</h4>
          <a href="${pageContext.request.contextPath}/menu" class="btn btn-warning mt-3 text-white rounded-pill px-4 py-2">Explore Menu</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="row">
          <div class="col-lg-8 mb-4">
            <div class="table-responsive">
              <table class="table cart-table text-center">
                <thead><tr><th>Food</th><th>Price</th><th>Quantity</th><th>Subtotal</th><th>Action</th></tr></thead>
                <tbody>
                  <c:forEach var="item" items="${sessionScope.cart.items}">
                    <tr>
                      <td class="text-left font-weight-bold"><c:out value="${item.foodItem.foodName}"/></td>
                      <td>$<c:out value="${item.foodItem.salePrice gt 0 ? item.foodItem.salePrice : item.foodItem.basePrice}"/></td>
                      <td>
                        <form action="${pageContext.request.contextPath}/cart/update" method="POST" class="d-flex justify-content-center">
                          <input type="hidden" name="foodId" value="${item.foodItem.id}">
                          <input type="number" name="quantity" value="${item.quantity}" min="1" class="form-control text-center me-2" style="width:70px;">
                          <button type="submit" class="btn btn-sm btn-info text-white"><i class="fa fa-refresh"></i></button>
                        </form>
                      </td>
                      <td class="font-weight-bold text-danger">$<c:out value="${item.subtotal}"/></td>
                      <td>
                        <form action="${pageContext.request.contextPath}/cart/remove" method="POST">
                          <input type="hidden" name="foodId" value="${item.foodItem.id}">
                          <button type="submit" class="btn btn-sm btn-danger"><i class="fa fa-trash"></i></button>
                        </form>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>

          <div class="col-lg-4">
            <div class="checkout-box">
              <h4 class="mb-4">Order Summary</h4>
              <div class="d-flex justify-content-between mb-3">
                <span>Subtotal</span><strong>$<c:out value="${sessionScope.cart.totalAmount}"/></strong>
              </div>
              <div class="d-flex justify-content-between mb-3">
                <span>Shipping</span><strong>$5.00</strong>
              </div>
              <hr>
              <%-- ĐÃ SỬA: tính tổng bằng EL fmt thay vì số học trực tiếp trên BigDecimal --%>
              <div class="d-flex justify-content-between mb-4">
                <span class="font-weight-bold">Total</span>
                <strong class="text-danger fs-4">
                  $${sessionScope.cart.totalAmount + 5.00}
                </strong>
              </div>

              <form action="${pageContext.request.contextPath}/checkout" method="POST">
                <div class="form-group mb-3">
                  <label>Delivery Address <span class="text-danger">*</span></label>
                  <input type="text" name="address" class="form-control" required
                         value="${prefillAddress}"
                         placeholder="Nhập địa chỉ nhận hàng">
                </div>
                <div class="form-group mb-3">
                  <label>Phone <span class="text-danger">*</span></label>
                  <input type="tel" name="phone" class="form-control" required
                         pattern="0[0-9]{9}"
                         title="Số điện thoại 10 chữ số bắt đầu bằng 0"
                         value="${prefillPhone}"
                         placeholder="0xxxxxxxxx">
                </div>

                <%-- ĐÃ THÊM: các tùy chọn thanh toán đầy đủ theo enum PaymentMethod --%>
                <div class="form-group mb-3">
                  <label>Payment Method</label>
                  <select name="paymentMethod" class="form-control">
                    <option value="COD">COD - Thanh toán khi nhận hàng</option>
                    <option value="MOMO">MoMo</option>
                    <option value="VNPAY">VNPay</option>
                    <option value="ZALOPAY">ZaloPay</option>
                    <option value="BANK_TRANSFER">Chuyển khoản ngân hàng</option>
                    <option value="CASH">Tiền mặt</option>
                  </select>
                </div>

                <div class="form-group mb-4">
                  <label>Note</label>
                  <textarea name="note" class="form-control" rows="2" placeholder="Ghi chú thêm (tùy chọn)"></textarea>
                </div>

                <c:choose>
                  <c:when test="${not empty sessionScope.loggedInUser}">
                    <button type="submit" class="btn btn-warning w-100 text-white rounded-pill py-2 fw-bold">
                      <i class="fa fa-shopping-cart"></i> Place Order
                    </button>
                  </c:when>
                  <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary w-100 rounded-pill py-2">
                      Login to Checkout
                    </a>
                  </c:otherwise>
                </c:choose>
              </form>
            </div>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</section>
