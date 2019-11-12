package com.company.app;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;

import com.company.app.board.BoardVO;

public class BoardServiceClient {
	public static void main(String[] args) {
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("JPAProject2");
		EntityManager em = emf.createEntityManager();
		// 트랜잭션 생성
		EntityTransaction tx = em.getTransaction();
		try {
			tx.begin();
			
			// 작업공간
			BoardVO vo = new BoardVO();
			vo.setTitle("jpa test");
			vo.setWriter("test");
			vo.setContent("jps 글 안뇽");
			
			// 등록
//			em.persist(vo); 
			
			// 조회
//			vo.setSeq(1);
//			System.out.println(em.find(BoardVO.class, vo.getSeq()));
			
			// 삭제
//			em.remove(em.find(BoardVO.class, vo.getSeq()));
			
			// 전체 조회
			TypedQuery<BoardVO> query
				= em.createQuery("FROM BoardVO b WHERE b.writer = :writer ORDER BY b.seq desc", BoardVO.class);
			query.setParameter("writer", "관리자");
			query.setFirstResult(0); // ! 0부터 시작
			query.setMaxResults(6);
			System.out.println(query.getResultList());
			
			tx.commit();
		} catch (Exception e) {
			tx.rollback();
		} finally {
			em.close();
		}
		emf.close();
	}
}
