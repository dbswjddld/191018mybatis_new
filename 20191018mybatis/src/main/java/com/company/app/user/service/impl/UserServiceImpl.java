package com.company.app.user.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.app.user.UserVO;
import com.company.app.user.service.UserService;

@Service
public class UserServiceImpl implements UserService {
	
	@Autowired UserDAOMybatis userDAO;

	@Override
	public UserVO getUser(UserVO vo) {
		return userDAO.getUser(vo);
	}

}
