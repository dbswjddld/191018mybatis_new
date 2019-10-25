package com.company.app.user.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

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
	
	// [1025] 부서별 인원수 조회 (일반 Controller ver.)
	@RequestMapping("getEmpCnt")
	@ResponseBody // : json String으로 변환
	public List<Map<String,Object>> getEmpCnt() {
		return userService.getEmpCnt();
	}
}
