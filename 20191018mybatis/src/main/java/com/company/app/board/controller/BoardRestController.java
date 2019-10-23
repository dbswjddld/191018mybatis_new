package com.company.app.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.company.app.board.BoardVO;
import com.company.app.board.service.BoardService;

@RestController // RestController = Controller + ResponseBody
public class BoardRestController {
	@Autowired BoardService boardService;
	// ajax로 목록 조회(게시판)
	
	@RequestMapping("/getBoardList.json")
	@ResponseBody	// :json 반환
	public List<BoardVO> getBoardList() {
		return boardService.getBoardList(null);
	}
	
	@RequestMapping("/getBoard.json")
	public BoardVO getBoard(BoardVO vo) {
		boardService.getBoard(vo);
		return boardService.getBoard(vo);
		// 등록 후, 조회 결과를 넘김
	}
	
	/*
	 * @RequestMapping(value="/ajaxInsertBoard.json", method=RequestMethod.POST)//
	 * post방식으로 받을때만 된다. public BoardVO insertBoard(BoardVO vo) {
	 * boardService.insertBoard(vo); return boardService.getBoard(vo); }
	 */	
	
	@RequestMapping(value="/ajaxInsertBoard.json",
					method=RequestMethod.POST,
					produces = "application/json")
	@ResponseBody
	public List<BoardVO> insertBoard(@RequestBody List<BoardVO> vo) {
		System.out.println(vo);
		return vo;
	}

}
