<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<main class="dashboard-content">
    <div class="container-fluid px-3 px-lg-4 py-4">
        <div class="page-heading">
            <div class="page-heading-copy">
                <span class="page-icon"><i class="bi bi-shop"></i></span>
                <div>
                    <p class="eyebrow mb-1">Online Food Ordering</p>
                    <h1 class="h3 mb-1">Restaurant Dashboard</h1>
                    <p class="text-muted mb-0">Overview of revenue, top selling foods, and loyal customers.</p>
                </div>
            </div>
            </div>

        <section class="row g-3 mt-1">
            <div class="col-12 col-sm-6 col-xl-3">
                <article class="metric-card metric-primary" style="background-color: #e7f1ff; border-radius: 10px; padding: 20px;">
                    <div class="metric-top d-flex justify-content-between">
                        <span class="metric-label fw-bold text-primary">Today's Revenue</span>
                        <span class="metric-icon"><i class="bi bi-currency-dollar fs-4 text-primary"></i></span>
                    </div>
                    <div class="metric-value fs-2 fw-bold text-dark mt-2">$<c:out value="${dailyRevenue}"/></div>
                    <div class="metric-meta text-muted small mt-1">Total completed today</div>
                </article>
            </div>
            
            <div class="col-12 col-sm-6 col-xl-3">
                <article class="metric-card metric-success" style="background-color: #e6f8f0; border-radius: 10px; padding: 20px;">
                    <div class="metric-top d-flex justify-content-between">
                        <span class="metric-label fw-bold text-success">This Month</span>
                        <span class="metric-icon"><i class="bi bi-wallet2 fs-4 text-success"></i></span>
                    </div>
                    <div class="metric-value fs-2 fw-bold text-dark mt-2">$<c:out value="${monthlyRevenue}"/></div>
                    <div class="metric-meta text-muted small mt-1">Monthly revenue</div>
                </article>
            </div>
            
            <div class="col-12 col-sm-6 col-xl-3">
                <article class="metric-card metric-warning" style="background-color: #fff8e6; border-radius: 10px; padding: 20px;">
                    <div class="metric-top d-flex justify-content-between">
                        <span class="metric-label fw-bold text-warning">This Year</span>
                        <span class="metric-icon"><i class="bi bi-graph-up-arrow fs-4 text-warning"></i></span>
                    </div>
                    <div class="metric-value fs-2 fw-bold text-dark mt-2">$<c:out value="${yearlyRevenue}"/></div>
                    <div class="metric-meta text-muted small mt-1">Year-to-date total</div>
                </article>
            </div>
            
            <div class="col-12 col-sm-6 col-xl-3">
                <article class="metric-card metric-danger" style="background-color: #fdf3f5; border-radius: 10px; padding: 20px;">
                    <div class="metric-top d-flex justify-content-between">
                        <span class="metric-label fw-bold text-danger">Quick Access</span>
                        <span class="metric-icon"><i class="bi bi-box-arrow-up-right fs-4 text-danger"></i></span>
                    </div>
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-outline-danger w-100 mb-2">View All Orders</a>
                        <a href="${pageContext.request.contextPath}/admin/food-items" class="btn btn-sm btn-danger w-100">Manage Menu</a>
                    </div>
                </article>
            </div>
        </section>

        <section class="row g-4 mt-3">
            
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm rounded-4 h-100">
                    <div class="card-body p-4">
                        <h5 class="card-title fw-bold text-dark mb-4"><i class="bi bi-bar-chart-fill text-primary"></i> Top 5 Selling Foods</h5>
                        <canvas id="topFoodsChart" height="120"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="card border-0 shadow-sm rounded-4 h-100">
                    <div class="card-body p-4">
                        <h5 class="card-title fw-bold text-dark mb-4"><i class="bi bi-award-fill text-warning"></i> Top 5 Loyal Customers</h5>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Rank</th>
                                        <th>Customer Name</th>
                                        <th class="text-center">Total Orders</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="customer" items="${topCustomers}" varStatus="status">
                                        <tr>
                                            <td>
                                                <span class="badge ${status.index == 0 ? 'bg-warning' : (status.index == 1 ? 'bg-secondary' : 'bg-primary')} rounded-circle p-2">
                                                    #${status.index + 1}
                                                </span>
                                            </td>
                                            <td class="fw-semibold"><c:out value="${customer[0]}" /></td>
                                            <td class="text-center"><span class="badge bg-success">${customer[1]} orders</span></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty topCustomers}">
                                        <tr><td colspan="3" class="text-center text-muted">No data available</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </section>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    // 1. Lấy dữ liệu từ JSP (Spring Model) đẩy vào mảng Javascript
    var labels = [];
    var dataPoints = [];
    
    // Vòng lặp JSP sinh ra mã JS động
    <c:forEach var="food" items="${topFoods}">
        labels.push('<c:out value="${food[0]}" />'); // Tên món ăn
        dataPoints.push(${food[1]});                 // Số lượng bán ra
    </c:forEach>

    // 2. Vẽ biểu đồ nếu có dữ liệu
    if(labels.length > 0) {
        var ctx = document.getElementById('topFoodsChart').getContext('2d');
        var topFoodsChart = new Chart(ctx, {
            type: 'bar', // Loại biểu đồ hình cột
            data: {
                labels: labels,
                datasets: [{
                    label: 'Total Quantity Sold',
                    data: dataPoints,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)', // Màu xanh dương nhạt
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false // Ẩn chú thích vì chỉ có 1 cột dữ liệu
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0 // Đảm bảo số lượng hiển thị là số nguyên
                        }
                    }
                }
            }
        });
    } else {
        // Hiển thị thông báo nếu chưa có ai mua hàng
        document.getElementById('topFoodsChart').outerHTML = "<p class='text-muted text-center mt-5'>Not enough data to display chart.</p>";
    }
</script>