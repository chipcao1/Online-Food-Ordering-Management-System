package uef.edu.vn.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import uef.edu.vn.interceptor.AuthorizationInterceptor;
import uef.edu.vn.interceptor.RoleInterceptor; // Thêm dòng này

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        
        // 1. Kiểm tra Đăng nhập (Chặn tất cả những người chưa có Session)
        registry.addInterceptor(new AuthorizationInterceptor())
                .addPathPatterns("/admin/**") // Giờ chỉ cần chặn /admin/** là đủ bao trọn gói
                .excludePathPatterns("/login", "/register", "/logout", "/assets/**", "/feane/**", "/css/**", "/js/**", "/images/**", "/", "/menu", "/cart/**");

        // 2. Kiểm tra Phân quyền (Kích hoạt Anh bảo vệ RoleInterceptor vừa tạo ở trên)
        // Nó sẽ chạy sau AuthorizationInterceptor để kiểm tra xem Role có hợp lệ với đường dẫn không
        registry.addInterceptor(new RoleInterceptor())
                .addPathPatterns("/admin/**");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/assets/**").addResourceLocations("/assets/");
        registry.addResourceHandler("/feane/**").addResourceLocations("/feane/");
        // Serve uploaded food images
        registry.addResourceHandler("/uploads/**").addResourceLocations("file:" + System.getProperty("catalina.home", System.getProperty("java.io.tmpdir")) + "/webapps/ROOT/uploads/");
    }
}