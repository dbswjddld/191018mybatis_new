package com.company.app.user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.company.app.user.UserVO;
import com.company.app.user.service.UserService;

@Controller
public class UserController {
	@Autowired UserService userService;
	
	// 단건조회
	@RequestMapping("/getUser")
	public String getUser(UserVO vo, Model model) {
		model.addAttribute("user", userService.getUser(vo));
		return "user/getUser";
	}
}
