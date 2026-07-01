<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<main class="dashboard-content">
    <div class="container-fluid px-3 px-lg-4 py-4">
        <div class="page-heading">
            <div class="page-heading-copy"><span class="page-icon"><i class="bi bi-receipt"></i></span><div><p class="eyebrow mb-1">Order</p><h1 class="h3 mb-1">Order Form</h1></div></div>
            <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/admin/orders"><i class="bi bi-arrow-left"></i> Back</a>
        </div>
        <form:form method="post" modelAttribute="order" action="${pageContext.request.contextPath}/admin/orders/save" cssClass="panel">
            <form:hidden path="id"/>
            <div class="row g-3">
                <div class="col-md-4"><label class="form-label">Order date</label><form:input path="orderDate" type="date" cssClass="form-control"/></div>
                <div class="col-md-4"><label class="form-label">Customer</label><form:select path="customer.id" cssClass="form-select"><form:options items="${customers}" itemValue="id" itemLabel="fullName"/></form:select></div>
                <div class="col-md-4"><label class="form-label">Status</label><form:select path="status" cssClass="form-select"><option>PENDING</option><option>CONFIRMED</option><option>DELIVERING</option><option>COMPLETED</option><option>CANCELED</option></form:select></div>
                <div class="col-md-4"><label class="form-label">Payment method</label><form:select path="paymentMethod" cssClass="form-select"><option>COD</option><option>MOMO</option><option>VNPAY</option><option>ZALOPAY</option><option>BANK_TRANSFER</option><option>CASH</option></form:select></div>
                <div class="col-md-4"><label class="form-label">Delivery phone</label><form:input path="deliveryPhone" cssClass="form-control"/></div>
                <div class="col-md-4"><label class="form-label">Delivery address</label><form:input path="deliveryAddress" cssClass="form-control"/></div>
            </div>
            <h2 class="h5 mt-4">Food Items</h2>
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead><tr><th>Food</th><th>Price</th><th>Quantity</th></tr></thead>
                    <tbody>
                        <c:forEach var="foodItem" items="${foodItems}" varStatus="i">
                            <tr>
                                <td>${foodItem.foodName}<input type="hidden" name="details[${i.index}].foodItem.id" value="${foodItem.id}"></td>
                                <td>${foodItem.basePrice}</td>
                                <td><input class="form-control" type="number" name="details[${i.index}].quantity" value="0" min="0"></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="d-flex justify-content-end"><button class="btn btn-primary" type="submit"><i class="bi bi-save"></i> Save Order</button></div>
        </form:form>
    </div>
</main>