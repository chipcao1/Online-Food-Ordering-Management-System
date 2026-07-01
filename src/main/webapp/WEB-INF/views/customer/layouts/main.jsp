<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <title>Feane | Food Ordering</title>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/feane/css/bootstrap.css" />
  <link href="${pageContext.request.contextPath}/feane/css/font-awesome.min.css" rel="stylesheet" />
  <link href="${pageContext.request.contextPath}/feane/css/style.css" rel="stylesheet" />
  <link href="${pageContext.request.contextPath}/feane/css/responsive.css" rel="stylesheet" />
  <style>
      .cart-section { padding: 50px 0; background-color: #f8f9fa; }
      .cart-table th { background-color: #222831; color: white; border: none; }
      .cart-table td { vertical-align: middle; background: white; }
      .checkout-box { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 15px rgba(0,0,0,0.1); }
      .success-box { background: white; padding: 50px; border-radius: 10px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); text-align: center; max-width: 600px; margin: 50px auto; }
      .check-icon { color: #28a745; font-size: 80px; margin-bottom: 20px; }
      .invoice-details { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-top: 30px; text-align: left; }
  </style>
</head>
<body class="sub_page">
  <jsp:include page="/WEB-INF/views/customer/layouts/header.jsp" />

  <jsp:include page="${body}" />

  <jsp:include page="/WEB-INF/views/customer/layouts/footer.jsp" />

  <script src="${pageContext.request.contextPath}/feane/js/jquery-3.4.1.min.js"></script>
  <script src="${pageContext.request.contextPath}/feane/js/bootstrap.js"></script>
</body>
</html>