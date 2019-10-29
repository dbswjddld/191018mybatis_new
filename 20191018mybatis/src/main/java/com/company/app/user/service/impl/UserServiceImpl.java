package com.company.app.user.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.app.user.UserVO;
import com.company.app.user.service.UserService;

@Service
public class UserServiceImpl implements UserService {
	
	@Autowired
	UserDAOMybatis userDAO;
	@Override
	public UserVO getUser(UserVO vo) {
		return userDAO.getUser(vo);
	}
	@Override
	public List<UserVO> getUserList(UserVO vo) {
		return userDAO.getUserList(vo);
	}
	@Override
	public List<Map> getUserListMap(UserVO vo) {
		return userDAO.getUserListMap(vo);
	}
	public int insertUser(UserVO dto) {		
		return userDAO.insertUser(dto);		
	}
	public int updateUser(UserVO dto) {
		return userDAO.updateUser(dto);
	}
	public int deleteUser(UserVO dto) {
		return userDAO.deleteUser(dto);
	}
	
	// [1025] 부서별 인원수 조회
	@Override
	public List<Map<String, Object>> getEmpCnt() {
		return userDAO.getEmpCnt();
	}
	
	// [1029] 로그인
	@Override
	public UserVO login(UserVO vo) {
		UserVO user = userDAO.getUser(vo);
		if(user != null) {
			if(user.getPassword().equals(vo.getPassword())) { // 비밀번호 비교
				return user;
			}
		}
		return null;
	}

}
