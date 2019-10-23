<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix='c' %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>getBoardList</title>
</head>
<body>
	<form action = "getBoardMap">
		제목 <input name = "title">
		정렬
		<select name = "orderby">
			<option value = "">선택
			<option value = "writer">작성자
			<option value = "regDate">작성일자
			<option value = "seq">글 번호
		</select>
		<button>검색</button>
	</form>
	
	<form action = "deleteBoardList">
		<button>선택항목 삭제</button>
	
	<c:forEach items = "${boardList}" var = "board">
		<input name = "seqList" type = "checkbox" value = "${board.seq}"/>
		제목 : ${board.title}<br>
		날짜 : ${board.regDate}<br>
		번호 : ${board.seq}<br>
		내용 : ${board.content}<br>
		<hr>
	</c:forEach>
	</form>
</body>
</html>