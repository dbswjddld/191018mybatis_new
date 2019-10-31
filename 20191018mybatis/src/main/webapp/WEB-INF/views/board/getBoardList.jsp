<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>getBoardList</title>
</head>
<body>
	<h3>${sessionScope.user.name}</h3>
	<a href="logout">로그아웃</a>
	<form action = "getBoardMap">
		제목 <input name = "title">
		게시판 구분
		<select name = "boardType">
			<c:forEach items = "${boardType}" var = "t">
				<option value = "${t.value}">${t.key}</option>
			</c:forEach>
		</select>
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
		<hr>
	
	<c:forEach items = "${boardList}" var = "board">
		<input name = "seqList" type = "checkbox" value = "${board.seq}"/>
		제목 : <a href = "getBoard?seq=${board.seq}">${board.title}</a><br>
		날짜 : ${board.regDate}<br>
		번호 : ${board.seq}<br>
		내용 : ${board.content}<br>
		파일 : ${board.uploadFilename}
		<hr>
	</c:forEach>
	</form>
</body>
</html>