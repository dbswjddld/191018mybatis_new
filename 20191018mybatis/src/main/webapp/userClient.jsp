<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RESTful 웹서비스 클라이언트(JSON)</title>

<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
	crossorigin="anonymous">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
	integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"
	integrity="sha384-xrRywqdh3PHs8keKZN+8zzc5TX0GRTLCcmivcbNJWm2rs5C8PRhcEn3czEjhAO9o"
	crossorigin="anonymous"></script>
	
<script src="./resources/json.min.js"></script>

<script>
	$(function() {
		userList(); // 목록 조회
		userInsert(); // 등록버튼 이벤트
		userDelete(); // 삭제
		userUpdate(); // 수정버튼 클릭
		userSelect(); // 단건조회
	});
	

	//사용자 수정 요청
	function userUpdate() {
		//수정 버튼 클릭
		$('#btnUpdate').on('click',function(){
			var id = $('input:text[name="id"]').val();
			var name = $('input:text[name="name"]').val();
			var password = $('input:password[name="password"]').val();
			var role = $('[name="role"]:checked').val();
			
			$.ajax({ 
			    url: "users", 
			    type: 'PUT', 
			    dataType: 'json', 
			    data: JSON.stringify({ id: id, name:name,password: password, role: role }),
			    contentType: 'application/json',
			    success: function(data) { 
			        userList();
			    },
			    error:function(xhr, status, message) { 
			        alert(" status: "+status+" er:"+message);
			    }
			});
		});//수정 버튼 클릭
	}//userUpdate

	//사용자 조회 요청
	function userSelect() {
		//조회 버튼 클릭
		$('body').on('click','#btnSelect',function(){
			var userId = $(this).closest('tr').find('#hidden_userId').val();
			//특정 사용자 조회
			$.ajax({
				url:'users/'+userId,
				type:'GET',
				contentType:'application/json;charset=utf-8',
				dataType:'json',
				error:function(xhr,status,msg){
					alert("상태값 :" + status + " Http에러메시지 :"+msg);
				},
				success:userSelectResult
			});
		}); //조회 버튼 클릭
	}//userSelect
	
	//사용자 조회 응답
	function userSelectResult(user) {
		$('input:text[name="id"]').val(user.id);
		$('input:text[name="name"]').val(user.name);
		$('input:password[name="password"]').val(user.password);
		$('[name="role"]').val([user.role]); // radio, checkbox :배열로 값을 넣으면 선택된다
	}//userSelectResult
	

	//사용자 삭제 요청
	function userDelete() {
		//삭제 버튼 클릭
		$('body').on('click','#btnDelete',function(){
			var userId = $(this).closest('tr').find('#hidden_userId').val();
			var result = confirm(userId +" 사용자를 정말로 삭제하시겠습니까?");
			if(result) {
				$.ajax({
					url:'users/'+userId,  
					type:'DELETE',
					contentType:'application/json;charset=utf-8',
					dataType:'json',
					error:function(xhr,status,msg){
						console.log("상태값 :" + status + " Http에러메시지 :"+msg);
					}, success:function(xhr) {
						console.log(xhr.result);
						userList();
					}
				});      }//if
		}); //삭제 버튼 클릭
	}//userDelete
	
	// 사용자 목록 조회 요청
	function userList() {
		$.ajax({
			url : 'users',
			type : 'GET', // 요청방식
			dataType : 'json', // 결과데이터 타입
			error : function(xhr, status, msg) {
				alert("상태값 :" + status + " Http 에러메시지 : " + msg);
			},
			success : userListResult
		});
	}

	// 사용자 목록 조회 응답
	function userListResult(data) {
		$("tbody").empty();
		$.each(data, function(idx, item) {
			$('<tr>').append($('<td>').html(item.id)).append(
					$('<td>').html(item.name)).append(
					$('<td>').html(item.password)).append(
					$('<td>').html(item.role)).append(
					$('<td>').html('<button = id=\'btnSelect\'>조회</button>'))
					.append(
							$('<td>').html(
									'<button = id=\'btnDelete\'>삭제</button>'))
					.append($('<input type=\'hidden\' id=\'hidden_userId\'>').val(item.id))
					.val(item.id).appendTo('tbody');
		});
	}

	// 등록 버튼 클릭
	function userInsert() {
		$('#btnInsert').on('click', function() {
			/* var id = $('input:text[name="id"]').val();
			var name = $('input:text[name="name"]').val();
			var password = $('input:password[name="password"]').val();
			var role = $('[name="role"]:checked').val();
			*/
			
			var param = JSON.stringify($("#form1").serializeObject());
			// ↑한번에 json으로 변환
			
			$.ajax({
				url : "users",
				type : 'POST',
				dataType : 'json',
				/*
				data : JSON.stringify({
					id : id,
					name : name,
					password : password,
					role : role
				}),*/
				data : param,
				contentType : 'application/json',
				success : function(response) {
					if (response.result == true) {
						userList();
					}
				},
				error : function(xhr, status, message) {
					alert(" status : " + status + " er : " + message);
				}
			})
		});
	}
</script>
</head>
<body>

	<div class="container">
		<form id = "form1">
			<div class="form-group row">
				<label for="id" class="col-sm-2 col-form-label">ID</label>
				<div class="col-sm-10">
					<input type="text" name="id" class="form-control" id="id"
						placeholder="ID">
				</div>
			</div>
			<div class="form-group row">
				<label for="password" class="col-sm-2 col-form-label">Password</label>
				<div class="col-sm-10">
					<input type="password" name="password" class="form-control"
						id="password" placeholder="Password">
				</div>
			</div>
			<div class="form-group row">
				<label for="name" class="col-sm-2 col-form-label">Name</label>
				<div class="col-sm-10">
					<input type="text" name="name" class="form-control" id="name"
						placeholder="Name">
				</div>
			</div>
			<fieldset class="form-group">
				<div class="row">
					<legend class="col-form-label col-sm-2 pt-0">Radios</legend>
					<div class="col-sm-10">
						<div class="form-check">
							<input class="form-check-input" type="radio" name="role"
								id="gridRadios1" value="Admin" checked> <label
								class="form-check-label" for="gridRadios1"> 관리자 </label>
						</div>
						<div class="form-check">
							<input class="form-check-input" type="radio" name="role"
								id="gridRadios2" value="User"> <label
								class="form-check-label" for="gridRadios2"> 사용자 </label>
						</div>
					</div>
				</div>
			</fieldset>
			<div class="form-group row">
				<div class="col-sm-10">
					<button id="btnInsert" type="button" class="btn btn-primary">등록</button>
					<button id="btnUpdate" type="button" class="btn btn-primary">수정</button>
				</div>
			</div>
		</form>
	</div>


	<div class="container">
		<h2>사용자 목록</h2>
		<table class="table text-center">
			<thead>
				<tr>
					<th>아이디</th>
					<th>이름</th>
					<th>패스워드</th>
					<th>롤</th>
					<th>조회</th>
					<th>삭제</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</body>
</html>