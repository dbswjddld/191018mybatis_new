package com.company.app.board.service.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.company.app.board.BoardVO;

@Repository
public class BoardDAOMybatis {
	@Autowired SqlSessionTemplate mybatis;
	
	// 등록
	public void insertBoard(BoardVO vo) {
		System.out.println("mybatis insertBoard Procedure() 실행");
		mybatis.insert("BoardDAO.insertBoardProc", vo);
	}
	
	// 단건조회
	public BoardVO getBoard(BoardVO vo) {
		return mybatis.selectOne("BoardDAO.getBoard", vo);
	}
	
	// 전체 조회
	public List<BoardVO> getBoardList(){
		System.out.println("mybatis getBoardlist() 실행");
		return mybatis.selectList("BoardDAO.getBoardlist");
	}
	
	public List<Map<String,Object>> getBoardMap(BoardVO vo) {
		// 메소드명은 boardMapper의 id와 동일
		return mybatis.selectList("BoardDAO.getBoardMap", vo);
	}
	
	// 선택 삭제
	public void deleteBoardList(BoardVO vo) {
		mybatis.delete("BoardDAO.deleteBoardList", vo);
	}
}
