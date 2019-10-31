<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Login</title>
</head>
<body>
	<h3><spring:message code="message.user.login.title"/></h3>
	<form action="login" method="post">
		<spring:message code="message.user.login.id"/><input name = "id" value="${sessionScope.userVO.id}">
		<spring:message code="message.user.login.password"/><input name = "password" value="${userVO.password}">
		<button><spring:message code="message.user.login.loginBtn"/></button>
	</form>
</body>
</html>