package com.company.app.socket;

import java.util.HashSet;
import java.util.Set;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.company.app.board.service.BoardService;
import com.fasterxml.jackson.databind.ObjectMapper;

public class SpringSocketHandler extends TextWebSocketHandler implements InitializingBean {
	Logger logger = LoggerFactory.getLogger(SpringSocketHandler.class);
	private Set<WebSocketSession> sessionSet = new HashSet<WebSocketSession>();

	@Resource
	private BoardService boardService;

	public SpringSocketHandler (){ 
		super();
		this.logger.info("create SocketHandler instance!");
	}

	@Override
	//onClose 연결끊기면
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		super.afterConnectionClosed(session, status);
		sessionSet.remove(session);
		this.logger.info("remove session!");
	}

	@Override
	//onOpen 연결되고나면
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		super.afterConnectionEstablished(session);
		sessionSet.add(session);
		this.logger.info("add session!"); 
} 
	@Override
	//onMessage 클라이언트로부터 메시지가 도착했을 때
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception { super.handleMessage(session, message);
	this.logger.info("receive message:"+message.toString()); //json string을 vo로 변환
		ObjectMapper mapper = new ObjectMapper();
		MsgVO msgvo = mapper.readValue((String) message.getPayload(), MsgVO.class);
		// (String) message.getPayload() : 받아온 메시지
		
		String msg = "";
		MsgVO result = new MsgVO();
		if(msgvo.getCmd().equals("msg")) {
			msg = (String) message.getPayload();
		} else if(msgvo.getCmd().equals("board")) {
			String board = mapper.writeValueAsString(boardService.getBoardList(null));
			// writeValueAsString :String타입으로 변환
			result.setCmd("board");
			result.setMsg(board);
			msg = mapper.writeValueAsString(result);
		}
		sendMessage(msg);
	}

	@Override
	// 전송 에러 발생
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		this.logger.error("web socket error!", exception);
	}

	@Override
	// WebSocketHandler가 부분 메시지를 처리할 때 호출
	public boolean supportsPartialMessages() {
		this.logger.info("call method!"); 
		return super.supportsPartialMessages();
	}

	public void sendMessage(String message) {
		for (WebSocketSession session : this.sessionSet) {
			if (session.isOpen()) {
				try {
					session.sendMessage(new TextMessage(message));
				} catch (Exception ignored) {
					this.logger.error("fail to send message!", ignored);
				}
			}
		}
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		Thread thread = new Thread() {
			int i = 0;

			@Override
			public void run() {
				while (true) {
					try {
						sendMessage("send message index " + i++);
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
						break;
					}
				}
			}
		};
		//thread.start();
	}
}
