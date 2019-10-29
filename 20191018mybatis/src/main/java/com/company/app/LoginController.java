package com.company.app;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.company.app.user.UserVO;
import com.company.app.user.service.UserService;

@Controller
public class LoginController {
	
	@Autowired UserService userService;
	
	// 1029 로그인 폼으로 이동
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public String loginForm() {
		return "user/login";
	}
	
	// 1029 로그인 처리
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String login(@ModelAttribute("user") UserVO vo
						, HttpSession session) {
		
		UserVO user = userService.login(vo);
		if(user == null) {
			return "user/login";
		} else {
			// 세션에 저장 목록 페이지 이동
			session.setAttribute("user", user);
			session.setAttribute("id", user.getId());
			return "redirect:getBoardMap";
		}
	}
	
	// 1029 로그아웃
	@RequestMapping("logout")
	public String logout(HttpSession session) {
		session.invalidate(); // 세션 무효화
		return "redirect:login";
	}
}
