<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Login</title>
</head>
<body>
	<h3>로그인</h3>
	<form action="login" method="post">
		<input name = "id" value="${sessionScope.userVO.id}">
		<input name = "password" value="${userVO.password}">
		<button>로그인</button>
	</form>
</body>
</html>