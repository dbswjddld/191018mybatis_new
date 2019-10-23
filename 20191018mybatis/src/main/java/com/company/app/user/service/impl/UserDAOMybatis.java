package com.company.app.user.service.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.company.app.user.UserVO;

@Repository
public class UserDAOMybatis {
	@Autowired SqlSessionTemplate mybatis;

	// 단건조회
	UserVO getUser(UserVO vo) {
		return mybatis.selectOne("UserDAO.getUser",vo);
	}
}
