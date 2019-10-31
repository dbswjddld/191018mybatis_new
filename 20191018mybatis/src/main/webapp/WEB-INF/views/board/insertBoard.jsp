<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	<!-- [1030] tags/form 적용-->
	<form:form commandName="board"
				action = "insertBoard"
				method="post" 
				enctype="multipart/form-data">
		<input name = "mode" value = "update">
		<form:input path="seq"/>
		제목 <form:input path = "title"/>
		작성자 <form:input path = "writer"/>
		내용 <form:input path = "content"/>
		<form:select path = "boardType">
			<form:options items = "${boardType}"/>
		</form:select>
		<input type = "file" name = "uploadFile"/>
		<form:button>등록</form:button>
	</form:form>
</body>
</html>