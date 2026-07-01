<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<main class="dashboard-content">
<div class="container-fluid px-3 px-lg-4 py-4">
    <div class="page-heading">
        <div class="page-heading-copy">
            <span class="page-icon"><i class="bi bi-cup-hot"></i></span>
            <div>
                <p class="eyebrow mb-1">Menu Management</p>
                <h1 class="h3 mb-1">Danh sách món ăn</h1>
                <p class="text-muted mb-0">Quản lý menu nhà hàng.</p>
            </div>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/food-items/add">
            <i class="bi bi-plus-circle"></i> Thêm món ăn
        </a>
    </div>

    <section class="panel">
        <div class="panel-header">
            <form class="row g-2 w-100" method="get" action="${pageContext.request.contextPath}/admin/food-items">
                <div class="col-12 col-md-5">
                    <input class="form-control" name="keyword" value="${keyword}" placeholder="Tìm tên, mô tả...">
                </div>
                <div class="col-12 col-md-4">
                    <select class="form-select" name="categoryId">
                        <option value="0">Tất cả danh mục</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}" ${cat.id == categoryId ? 'selected' : ''}>${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-12 col-md-3">
                    <button class="btn btn-primary w-100" type="submit">
                        <i class="bi bi-search"></i> Tìm kiếm
                    </button>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th style="width:60px">Ảnh</th>
                        <th>Tên món</th>
                        <th>Danh mục</th>
                        <th>Giá gốc</th>
                        <th>Giá KM</th>
                        <th>Tồn kho</th>
                        <th>Trạng thái</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${foodItems}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty p.thumbnailUrl}">
                                        <img src="${pageContext.request.contextPath}${p.thumbnailUrl}"
                                             style="width:48px;height:48px;object-fit:cover;border-radius:8px;border:1px solid #dee2e6;"
                                             onerror="this.src='${pageContext.request.contextPath}/feane/images/favicon.png'"
                                             alt="${p.foodName}">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width:48px;height:48px;background:#f0f0f0;border-radius:8px;display:flex;align-items:center;justify-content:center;">
                                            <i class="bi bi-image text-muted"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="fw-semibold">${p.foodName}</div>
                                <small class="text-muted">${p.description}</small>
                            </td>
                            <td><span class="badge bg-light text-dark border">${p.category.categoryName}</span></td>
                            <td class="fw-semibold">$${p.basePrice}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.salePrice != null && p.salePrice > 0}">
                                        <span class="text-danger fw-bold">$${p.salePrice}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.stockQuantity <= 0}">
                                        <span class="badge bg-danger">Hết hàng</span>
                                    </c:when>
                                    <c:when test="${p.stockQuantity < 10}">
                                        <span class="badge bg-warning text-dark">
                                            <i class="bi bi-exclamation-triangle"></i> ${p.stockQuantity}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">${p.stockQuantity}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="badge ${p.active ? 'text-bg-success' : 'text-bg-secondary'}">
                                    ${p.active ? 'Đang bán' : 'Ẩn'}
                                </span>
                                <c:if test="${p.featured}">
                                    <span class="badge text-bg-warning ms-1"><i class="bi bi-star-fill"></i></span>
                                </c:if>
                            </td>
                            <td class="text-end">
                                <a class="btn btn-warning btn-sm" href="${pageContext.request.contextPath}/admin/food-items/edit/${p.id}" title="Sửa">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a class="btn btn-danger btn-sm ms-1" href="${pageContext.request.contextPath}/admin/food-items/delete/${p.id}"
                                   onclick="return confirm('Xóa món ăn này?')" title="Xóa">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty foodItems}">
                        <tr><td colspan="8" class="text-center text-muted py-4">Không có món ăn nào.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </section>
</div>
</main>
