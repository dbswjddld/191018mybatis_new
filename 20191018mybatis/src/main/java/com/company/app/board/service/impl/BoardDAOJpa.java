package com.company.app.board.service.impl;

import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;

import com.company.app.board.BoardVO;

// 1112
@Repository
public class BoardDAOJpa {
	
	@PersistenceContext // 인젝션(주입) = autowired
	private EntityManager em;
	
	public void insertBoard(BoardVO vo) {
		System.out.println("jpa inesert board 실행");
		em.persist(vo); // 등록
	}
	
	public void deleteBoard(BoardVO vo) {
		System.out.println("jpa delete board 실행");
		em.remove(em.find(BoardVO.class, vo.getSeq()));
		// find :찾기
		// remove :삭제 (객체를 찾아서 삭제해야함)
	}
	
	public void updateBoard(BoardVO vo) {
		System.out.println("jpa update board 실행");
		em.merge(vo); // 삭제
	}
	
	public BoardVO getBoard(BoardVO vo) {
		return null;
	}
	
	public List<BoardVO> getBoardList(BoardVO vo) {
		System.out.println("jpa get board list 실행");
		return em.createQuery("FROM BoardVO b ORDER BY b.seq desc").getResultList();
		// BoardVO 클래스명
		// getResultList :결과 출력
	}
	
	public List<Map<String, Object>> getBoardMap(BoardVO vo) {
		return null;
	}
}
