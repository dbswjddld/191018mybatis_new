package com.company.app.board.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.company.app.board.BoardVO;

@Repository
public class BoardDAOSpring {
	@Autowired
	JdbcTemplate jdbcTemplate;
	
    // SQL 명령어들
    private final String BOARD_INSERT = "insert into board(seq, title, writer, content) values(?,?,?,?)";
    	// (select nvl(max(seq), 0)+1 from board)
    private final String BOARD_UPDATE = "update board set title=?, content=? where seq=?";
    private final String BOARD_DELETE = "delete board where seq=?";
    private final String BOARD_GET    = "select * from board where seq=?";
    private final String BOARD_LIST = "select * from board  order by seq desc";

    // 등록
    public void insertBoard(BoardVO vo) {
    	System.out.println("jdbcTemplate insertBoard() 처리");
    	jdbcTemplate.update(BOARD_INSERT, vo.getSeq(), vo.getTitle(), vo.getWriter(), vo.getContent());
    }
    
    // 업데이트
    public void updateBoard(BoardVO vo) {
    	System.out.println("jdbcTemplate updateBoard() 처리");
    	jdbcTemplate.update(BOARD_UPDATE, vo.getTitle(), vo.getContent(), vo.getSeq());
    }
    
    // 삭제
    public void DeleteBoard(BoardVO vo) {
    	System.out.println("jdbcTemplate deleteBoard() 처리");
    	jdbcTemplate.update(BOARD_DELETE, vo.getSeq());
    }
}
