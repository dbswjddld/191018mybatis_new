<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	<form action = "insertBoard" method="post" enctype="multipart/form-data">
		제목 <input name = "title">
		작성자 <input name = "writer">
		내용 <input name = "content">
		<input type = "file" name = "uploadFile">
		<input type = "file" name = "uploadFile">
		<input type = "file" name = "uploadFile">
		<input type = "file" name = "uploadFile">
		<input type = "submit" value = "등록">
	</form>
</body>
</html>