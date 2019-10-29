package com.company.app.board.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.company.app.board.BoardVO;
import com.company.app.board.service.BoardService;

@Controller
public class BoardController {
	Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired 
	BoardService boardService;
	// ajax테스트 페이지 호출
	@RequestMapping("/boardClient")
	public String boardClient() {
		return "board/boardClient";
	}
	
	// 단건조회
	@RequestMapping("/getBoard")
	public String getBoard(BoardVO vo, Model model, @RequestParam int seq) {
		vo.setSeq(seq);
		model.addAttribute("board", boardService.getBoard(vo));
		return "board/getBoard"; // 넘겨줄 jsp페이지 src/main/webapp/WEB-INF/views/board/getBoard.jsp
	}
	
	
	// 단건조회 - model and view
	/*
		@RequestMapping("/getBoard")
		public ModelAndView getBoard(HttpServletRequest request, BoardVO vo) {
			ModelAndView mv = new ModelAndView();
			vo.setSeq(Integer.parseInt(request.getParameter("seq")));
			//mv.addObject("board", boardService.getBoard(vo)); // model
			mv.setViewName("board/getBoard"); // view
			return mv;
		}
		*/
	
	
	// 전체조회
	@RequestMapping("/getBoardMap")
	public ModelAndView getBoardMap (BoardVO vo, Model model
				, @RequestParam(required=false, value="title", defaultValue="board") String titleValue) {
		//System.out.println("============= title " + titleValue);
		logger.info("============= title " + titleValue);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("boardList", boardService.getBoardMap(vo));
		mv.setViewName("board/getBoardList");
		return mv;
		//model.addAttribute("boardList", boardService.getBoardMap(vo));
		//return "board/getBoardList";
	}

	// 등록 페이지로 이동
	@RequestMapping("insertBoardForm")
	public String insertBoardForm(BoardVO vo) {
		return "board/insertBoard";
	}
	
	// 등록 처리
	@RequestMapping("insertBoard")
	public String insertBoard(BoardVO vo, 
							MultipartHttpServletRequest multipart,
							HttpServletRequest request,
							HttpSession session){
		// 1024 첨부파일 업로드하고 파일명 조회
		//MultipartFile multipartFile = vo.getUploadFile();
		MultipartFile multipartFile = multipart.getFile("uploadFile");
		// 파일이 있는지 확인
		if(multipartFile != null && multipartFile.getSize() > 0) { 
			// 파일명 읽기
			String fileName = multipartFile.getOriginalFilename();
			// 업로드 폴더로 파일 이동
			String path = request.getSession().getServletContext()
						.getRealPath("/resources/image");
						// 경로와 파일명 지정
			System.out.println("--------------" + path);
			File imageFile = new File(path, fileName);
	        try	{
	        	// 파일명 중복되면 rename
	        	
	        	
				vo.setUploadFilename(fileName);
	            multipartFile.transferTo(imageFile);
	            // 파일 생성
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
		}
		
		
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
	
	
	@RequestMapping("/download/{fileName:.+}")
    public void downloadPDFResource( HttpServletRequest request,
                                     HttpServletResponse response,
                                     @PathVariable("fileName") String fileName) {
        String dataDirectory = request.getSession().getServletContext().getRealPath("/resources/image/"); // 파일이 있는지 확인할 경로
        Path file = Paths.get(dataDirectory, fileName); // 경로, 파일 이름 정보
        if (Files.exists(file)) // 파일이 있으면
        {
            response.setContentType("application/octet-stream;charset=UTF-8"); // 파일의 타입
            response.addHeader("Content-Disposition", "attachment; filename="+fileName);
            try
            {
                Files.copy(file, response.getOutputStream()); // 파일 복사 (소스, 붙여넣기 할 목적지)
                response.getOutputStream().flush(); // flush() :클라이언트로 내려보냄
            }
            catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}
