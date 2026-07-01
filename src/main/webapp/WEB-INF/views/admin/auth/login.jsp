<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login | FoodOrder</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendors/bootstrap-icons/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body class="bg-light">
        <main class="container py-5" style="max-width: 460px;">
            <form class="panel" method="post" action="${pageContext.request.contextPath}/login">
                <h1 class="h4 mb-3"><i class="bi bi-shop"></i> FoodOrder Login</h1>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger"><c:out value="${error}"/></div>
                </c:if>
                <c:if test="${param.registered == 'true'}">
                    <div class="alert alert-success">Đăng ký thành công! Vui lòng đăng nhập.</div>
                </c:if>

                <label class="form-label">Username</label>
                <input class="form-control mb-3" name="username" required>
                <label class="form-label">Password</label>
                <input class="form-control mb-3" name="password" type="password" required>
                <button class="btn btn-primary w-100" type="submit">Login</button>
                <div class="text-center mt-3"><a href="${pageContext.request.contextPath}/register">Create customer account</a></div>
            </form>
        </main>
    </body>
</html>