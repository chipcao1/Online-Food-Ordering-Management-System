<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<main class="dashboard-content">
<div class="container-fluid px-3 px-lg-4 py-4">
    <div class="page-heading">
        <div class="page-heading-copy">
            <span class="page-icon"><i class="bi bi-cup-hot"></i></span>
            <div>
                <p class="eyebrow mb-1">Menu Management</p>
                <h1 class="h3 mb-1">${empty foodItem.id ? 'Thêm món ăn' : 'Chỉnh sửa món ăn'}</h1>
            </div>
        </div>
        <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/admin/food-items">
            <i class="bi bi-arrow-left"></i> Quay lại
        </a>
    </div>

    <c:if test="${not empty uploadError}">
        <div class="alert alert-warning"><i class="bi bi-exclamation-triangle"></i> ${uploadError}</div>
    </c:if>
    <c:if test="${not empty formErrors}">
        <div class="alert alert-danger">
            <i class="bi bi-x-circle me-1"></i> <strong>Vui lòng kiểm tra lại:</strong>
            <ul class="mb-0 mt-1">
                <c:forEach var="err" items="${formErrors}">
                    <li>${err}</li>
                </c:forEach>
            </ul>
        </div>
    </c:if>

    <%-- Dùng action thuần HTML để hỗ trợ multipart --%>
    <form method="post" enctype="multipart/form-data"
          action="${pageContext.request.contextPath}/admin/food-items/save"
          class="panel">

        <%-- Hidden fields cho Spring form binding (thay form:form) --%>
        <input type="hidden" name="id" value="${foodItem.id}"/>
        <input type="hidden" name="thumbnailUrl" value="${foodItem.thumbnailUrl}"/>

        <div class="row g-4">

            <%-- Cột trái: thông tin chính --%>
            <div class="col-lg-8">
                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label fw-bold">Tên món ăn <span class="text-danger">*</span></label>
                        <input type="text" name="foodName" value="${foodItem.foodName}"
                               class="form-control form-control-lg" required
                               placeholder="VD: Phở bò đặc biệt">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Danh mục <span class="text-danger">*</span></label>
                        <select name="category.id" class="form-select" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}"
                                    ${foodItem.category != null && foodItem.category.id == cat.id ? 'selected' : ''}>
                                    ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Đơn vị</label>
                        <input type="text" name="unit" value="${foodItem.unit}"
                               class="form-control" placeholder="VD: phần, ly, tô">
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-bold">Mô tả</label>
                        <textarea name="description" class="form-control" rows="3"
                                  placeholder="Mô tả ngắn về món ăn...">${foodItem.description}</textarea>
                    </div>

                    <%-- Giá --%>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Giá gốc (VNĐ) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text">$</span>
                            <input type="number" name="basePrice" value="${foodItem.basePrice}"
                                   class="form-control" min="0" step="0.01" required
                                   placeholder="0.00">
                        </div>
                        <small class="text-muted">Không được âm</small>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Giá khuyến mãi</label>
                        <div class="input-group">
                            <span class="input-group-text">$</span>
                            <input type="number" name="salePrice" value="${foodItem.salePrice}"
                                   class="form-control" min="0" step="0.01"
                                   placeholder="0.00 = không KM">
                        </div>
                        <small class="text-muted">Để 0 nếu không khuyến mãi</small>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Tồn kho <span class="text-danger">*</span></label>
                        <input type="number" name="stockQuantity" value="${foodItem.stockQuantity}"
                               class="form-control" min="0" required placeholder="0">
                        <small class="text-muted">Cảnh báo thấp: dưới 10</small>
                    </div>

                    <%-- Trạng thái --%>
                    <div class="col-12">
                        <label class="form-label fw-bold d-block">Trạng thái</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" name="active" value="true"
                                   id="chkActive" ${foodItem.active ? 'checked' : ''}>
                            <label class="form-check-label" for="chkActive">
                                <i class="bi bi-check-circle text-success"></i> Đang bán
                            </label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" name="featured" value="true"
                                   id="chkFeatured" ${foodItem.featured ? 'checked' : ''}>
                            <label class="form-check-label" for="chkFeatured">
                                <i class="bi bi-star text-warning"></i> Nổi bật
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Cột phải: ảnh --%>
            <div class="col-lg-4">
                <label class="form-label fw-bold">Hình ảnh món ăn</label>

                <%-- Preview ảnh hiện tại --%>
                <div class="mb-3 text-center">
                    <div id="imgPreviewWrapper" style="
                        width:100%; height:200px; border:2px dashed #dee2e6;
                        border-radius:12px; display:flex; align-items:center;
                        justify-content:center; background:#f8f9fa; overflow:hidden;">
                        <c:choose>
                            <c:when test="${not empty foodItem.thumbnailUrl}">
                                <img id="imgPreview"
                                     src="${pageContext.request.contextPath}${foodItem.thumbnailUrl}"
                                     style="max-width:100%;max-height:200px;object-fit:cover;border-radius:10px;"
                                     onerror="this.style.display='none';document.getElementById('imgPlaceholder').style.display='flex'">
                                <div id="imgPlaceholder" style="display:none;flex-direction:column;align-items:center;color:#adb5bd;">
                                    <i class="bi bi-image fs-1"></i>
                                    <span class="small">Preview ảnh</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div id="imgPlaceholder" style="display:flex;flex-direction:column;align-items:center;color:#adb5bd;">
                                    <i class="bi bi-image fs-1"></i>
                                    <span class="small">Preview ảnh</span>
                                </div>
                                <img id="imgPreview" style="display:none;max-width:100%;max-height:200px;object-fit:cover;border-radius:10px;">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%-- Upload file --%>
                <div class="mb-3">
                    <label class="form-label fw-semibold text-primary">
                        <i class="bi bi-upload"></i> Tải ảnh từ máy tính
                    </label>
                    <input type="file" name="imageFile" id="imageFileInput"
                           class="form-control" accept="image/*"
                           onchange="previewUploadedImage(this)">
                    <small class="text-muted">Định dạng: JPG, PNG, GIF. Tối đa 5MB.</small>
                </div>

                <%-- Hoặc nhập URL --%>
                <div class="mb-2">
                    <label class="form-label fw-semibold text-secondary">
                        <i class="bi bi-link-45deg"></i> Hoặc nhập đường dẫn URL
                    </label>
                    <input type="text" name="thumbnailUrlText" id="thumbnailUrlInput"
                           class="form-control"
                           value="${foodItem.thumbnailUrl}"
                           placeholder="/feane/images/f1.png"
                           oninput="previewFromUrl(this.value)">
                    <small class="text-muted">Đường dẫn tương đối từ root webapp (VD: /feane/images/f1.png)</small>
                </div>

                <%-- Danh sách ảnh sẵn có --%>
                <div class="mt-3">
                    <small class="fw-semibold text-muted d-block mb-2">Ảnh có sẵn trong hệ thống:</small>
                    <div class="d-flex flex-wrap gap-1">
                        <c:forEach begin="1" end="9" var="i">
                            <img src="${pageContext.request.contextPath}/feane/images/f${i}.png"
                                 style="width:40px;height:40px;object-fit:cover;border-radius:6px;cursor:pointer;border:2px solid transparent;"
                                 onclick="selectExistingImage('/feane/images/f${i}.png', this)"
                                 title="/feane/images/f${i}.png"
                                 onerror="this.style.display='none'">
                        </c:forEach>
                    </div>
                    <small class="text-muted">Click ảnh để chọn</small>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
            <a class="btn btn-outline-secondary px-4" href="${pageContext.request.contextPath}/admin/food-items">
                <i class="bi bi-x-circle"></i> Hủy
            </a>
            <button class="btn btn-primary px-5" type="submit">
                <i class="bi bi-save"></i> ${empty foodItem.id ? 'Thêm món ăn' : 'Lưu thay đổi'}
            </button>
        </div>
    </form>
</div>
</main>

<script>
function previewUploadedImage(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            showPreview(e.target.result);
            // Clear URL input khi chọn file
            document.getElementById('thumbnailUrlInput').value = '';
        };
        reader.readAsDataURL(input.files[0]);
    }
}

function previewFromUrl(url) {
    if (url && url.trim()) {
        const base = '${pageContext.request.contextPath}';
        const fullUrl = url.startsWith('http') ? url : base + url;
        showPreview(fullUrl);
        // Clear file input khi nhập URL
        document.getElementById('imageFileInput').value = '';
    }
}

function selectExistingImage(path, el) {
    // Bỏ highlight tất cả
    document.querySelectorAll('[onclick^="selectExistingImage"]').forEach(img => {
        img.style.border = '2px solid transparent';
    });
    // Highlight ảnh được chọn
    el.style.border = '2px solid #0d6efd';

    document.getElementById('thumbnailUrlInput').value = path;
    const base = '${pageContext.request.contextPath}';
    showPreview(base + path);
    document.getElementById('imageFileInput').value = '';
}

function showPreview(src) {
    const preview = document.getElementById('imgPreview');
    const placeholder = document.getElementById('imgPlaceholder');
    preview.src = src;
    preview.style.display = 'block';
    preview.onerror = function() {
        this.style.display = 'none';
        placeholder.style.display = 'flex';
    };
    if (placeholder) placeholder.style.display = 'none';
}
</script>
