package com.company.app.user.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.company.app.user.UserVO;
import com.company.app.user.service.UserService;

// 10.23 RESTful
@RestController
public class UserRestController {
	@Autowired
	UserService userService;
	
	// 전체 리스트 조회 (get)
	@RequestMapping(value="/users", method=RequestMethod.GET)
	public List<UserVO> getUserList(Model model, UserVO vo) {
		return userService.getUserList(vo);
	}
	
	// 등록 (post)
	@RequestMapping(value="/users",
					method=RequestMethod.POST,
					consumes="application/json")
	public Map insertUser(@RequestBody UserVO vo, Model model) {
		userService.insertUser(vo);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", true);
		map.put("user", vo);
		return map;
		// map : {result:true, user:{id:tom, parrword:1234}}
	}
	// get요청 :전체 / post요청 :유저
	
	// 단건조회 (get)
	@RequestMapping(value="/users/{id}", method=RequestMethod.GET)
	public UserVO getUser(@PathVariable String id, UserVO vo, Model model) {
		vo.setId(id);
		return userService.getUser(vo);
	}
	
	// 삭제 (delete)
	@RequestMapping(value="/users/{id}", method=RequestMethod.DELETE)
	public Map deleteUser(@PathVariable String id, UserVO vo, Model model) {
		vo.setId(id);
		userService.deleteUser(vo);
		//Map result = new HashMap<String, Object>();
		//result.put("result", Boolean.TRUE);
		
		// 위 두 문장 대신 한 줄로 (singleton 이용)
		return Collections.singletonMap("result", true);
	}

	// 수정(put)
	@RequestMapping(value="/users", method=RequestMethod.PUT, consumes="application/json")
	public UserVO updateUser(@RequestBody UserVO vo, Model model) {
		userService.updateUser(vo);
		return vo;
	}
}
