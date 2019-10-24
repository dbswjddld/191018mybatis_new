<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	번호 : ${board.seq}<br>
	제목 : ${board.title} <br>
	작성자 : ${board.writer} <br>
	내용 : ${board.content} <br>
	파일명 : ${board.uploadFilename} <br>
	작성일자 : ${board.regDate}<br>
	파일 : <a href = "./download/${board.uploadFilename}">${board.uploadFilename}</a><br>
	<img src = "./resources/image/${board.uploadFilename}">
</body>
</html>