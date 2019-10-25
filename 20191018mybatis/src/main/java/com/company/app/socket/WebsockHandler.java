package com.company.app.socket;

public class WebsockHandler extends TextWebSocketHandler implements InitializingBean {
	private final Logger logger = LogManager.getLogger(getClass());
	private Set<WebSocketSession> sessionSet = new HashSet<WebSocketSession>();
	
	@Autowired
	PlanTableService planTableService;
	
	public WebsockHandler() {
		super();
		this.logger.info("create SocketHandler instance!");
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		super.afterConnectionClosed(session, status);
		sessionSet.remove(session);
		this.logger.info("remove session!");
	}

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		super.afterConnectionEstablished(session);
		sessionSet.add(session);
		this.logger.info("add session!");
	}

	@Override
	@ResponseBody
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		MsgVO msgVO = mapper.readValue((String) message.getPayload(), MsgVO.class);
		
		if(msgVO.getType().equals("insert")) {
			//planTableService.insert(msgVO);
			//String jsonString = mapper.writeValueAsString(msgVO);
			//sendMessage(session, jsonString);
			sendMessage(session, (String) message.getPayload());
		} else if (msgVO.getType().equals("update")) {
			//msgVO.setPlacenum("");
			//msgVO.setPlannum("");
			//planTableService.update(msgVO);
			sendMessage(session, (String) message.getPayload());
		} else if (msgVO.getType().equals("imageUp")) {
			sendMessage(session, (String) message.getPayload());
		} else if (msgVO.getType().equals("dayCheck")) {
			sendMessage(session, (String) message.getPayload());
		} else {
			//planTableService.delete(msgVO);
			sendMessage(session, (String) message.getPayload());
		}

		this.logger.info("receive message:" + message.toString());
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		this.logger.error("web socket error!", exception);
	}

	@Override
	public boolean supportsPartialMessages() {
		this.logger.info("call method!");
		return super.supportsPartialMessages();
	}

	public void sendMessage(WebSocketSession cur_session, String message) {
		System.out.println(message);
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
				/*while (true) {
					try {
						sendMessage("send message index " + i++);
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
						break;
					}
				}*/
			}
		};
		//thread.start();
	}
}