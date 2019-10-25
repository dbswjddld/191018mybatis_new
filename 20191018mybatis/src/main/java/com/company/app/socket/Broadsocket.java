package com.company.app.socket;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/broadcasting")
// ↑ 접속할 서버 주소 (jsp페이지의 socket 주소와 똑같아야한다)
// var webSocket = new WebSocket('ws://localhost/spring/broadcasting');
public class Broadsocket {
	private static Set<Session> clients = Collections.synchronizedSet(new HashSet<Session>());
	// List가 아닌 Set을 쓰는 이유? 중복 비허용
	
	// ↓ 메시지가 도착할경우 처리 방법
	@OnMessage
	public void onMessage(String message, Session session) throws IOException {
		System.out.println(message);
		synchronized (clients) {
			// Iterate over the connected sessions
			// and broadcast the received message
			for (Session client : clients) {
				if (!client.equals(session)) {
					client.getBasicRemote().sendText(message);
				}
			}
		}
	}

	// ↓ 접속시
	@OnOpen
	public void onOpen(Session session) {
		// Add session to the connected sessions set
		System.out.println(session);
		clients.add(session);
	}

	// ↓ 접속 종료시
	@OnClose
	public void onClose(Session session) {
		// Remove session from the connected sessions set
		clients.remove(session);
	}
}
