<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>error.jsp</title>
</head>
<body>
	<h3>기본 에러 화면입니다.</h3>
	message : ${exception.message}
</body>
</html>