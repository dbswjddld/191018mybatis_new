package com.company.app.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.company.app.board.service.BoardService;

// [1031 스케쥴러]
@Component
public class Scheduler {
	
	@Autowired BoardService boardService;
	
	// 9:30분에 1분간격으로 실행
	@Scheduled(cron = "0 30-39 9 * * *")
	public void jobMethod3() {
		System.out.println(boardService.getBoardMap(null));
	}
	
	// cron 표현식
//	@Scheduled(cron = "0/10 22-30 9 * * *")
	// 초 분 시 일 월 요일 
	// "0/10 22-30 9 * * *" - 모든 요일, 매월, 매일, 9시 22~30분 10초마다 실행
	public void jobMethod1() {
		System.out.println("스케쥴 실행");
	}
	
	// fixedrate 표현식
//	@Scheduled(fixedRate=5000)
	public void jobMethod2() {
		System.out.println("5초 경과");
	}
}
