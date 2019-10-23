package com.company.app;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.company.app.board.BoardVO;
import com.company.app.board.service.BoardService;
import com.company.app.board.service.impl.BoardDAOSpring;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:/spring/*-context.xml")
public class BoardDAOClient {
	@Autowired BoardService boardService;
	
	@Test @Ignore
	public void insertBoardTest() {
		BoardVO vo = new BoardVO();
		vo.setTitle("spring jdbc test");
		vo.setWriter("작성자");
		vo.setContent("spring jdbc 내용");
		boardService.insertBoard(vo);
	}
	
	@Test @Ignore
	public void getBoardListTest() {
		System.out.println(boardService.getBoardList(null));
		
	}
	@Test
	public void getBoardTest() {
		System.out.println("boardService.getBoard()");
		BoardVO vo = new BoardVO();
		vo.setSeq(1);
		System.out.println(boardService.getBoard(vo));
	}
}
