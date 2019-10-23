package com.company.app.board.service;

import java.util.List;
import java.util.Map;

import com.company.app.board.BoardVO;

public interface BoardService {
	   // 게시글 등록
	   void insertBoard(BoardVO vo);
	   //삭제
	   void deleteBoard(BoardVO vo);
	   //수정
	   void updateBoard(BoardVO vo);
	   //상세조회
	   BoardVO getBoard(BoardVO vo);
	   //목록조회
	   List<BoardVO> getBoardList(BoardVO vo);
	   // 
	   public List<Map<String,Object>> getBoardMap(BoardVO vo);
}
