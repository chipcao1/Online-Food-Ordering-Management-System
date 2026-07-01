<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
.menu-hero {
    background: linear-gradient(135deg, #222831 0%, #393e46 100%);
    padding: 48px 0 32px;
}
.menu-hero h2 { color: #fff; font-weight: 800; font-size: 2.2rem; }
.menu-hero p  { color: rgba(255,255,255,.65); }

/* Category bar – KHÔNG sticky để tránh che badge */
.category-bar {
    background: #fff;
    border-bottom: 1px solid #f0f0f0;
    padding: 14px 0;
}
.category-pill {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 7px 18px; border-radius: 50px; cursor: pointer;
    border: 2px solid #dee2e6; background: #fff; color: #495057;
    font-weight: 600; font-size: .875rem; transition: all .2s;
    white-space: nowrap; user-select: none;
}
.category-pill:hover, .category-pill.active {
    background: #ffc107; border-color: #ffc107; color: #222;
    box-shadow: 0 4px 12px rgba(255,193,7,.35);
}

.food-card {
    border: none; border-radius: 16px; overflow: hidden;
    box-shadow: 0 2px 12px rgba(0,0,0,.08);
    transition: transform .25s, box-shadow .25s;
    height: 100%; background: #fff;
}
.food-card:hover { transform: translateY(-5px); box-shadow: 0 8px 28px rgba(0,0,0,.14); }

.food-card .img-wrap {
    position: relative; height: 190px; overflow: hidden; background: #f0f0f0;
}
.food-card .img-wrap img {
    width: 100%; height: 100%; object-fit: cover; transition: transform .4s;
}
.food-card:hover .img-wrap img { transform: scale(1.07); }

.badge-stock {
    position: absolute; top: 10px; right: 10px;
    font-size: .7rem; padding: 4px 10px; border-radius: 20px; font-weight: 700;
}

.food-card .card-body { padding: 16px 18px 18px; display: flex; flex-direction: column; gap: 6px; }
.food-title { font-weight: 700; font-size: .97rem; color: #222; line-height: 1.3; }
.food-desc {
    color: #888; font-size: .8rem;
    display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}

/* Badge "Bán chạy" đặt trong card body – không bao giờ bị sticky bar che */
.badge-banchay {
    display: inline-flex; align-items: center; gap: 4px;
    background: #fff3cd; color: #856404;
    font-size: .7rem; font-weight: 700;
    padding: 3px 10px; border-radius: 20px; border: 1px solid #ffc107;
    width: fit-content;
}

.price-block { display: flex; align-items: baseline; gap: 6px; }
.price-current { font-size: 1.1rem; font-weight: 800; color: #e74c3c; }
.price-original { font-size: .82rem; color: #aaa; text-decoration: line-through; }

.btn-add-cart {
    background: #ffc107; color: #222; border: none; border-radius: 50px;
    padding: 8px 20px; font-weight: 700; font-size: .85rem;
    transition: all .2s; width: 100%; margin-top: auto;
    text-align: center; text-decoration: none; display: block;
}
.btn-add-cart:hover:not(:disabled) { background: #e0a800; color: #222; }
.btn-add-cart:disabled { background: #e9ecef; color: #aaa; cursor: not-allowed; }

.search-bar { position: relative; }
.search-bar input {
    border-radius: 50px; padding-left: 44px;
    border: 2px solid rgba(255,255,255,.3);
    background: rgba(255,255,255,.1); color: #fff;
}
.search-bar input::placeholder { color: rgba(255,255,255,.5); }
.search-bar input:focus {
    border-color: #ffc107; box-shadow: 0 0 0 .2rem rgba(255,193,7,.3);
    background: rgba(255,255,255,.15); color: #fff;
}
.search-bar .search-icon {
    position: absolute; left: 15px; top: 50%; transform: translateY(-50%);
    color: rgba(255,255,255,.6); pointer-events: none;
}

.section-foods { padding: 32px 0 64px; background: #f8f9fa; }
</style>

<%-- Hero + search --%>
<div class="menu-hero">
    <div class="container text-center">
        <h2><i class="fa fa-utensils me-2"></i>Thực đơn của chúng tôi</h2>
        <p class="mb-4">Chọn món ngon, giao tận nơi nhanh chóng!</p>
        <div class="row justify-content-center">
            <div class="col-md-6">
                <form action="${pageContext.request.contextPath}/menu" method="GET" class="search-bar">
                    <i class="fa fa-search search-icon"></i>
                    <input type="text" name="keyword" value="${keyword}"
                           class="form-control form-control-lg"
                           placeholder="Tìm kiếm món ăn...">
                </form>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/menu"
                       class="btn btn-outline-light btn-sm mt-2 rounded-pill">
                        <i class="fa fa-times me-1"></i>Xóa tìm kiếm
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</div>

<%-- Category filter pills (không sticky) --%>
<div class="category-bar">
    <div class="container">
        <div class="d-flex gap-2 flex-wrap">
            <span class="category-pill active" onclick="filterCategory('*', this)">
                <i class="fa fa-th"></i> Tất cả
            </span>
            <c:forEach var="cat" items="${categories}">
                <span class="category-pill" data-cat="${cat.id}"
                      onclick="filterCategory('${cat.id}', this)">
                    ${cat.categoryName}
                </span>
            </c:forEach>
        </div>
    </div>
</div>

<%-- Food grid --%>
<div class="section-foods">
    <div class="container">
        <c:if test="${not empty keyword}">
            <div class="mb-3">
                <span class="text-muted">Kết quả cho: </span>
                <strong class="text-warning">"${keyword}"</strong>
            </div>
        </c:if>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xl-4 g-4" id="foodGrid">
            <c:forEach var="f" items="${foodItems}">
                <div class="col food-col" data-cat="${f.category.id}">
                    <div class="food-card card">

                        <%-- Ảnh: chỉ badge stock, không có badge featured --%>
                        <div class="img-wrap">
                            <img src="${pageContext.request.contextPath}${f.thumbnailUrl}"
                                 alt="${f.foodName}"
                                 onerror="this.src='${pageContext.request.contextPath}/feane/images/favicon.png'">
                            <c:choose>
                                <c:when test="${f.stockQuantity <= 0}">
                                    <span class="badge-stock" style="background:#dc3545;color:#fff;">Hết hàng</span>
                                </c:when>
                                <c:when test="${f.stockQuantity < 10}">
                                    <span class="badge-stock" style="background:#fd7e14;color:#fff;">Còn ${f.stockQuantity}</span>
                                </c:when>
                            </c:choose>
                        </div>

                        <%-- Card body --%>
                        <div class="card-body">
                            <%-- Badge "Bán chạy" trong body – luôn hiển thị, không bị che --%>
                            <c:if test="${f.featured}">
                                <span class="badge-banchay">
                                    <i class="fa fa-fire"></i> Bán chạy
                                </span>
                            </c:if>

                            <div class="food-title">${f.foodName}</div>
                            <div class="food-desc">${f.description}</div>

                            <div class="price-block mt-1">
                                <c:choose>
                                    <c:when test="${f.salePrice != null && f.salePrice > 0}">
                                        <span class="price-current">$${f.salePrice}</span>
                                        <span class="price-original">$${f.basePrice}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="price-current">$${f.basePrice}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <c:choose>
                                <c:when test="${f.stockQuantity <= 0}">
                                    <button class="btn-add-cart mt-2" disabled>
                                        <i class="fa fa-times-circle me-1"></i>Hết hàng
                                    </button>
                                </c:when>
                                <c:when test="${not empty sessionScope.loggedInUser}">
                                    <form action="${pageContext.request.contextPath}/cart/add" method="POST" class="mt-2">
                                        <input type="hidden" name="foodId" value="${f.id}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn-add-cart">
                                            <i class="fa fa-shopping-cart me-1"></i>Thêm vào giỏ
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login"
                                       class="btn-add-cart mt-2">
                                        <i class="fa fa-sign-in me-1"></i>Đăng nhập để đặt
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty foodItems}">
                <div class="col-12 text-center py-5">
                    <i class="fa fa-search fa-3x text-muted mb-3 d-block"></i>
                    <p class="text-muted fs-5">Không tìm thấy món ăn phù hợp.</p>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-warning rounded-pill px-4">
                        Xem tất cả menu
                    </a>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
function filterCategory(catId, el) {
    document.querySelectorAll('.category-pill').forEach(p => p.classList.remove('active'));
    el.classList.add('active');
    document.querySelectorAll('#foodGrid .food-col').forEach(col => {
        col.style.display = (catId === '*' || col.dataset.cat === String(catId)) ? '' : 'none';
    });
}
</script>
