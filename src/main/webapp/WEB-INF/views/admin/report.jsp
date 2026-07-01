<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid py-4">
    <div class="d-flex align-items-center gap-3 mb-5">
        <div class="bg-primary bg-opacity-10 p-3 rounded-3 text-primary d-flex align-items-center justify-content-center" style="width: 64px; height: 64px;">
            <i class="bi bi-shop fs-1"></i>
        </div>
        <div>
            <span class="text-uppercase text-muted fw-bold small tracking-wider">Online Food Ordering</span>
            <h1 class="fw-black text-dark mb-1 m-0">Restaurant Report</h1>
            <p class="text-muted mb-0">Real-time statistics and restaurant reporting system.</p>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-12 col-md-4">
            <div class="card border-0 shadow-sm border-start border-primary border-4 h-100" style="background-color: #ebf3fe;">
                <div class="card-body p-4 d-flex flex-column justify-content-between">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <span class="text-primary fw-bold text-uppercase small tracking-wider">Doanh Thu Hôm Nay</span>
                            <h2 class="fw-black text-dark my-2">
                                <fmt:formatNumber value="${dailyRevenue != null ? dailyRevenue : 0}" type="currency" currencySymbol="$" />
                            </h2>
                        </div>
                        <div class="bg-white p-2 rounded-3 shadow-sm text-primary">
                            <i class="bi bi-currency-dollar fs-4"></i>
                        </div>
                    </div>
                    <p class="text-muted small mb-0">Hóa đơn hoàn thành trong ngày</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-4">
            <div class="card border-0 shadow-sm border-start border-success border-4 h-100" style="background-color: #eaf8f0;">
                <div class="card-body p-4 d-flex flex-column justify-content-between">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <span class="text-success fw-bold text-uppercase small tracking-wider">Doanh Thu Tháng Này</span>
                            <h2 class="fw-black text-dark my-2">
                                <fmt:formatNumber value="${monthlyRevenue != null ? monthlyRevenue : 0}" type="currency" currencySymbol="$" />
                            </h2>
                        </div>
                        <div class="bg-white p-2 rounded-3 shadow-sm text-success">
                            <i class="bi bi-wallet2 fs-4"></i>
                        </div>
                    </div>
                    <p class="text-muted small mb-0">Tổng tích lũy tháng hiện tại</p>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-4">
            <div class="card border-0 shadow-sm border-start border-warning border-4 h-100" style="background-color: #fef7ea;">
                <div class="card-body p-4 d-flex flex-column justify-content-between">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <span class="text-warning fw-bold text-uppercase small tracking-wider">Doanh Thu Năm Nay</span>
                            <h2 class="fw-black text-dark my-2">
                                <fmt:formatNumber value="${yearlyRevenue != null ? yearlyRevenue : 0}" type="currency" currencySymbol="$" />
                            </h2>
                        </div>
                        <div class="bg-white p-2 rounded-3 shadow-sm text-warning">
                            <i class="bi bi-graph-up-arrow fs-4"></i>
                        </div>
                    </div>
                    <p class="text-muted small mb-0">Tổng doanh thu cả năm</p>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-12 col-lg-8">
            <div class="card border-0 shadow-sm p-4 h-100">
                <h4 class="fw-bold text-dark mb-4 d-flex align-items-center gap-2">
                    <i class="bi bi-box-seam text-info"></i> Tình Trạng Đơn Hàng
                </h4>
                <div class="row g-3">
                    <div class="col-4">
                        <div class="p-3 bg-light rounded-3 text-center border border-light">
                            <span class="text-muted small d-block mb-1">Tổng Đơn Hàng</span>
                            <span class="fs-2 fw-black text-dark">${totalOrders}</span>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="p-3 rounded-3 text-center border border-success border-opacity-25" style="background-color: #f4fbf7;">
                            <span class="text-muted small d-block mb-1">Đã Hoàn Thành</span>
                            <span class="fs-2 fw-black text-success">${completedOrders}</span>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="p-3 rounded-3 text-center border border-warning border-opacity-25" style="background-color: #fffdf5;">
                            <span class="text-muted small d-block mb-1">Đang Chờ Xử Lý</span>
                            <span class="fs-2 fw-black text-warning">${pendingOrders}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12 col-sm-6 col-lg-2">
            <div class="card border-0 shadow-sm p-4 h-100 text-center d-flex flex-column justify-content-center">
                <span class="text-muted small d-block mb-2">Tổng Khách Hàng</span>
                <i class="bi bi-people text-secondary fs-1 my-2"></i>
                <span class="fs-2 fw-black text-dark mt-1">${totalCustomers}</span>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-lg-2">
            <div class="card border-0 shadow-sm p-4 h-100 text-center d-flex flex-column justify-content-center">
                <span class="text-muted small d-block mb-2">Tổng Món Ăn</span>
                <i class="bi bi-flower1 text-danger fs-1 my-2"></i>
                <span class="fs-2 fw-black text-dark mt-1">${totalFoods}</span>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-12 col-xl-7">
            <div class="card border-0 shadow-sm p-4 h-100">
                <h4 class="fw-bold text-dark mb-4 d-flex align-items-center gap-2">
                    <i class="bi bi-bar-chart-line text-primary"></i> Top 5 Món Bán Chạy Nhất
                </h4>
                <div class="chart-container mb-3" style="position: relative; height:250px;">
                    <canvas id="topFoodsChart"></canvas>
                </div>
            </div>
        </div>

        <div class="col-12 col-xl-5">
            <div class="card border-0 shadow-sm p-4 h-100">
                <h4 class="fw-bold text-dark mb-4 d-flex align-items-center gap-2">
                    <i class="bi bi-trophy text-warning"></i> Top 5 Khách Hàng Thân Thiết
                </h4>
                <div class="table-responsive">
                    <table class="table align-middle table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="text-uppercase text-muted fs-7 fw-bold" style="width: 60px;">Hạng</th>
                                <th class="text-uppercase text-muted fs-7 fw-bold">Tên Khách Hàng</th>
                                <th class="text-uppercase text-muted fs-7 fw-bold text-end">Số Đơn Đặt</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${topCustomers}" var="cust" varStatus="status">
                            <tr>
                                <td>
                                    <span class="badge ${status.index == 0 ? 'bg-warning text-dark' : status.index == 1 ? 'bg-secondary' : status.index == 2 ? 'bg-danger bg-opacity-70' : 'bg-light text-dark'} rounded-circle p-2 d-inline-flex align-items-center justify-content-center" style="width: 24px; height: 24px;">
                                        ${status.index + 1}
                                    </span>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="avatar-sm bg-light rounded-circle d-flex align-items-center justify-content-center text-muted fw-bold" style="width: 32px; height: 32px; font-size: 12px;">
                                            ${fn:toUpperCase(fn:substring(cust[0], 0, 2))}
                                        </div>
                                        <span class="fw-semibold text-dark">${cust[0]}</span>
                                    </div>
                                </td>
                                <td class="text-end fw-bold text-dark">${cust[1]}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty topCustomers}">
                            <tr>
                                <td colspan="3" class="text-center py-4 text-muted">Chưa có dữ liệu thống kê khách hàng.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty lowStockFoods}">
        <div class="alert alert-warning border-0 shadow-sm p-4 d-flex align-items-start gap-3 mb-0" role="alert">
            <i class="bi bi-exclamation-triangle-fill fs-3 text-warning mt-1 flex-shrink-0"></i>
            <div class="w-100">
                <h5 class="alert-heading fw-bold text-dark mb-1">
                    ⚠️ Cảnh báo tồn kho — cần nhập thêm hàng
                </h5>
                <p class="mb-2 text-dark opacity-75">Các món dưới đây có tồn kho &lt; 10. Vui lòng cập nhật sớm:</p>
                <div class="d-flex flex-wrap gap-2">
                    <c:forEach items="${lowStockFoods}" var="food">
                        <c:choose>
                            <c:when test="${food[1] == 0}">
                                <span class="badge bg-danger text-white p-2 rounded-2 fw-medium">
                                    <i class="bi bi-x-circle me-1"></i>${food[0]}
                                    <span class="ms-1 fw-bold">HẾT HÀNG</span>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-white text-dark border border-warning p-2 rounded-2 fw-medium">
                                    <i class="bi bi-exclamation-circle text-warning me-1"></i>${food[0]}
                                    <span class="text-danger fw-bold ms-1">(còn ${food[1]})</span>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <div class="mt-2">
                    <a href="${pageContext.request.contextPath}/admin/food-items" class="btn btn-sm btn-warning rounded-pill px-3">
                        <i class="bi bi-pencil-square me-1"></i>Cập nhật Food Items
                    </a>
                </div>
            </div>
        </div>
    </c:if>
    <c:if test="${empty lowStockFoods}">
        <div class="alert alert-success border-0 shadow-sm p-3 d-flex align-items-center gap-2 mb-0" role="alert">
            <i class="bi bi-check-circle-fill text-success"></i>
            <span class="text-dark">Tất cả món ăn đang có tồn kho ổn định (≥ 10).</span>
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var ctx = document.getElementById('topFoodsChart').getContext('2d');

        var labels = [];
        var data = [];

           <c:forEach items="${topFoods}" var="item">
labels.push("${item[0]}");
        data.push(${item[1]});
    </c:forEach>

        if (labels.length === 0) {
            labels = ["Chưa có dữ liệu"];
            data = [0];
        }

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                        label: 'Số lượng bán ra',
                        data: data,
                        backgroundColor: 'rgba(13, 110, 253, 0.8)',
                        borderColor: 'rgba(13, 110, 253, 1)',
                        borderWidth: 1,
                        borderRadius: 6,
                        barThickness: 35
                    }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#f0f0f0'
                        },
                        ticks: {
                            color: '#6c757d',
                            font: {
                                family: 'Inter, sans-serif'
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#6c757d',
                            font: {
                                family: 'Inter, sans-serif',
                                weight: '500'
                            }
                        }
                    }
                }
            }
        });
    });
</script>