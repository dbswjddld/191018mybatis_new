package com.company.app.board.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.company.app.board.BoardSearchVO;
import com.company.app.board.BoardVO;
import com.company.app.board.service.BoardService;

@Controller
public class BoardController {

	@Autowired BoardService boardService;
	// ajax테스트 페이지 호출
	@RequestMapping("/boardClient")
	public String boardClient() {
		return "board/boardClient";
	}
	
	// 단건조회
	@RequestMapping("/getBoard")
	public String getBoard(BoardVO vo, Model model) {
		model.addAttribute("board", boardService.getBoard(vo));
		return "board/getBoard"; // 넘겨줄 jsp페이지 src/main/webapp/WEB-INF/views/board/getBoard.jsp
	}
	
	// 전체조회
	@RequestMapping("/getBoardMap")
	public String getBoardMap(BoardVO vo, Model model) {
		model.addAttribute("boardList", boardService.getBoardMap(vo));
		return "board/getBoardList";
	}

	// 등록 페이지로 이동
	@RequestMapping("insertBoardForm")
	public String insertBoardForm(BoardVO vo) {
		return "board/insertBoard";
	}
	
	// 등록 처리
	@RequestMapping("insertBoard")
	public String insertBoard(BoardVO vo) {
		boardService.insertBoard(vo);
		System.out.println(vo.getSeq() + vo.getMsg());
		return "redirect:/getBoardMap";
	}
	
	// 다건 삭제
	@RequestMapping("/deleteBoardList")
	public String deleteBoardList(BoardVO vo) {
		boardService.deleteBoard(vo);
		return "redirect:/getBoardMap";
	}
}
