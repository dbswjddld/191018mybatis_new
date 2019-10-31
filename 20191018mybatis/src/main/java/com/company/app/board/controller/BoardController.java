package com.company.app.board.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.company.app.board.BoardVO;
import com.company.app.board.service.BoardService;

@Controller
//@SessionAttribute("board")
public class BoardController {
	Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired 
	BoardService boardService;
	
	// [1030] ModelAttribute :requestMapping보다 먼저 호출된다
	// 어제 login할때는 매게변수에 썼음
	@ModelAttribute("boardType")
	public Map<String, String> getBoardType(){
		// 게시판 구분
		Map<String, String> boardType = new HashMap<String, String>();
		boardType.put("일반", "t1");
		boardType.put("공지", "t2");
		boardType.put("첨부", "t3");
		return boardType;
	}
	
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
	
	// [1030] 수정폼
	// 등록인지 수정인지 어떻게 아냐? PK가 있냐 없냐에 따라 수정, 등록
	@RequestMapping("/updateBoardForm")
	public String updateBoardForm(BoardVO vo, Model model) {
		// 단건조회해서 모델에 담기
		model.addAttribute("board", boardService.getBoard(vo));
		return "board/insertBoard";
	}

	// 등록 페이지로 이동
	@RequestMapping("insertBoardForm")
	public String insertBoardForm(@ModelAttribute("board") BoardVO vo) {
		//String a = null;
		//a.toString();
		// ↑ null pointer 에러 확인
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
		
		// seq 이미 있으면 수정, 아니면 등록
		if(vo.getSeq() > 0) {
			boardService.updateBoard(vo);
		} else {
			boardService.insertBoard(vo);
		}
		
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
