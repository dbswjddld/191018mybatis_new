<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>[1025] 웹소켓 채팅</title>
</head>
<body>
	<fieldset>
		<textarea id="messageWindow" rows="10" cols="50" readonly="true"></textarea>
		<br />
			<input id="inputMessage" type="text" />
			<input type="submit" value="send" onclick="send()" />
			<button type="button" onclick="getBoard()">게시판</button>
	</fieldset>
</body>
<script type="text/javascript">
	var textarea = document.getElementById("messageWindow");
	var webSocket = new WebSocket('ws://localhost/app/BroadcastingServer.do');
	// 주소
	// 80 :포트번호
	var inputMessage = document.getElementById('inputMessage');
	webSocket.onerror = function(event) {
		onError(event)
	};
	webSocket.onopen = function(event) {
		onOpen(event)
	};
	webSocket.onmessage = function(event) {
		onMessage(event)
	};
	function onMessage(event) {
		var result = JSON.parse(event.data);
		if(result.cmd == "msg") {
			textarea.value += result.id + " : " + result.msg+ "\n";
		} else if(result.cmd == "board") {
			var list = JSON.parse(result.msg);
			for(i = 0; i < list.length; i++) 
				textarea.value += list[i].title + "\n";
		}
		chatAreaScroll();
	}
	function onOpen(event) {
		textarea.value += "연결 성공\n";
	}
	function onError(event) {
		console.log(event);
		alert(event.data);
	}
	function send() {
		// 넘겨줄 값을 json 형태로 만듦
		msg = {
			cmd : "msg",
			id : "sampleID",
			msg : inputMessage.value
		}

		textarea.value += "나 : " + inputMessage.value + "\n";

		//webSocket.send(inputMessage.value);
		webSocket.send(JSON.stringify(msg));
		inputMessage.value = "";
	}
	// board 버튼 클릭시, 
	function getBoard() {
		msg = {
			cmd : "board",
			id : "",
			msg : ""
		}
		webSocket.send(JSON.stringify(msg));
	}
	function chatAreaScroll() {
		//using jquery
		/*
		var textArea = $('#messageWindow');
		textArea.scrollTop(textArea[0].scrollHeight - textArea.height());
		textArea.scrollTop(textArea[0].scrollHeight);
		 */
		//using javascript
		var textarea = document.getElementById('messageWindow');
		textarea.scrollTop = textarea.scrollHeight;
	}
</script>
</html>