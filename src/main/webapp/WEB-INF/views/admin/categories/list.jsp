<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<main class="dashboard-content">
    <div class="container-fluid px-3 px-lg-4 py-4">
        <section class="panel">
            <div class="panel-header">
                <form class="d-flex gap-2" method="get" action="${pageContext.request.contextPath}/admin/categories">
                    <input class="form-control" name="keyword" value="${keyword}" placeholder="Search category">
                    <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i></button>
                </form>
            </div>
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${categories}">
                            <tr>
                                <td>${c.id}</td>
                                <td class="fw-semibold"><c:out value="${c.categoryName}" /></td>
                                <td><c:out value="${c.description}" /></td>
                                <td>${c.active ? 'Active' : 'Inactive'}</td>
                                <td class="text-end">
                                    <a class="btn btn-warning btn-sm" href="${pageContext.request.contextPath}/admin/categories/edit/${c.id}"><i class="bi bi-pencil"></i></a> 
                                    <a class="btn btn-danger btn-sm" href="${pageContext.request.contextPath}/admin/categories/delete/${c.id}" onclick="return confirm('Delete this category?')"><i class="bi bi-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</main>