package uef.edu.vn.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class RoleInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        // Nếu chưa đăng nhập thì chặn đứng
        if (role == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String uri = request.getRequestURI();

        // 1. SHIPPER: Chỉ được phép ở quanh khu vực /admin/deliveries
        if (role.equals("DELIVERY_STAFF") && !uri.contains("/admin/deliveries")) {
            response.sendRedirect(request.getContextPath() + "/admin/deliveries");
            return false;
        }

        // 2. STAFF (Bếp/Phục vụ): Chỉ được phép ở quanh khu vực /admin/orders
        if (role.equals("STAFF") && !uri.contains("/admin/orders")) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return false;
        }

        // 3. MANAGER: Có toàn quyền vận hành TRỪ việc quản lý Tài khoản (Accounts)
        if (role.equals("MANAGER") && uri.contains("/admin/accounts")) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return false;
        }

        // 4. CUSTOMER: Táy máy gõ link /admin sẽ bị tống ra ngoài Menu khách hàng
        if (role.equals("CUSTOMER") && uri.contains("/admin")) {
            response.sendRedirect(request.getContextPath() + "/menu");
            return false; 
        }

        return true; 
    }
}