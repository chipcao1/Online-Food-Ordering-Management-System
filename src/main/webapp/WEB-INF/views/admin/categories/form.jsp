<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<main class="dashboard-content">
    <div class="container-fluid px-3 px-lg-4 py-4">
        <div class="page-heading">
            <div class="page-heading-copy"><span class="page-icon"><i class="bi bi-tags"></i></span><div><p class="eyebrow mb-1">Menu</p><h1 class="h3 mb-1">Category Form</h1></div></div>
            <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-arrow-left"></i> Back</a>
        </div>
        <form:form method="post" modelAttribute="category" action="${pageContext.request.contextPath}/admin/categories/save" cssClass="panel">
            <form:hidden path="id"/>
            <div class="row g-3">
                <div class="col-md-5">
                    <label class="form-label">Category Name</label>
                    <form:input path="categoryName" cssClass="form-control"/>
                    <form:errors path="categoryName" cssClass="text-danger small"/>
                </div>
                <div class="col-md-7"><label class="form-label">Description</label><form:input path="description" cssClass="form-control"/></div>
                <div class="col-12"><label class="form-check"><form:checkbox path="active" cssClass="form-check-input"/><span class="form-check-label">Active</span></label></div>
            </div>
            <div class="d-flex justify-content-end mt-4"><button class="btn btn-primary" type="submit"><i class="bi bi-save"></i> Save Category</button></div>
        </form:form>
    </div>
</main>