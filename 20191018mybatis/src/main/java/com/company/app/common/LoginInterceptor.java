package com.company.app.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
 
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.company.app.user.UserVO;
 
// [1030 로그인 인터셉터]
public class LoginInterceptor extends HandlerInterceptorAdapter{
 
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        
        HttpSession session = request.getSession();
        UserVO loginVO = (UserVO) session.getAttribute("user");
 
        // 로그인 안되어있으면 로그인 페이지로
        if(loginVO == null){
            response.sendRedirect("login");
            		// redirect : /app/login까지 적어야 한다.
            return false;
        }
        
        return true;
    }
 
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
        super.postHandle(request, response, handler, modelAndView);
    }
 
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        super.afterCompletion(request, response, handler, ex);
    }
 
    
    
}
 