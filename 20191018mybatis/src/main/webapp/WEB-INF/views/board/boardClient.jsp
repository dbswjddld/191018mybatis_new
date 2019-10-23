<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>ajax board</title>
	<script src = "https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script>
	$(function(){
		// 목록 조회 ajax 요청
		getboard();
		insertBoard();
	});
	
	function getboard(){
		$.ajax("getBoardList.json", {dataType:"json"})
		 .done(function(datas){
			 for(i = 0; i < datas.length; i++)
			 $("<div>").html(datas[i].title)
			 		   .appendTo($("#boardList"));
		 }) // 성공한 경우 
	};
	
	function insertBoard(){
		$("#btnIns").on("click", function(){
			// ajax 등록 요청
			
			//var param = $("#frm").serialize(); // serialize() :자동으로 형변환해줌
			// ↓직접 형 변환
			param = [{title:"t1", writer:"w1", content:"c1"},
					 {title:"t2", writer:"w2", content:"c2"},
					 {title:"t3", writer:"w3", content:"c3"}]
			param2 = [{seq:1019,title:"1027 14:09",writer:"writer",content:"c1"}]
			
			$.ajax("ajaxInsertBoard.json",
					{data:JSON.stringify(param2),
					method:"post",
					dataType:"json",
					contentType : "application/json",})
					// data :넘겨줄 데이터 / dataType :받을 데이터 타입 / contentType :직접 형 변환해서 넘겨줄때
			 .done(function(data){
				 $("<div>").html(data.title)
		 				.prependTo($("#boardList"));
				  $("#frm").each(function(){
					    this.reset();
					});
			 })
		})
	}
	</script>
</head>
<body>
	<!-- 목록 조회, 등록을 ajax로 처리하기 -->
	<form id = "frm" action = "insertBoard">
		제목 <input name = "title">
		작성자 <input name = "writer">
		내용 <input name = "content">
		<input type = "button" id="btnIns" value = "등록">
	</form>
	<div id = "boardList">
	
	</div>
</body>
</html>