<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<main class="dashboard-content">
    <div class="container-fluid px-3 px-lg-4 py-4">
        <form:form method="post" modelAttribute="customer" action="${pageContext.request.contextPath}/admin/customers/save" cssClass="panel">
            <form:hidden path="id"/>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Full Name</label>
                    <form:input path="fullName" cssClass="form-control"/>
                    <form:errors path="fullName" cssClass="text-danger small"/>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Email</label>
                    <form:input path="email" type="email" cssClass="form-control"/>
                    <form:errors path="email" cssClass="text-danger small"/>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Phone</label>
                    <form:input path="phone" cssClass="form-control"/>
                </div>
                <div class="col-md-8">
                    <label class="form-label">Address</label>
                    <form:input path="address" cssClass="form-control"/>
                </div>
            </div>
            <div class="d-flex justify-content-end gap-2 mt-4">
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/customers">Cancel</a>
                <button class="btn btn-primary" type="submit"><i class="bi bi-save"></i> Save Customer</button>
            </div>
        </form:form>
    </div>
</main>