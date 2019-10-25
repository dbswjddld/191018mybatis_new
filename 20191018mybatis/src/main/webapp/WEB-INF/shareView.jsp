<%@page import="com.yedam.tourplan.plan.service.PlanVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<% 
	PlanVO vo = (PlanVO) request.getAttribute("vo");
	String catenum = vo.getCategorynum();
	String isopen = vo.getIsopen();
	String vo_day = vo.getDay();
%>
<!DOCTYPE html> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>투어플랜(TourPlan)-일정만들기 상세</title>
<script type="text/javascript" src="<c:url value='/'/>resources/js/redips-drag-min.js?v=<%=System.currentTimeMillis()%>"></script>
<script type="text/javascript" src="<c:url value='/'/>resources/js/script.js?v=<%=System.currentTimeMillis()%>"></script>
<script src='<c:url value='/'/>resources/js/jquery.form.min.js'></script>
<script>
var plannum = <%=vo.getPlannum()%>; 
var nowNum = 14;
	$(function(){
		document.getElementById("defaultOpen").click();
		
		$.ajax({
			url : "<%=request.getContextPath()%>/placeAjax/selectAll.do",
			dataType : "json",
			success : function(data) {
				for (i = 0; i < data.length; i++) {
					$("#tbody").append("<tr><td><a href='../place/select.do?num="+data[i].placenum+"' target='_blank'><img width='100px;' src='../resources/images/"+(data[i].imagename == null ? "null.jpg" : data[i].imagename) +"'></a></td><td class='dark'><div name='loc_"+data[i].lat+"_"+data[i].lon+"' id='place_" + data[i].placenum + "_" + "' class='redips-drag redips-clone'>"+data[i].placename+"<br>"+data[i].city+", " +data[i].country+"<br><input class='stay' type='hidden' placeholder='몇 분' value='30' onchange='stayCheck(this);'></div></td></tr>");
					
					if(i > 14) {
						$("#tbody tr:eq("+i+")").hide();	
					}
				}
			}
		});
		
		$("#sel > option[value='<%=catenum%>']").attr("selected", "true");
		var isopen = "<%=isopen%>";
		if(isopen == "1") {
			$("#isopen_ck").prop("checked", "true");
		}
		
		var post_day = $("#day").val();
		for(i=1; i<=post_day; i++) {
			var day_div = "<div id='postDay" + i + "' style='border: 1px solid red;'><font size='5'><b>" + i + " Day</b></font>";
			var table_td = "<td class='redips-mark dark'>Day" + i + "</td>";
			$("#table2 tr:eq(0)").append(table_td);
			for(j=0; j<9; j++) {
				day_div += "<div id='post"+i+"a"+j+"'></div><button id='"+i+"b"+j+"' class='postbtn' style='display:none;'>포스트쓰기</button>";
				table_td = "<td id="+i+"a"+j+" day='"+i+"' tr='"+j+"'></td>"
				$("#table2 tr:eq("+(j+1)+")").append(table_td);
			}
			day_div += "</div>";
			$("#storyTab").append(day_div);
		}
		
		//이미 들어가있는 일정 불러오기
		var param = "plannum=" + plannum;
		$.ajax({
			url : "../placeAjax/selectAll.do",
			dataType : "json",
			success : function(data_place) {
			
			$.getJSON("../planTableAjax/selectPT", param, function(data,status){
				if(status =="success" ) {
					if( data.length > 0) {
						if(data[0].imagename != null) {
							var img = "<img id='topimg' src='<c:url value='/'/>resources/images/" + data[0].imagename + "' width='100px' style='cursor: pointer;' data-toggle='modal' data-target='#imageModal'>";
							$(img).appendTo($("#upload"));
							img = "<img id='topimg' src='<c:url value='/'/>resources/images/" + data[0].imagename + "' width='100%'>";
							$(img).appendTo($("#imageBody"));
						}
						for(i=0; i<data.length; i++) {
							for(j=0; j<data_place.length; j++) {
								if(data[i].placenum == data_place[j].placenum) {
									break;
								}
							}
							var div = "<div name='loc_"+data_place[j].lat+"_"+data_place[j].lon+"' id='place_" + data[i].placenum + "_" + data[i].plantablenum + "' class='redips-drag'>" + data_place[j].placename + "<br>" + data_place[j].city + ", " + data_place[j].country+ "<br><input class='stay' type='text' placeholder='몇 분' value='"+data[i].staytime+"' onchange='stayCheck(this);'></div>";
							 $(div).appendTo($("#" + data[i].day + "a" + data[i].tr));
							 
							$("#post"+ data[i].day + "a" + data[i].tr).append("<div style='border: solid 1px orange;'>" + data_place[j].placename + "<br>" + data_place[j].city + ", " + data_place[j].country +  "</div>");
							$("#post"+ data[i].day + "a" + data[i].tr + "+button").css("display", "block");
						}
						
						for(f=0; f<$("#table2 div").length; f++) {
							var day = $("#table2 div:eq("+f+")").parent().attr("day");
							var f_name = $("#table2 div:eq("+f+")").attr("name");
							var f_arr = new Array();
							f_arr = f_name.split("_");
							var lat = parseFloat(f_arr[1]);
							var lng = parseFloat(f_arr[2]);

							myMap(lat, lng, day);
						}
					}
				} else {
					alert(status);
				}
			});
		  }
		});
		
	});
	
	function openTab(evt, tabName) {
		var i, tabcontent, tablinks;
		tabcontent = document.getElementsByClassName("tabcontent");
		for (i = 0; i < tabcontent.length; i++) {
			tabcontent[i].style.display = "none";
		}
		tablinks = document.getElementsByClassName("tablinks");
		for (i = 0; i < tablinks.length; i++) {
			tablinks[i].className = tablinks[i].className.replace(" active", "");
		}
		document.getElementById(tabName).style.display = "block";
		evt.currentTarget.className += " active";
	}
	
	function searchRegionFunction() {
		var input, filter, table, tr, td, i;
		input = document.getElementById("searchInput-region");
		filter = input.value.toUpperCase();
		table = document.getElementById("table1");
		tr = table.getElementsByTagName("tr");
		for (i = 0; i < tr.length; i++) {
			td = tr[i].getElementsByTagName("td")[0];
			if (td) {
				if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
					tr[i].style.display = "";
				} else {
					tr[i].style.display = "none";
				}
			}       
		}
	}
	
	function getDate() {
		var depDate = $("#departuredate").val().split('-');
		var arrDate = $("#arrivaldate").val().split('-');
		var depDateArr = new Date(depDate[0], depDate[1], depDate[2]); 
		var arrDateArr = new Date(arrDate[0], arrDate[1], arrDate[2]); 
		var cal_day = 0;
		var diff = arrDateArr - depDateArr;
 		var currDay = 24 * 60 * 60 * 1000;// 시 * 분 * 초 * 밀리세컨
 		cal_day = parseInt(diff/currDay)+1;
 		$("#day").val(cal_day);
	}
	
	function moreView() {
		var num = nowNum;
		for(i=nowNum+1; i<nowNum+15; i++) {
			$("#tbody tr:eq("+num+")").hide();
			num--;
			$("#tbody tr:eq("+i+")").show();
		}
		nowNum += 15;
	}
	
	function preView() {
		var num = nowNum-15;
		for(i=nowNum; i>nowNum-15; i--) {
			$("#tbody tr:eq("+i+")").hide();
			$("#tbody tr:eq("+num+")").show();
			num--;
		}
		nowNum -= 15;
	}
</script>
<style>
* {
    box-sizing: border-box;
}
body {
    margin: 0;
}
/* Style the header */
.header {
    background-color: #f1f1f1;
    padding: 50px;
    /* text-align: center; */
    /* margin-left: 300px; */
}
/* Container for flexboxes */
.footer {
    display: -webkit-flex;
    display: flex;
}
/* Create three unequal columns that sits next to each other */
.column {
    padding: 10px;
    /* height: 200px; /* Should be removed. Only for demonstration */ */
}
/* Left column */
.column.divNav {
   -webkit-flex: 1;
   -ms-flex: 1;
   flex: 1;
}
/* Middle column */
.column.divMain {
    -webkit-flex: 2;
    -ms-flex: 4;
    flex: 4;
}
#planName {
	width: 80%;
	height: 50px;
	margin-bottom: 20px;
}
/*공개여부*/
#isopen {
	float: left;
	/* margin: 5px; */
}
.switch {
	position: relative;
	display: inline-block;
	width: 60px;
	height: 32px;
}
.switch input {
	display: none;
}
.slider {
	position: absolute;
	cursor: pointer;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: #ccc;
	-webkit-transition: .4s;
	transition: .4s;
}
.slider:before {
	position: absolute;
	content: "";
	height: 24px;
	width: 24px;
	left: 4px;
	bottom: 4px;
	background-color: white;
	-webkit-transition: .4s;
	transition: .4s;
}
input:checked+.slider {
	background-color: #2196F3;
}
input:focus+.slider {
	box-shadow: 0 0 1px #2196F3;
}
input:checked+.slider:before {
	-webkit-transform: translateX(26px);
	-ms-transform: translateX(26px);
	transform: translateX(26px);
}
/* Rounded sliders */
.slider.round {
	border-radius: 40px;
}
.slider.round:before {
	border-radius: 50%;
}
/*공개여부끝*/
.planCate {
	width: 120px;
}
.tab {
    overflow: hidden;
    border: 1px solid #ccc;
    background-color: #f1f1f1;
}
.tab button {
    background-color: inherit;
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    transition: 0.3s;
    font-size: 17px;
}
.tab button:hover {
    background-color: #ddd;
}
.tab button.active {
    background-color: #ff8f00;
	color: #fff;
	font-weight: bold;
}
.tabcontent {
    display: none;
    padding: 6px 12px;
    border: 1px solid #ccc;
    border-top: none;
}
.tablinks {
	width: 50%;
}
#map {
	width: 100%;
	height: 100%;
}
.redips-drag {	
	cursor: move;
	margin: auto;
	z-index: 10;
	color: #222;
	text-align: center;
	font-size: 10pt;
	opacity: 0.7;
	filter: alpha(opacity=70);
	width: 180px;	/* table1 td item size */
	height: 50px;
	line-height: 20px;
	border: 1px solid #555;
	border-radius: 3px;
	-moz-border-radius: 3px;
}
div#redips-drag table {
	/* background-color: #eee; */ /* table2 background-color */
	border-collapse: collapse;
}
div#redips-drag td {
	border-style: solid;
	border-width: 1px;
	border-color: white;	/* 모든 table td border-color */
	width: 200px;
	height: 60px;
	text-align: center;
	font-size: 10pt;
	padding: 2px;
}
div#redips-drag #table1 td {
	border-width: 0px 0px 1px 0px;
}
div#redips-drag #table1 div {
	margin-left: 5px;
	float: left;
}
.ar { background-color: #AAC8E2; }
.bi { background-color: #E7D783; }
.ch { background-color: #E99AE6; }
.dark{
	color: #444;
	background-color: #e0e0e0;
}
.button_container{
	padding-top: 10px;
	text-align: right;
}
/* "Save" button */
.button_container input{
	background-color: #6A93D4;
	color: white; 
	border-width: 1px;
	width: 40px;
	padding: 0px;
}
#searchTable td{
	width: 200px;
}
.searchInput {
  background-image: url('/css/searchicon.png');
  background-position: 10px 10px;
  background-repeat: no-repeat;
  width: 100%;
  font-size: 16px;
  padding: 12px 20px 12px 40px;
  border: 1px solid #ddd;
  margin-bottom: 12px;
}
#trashTD {
	width: 100%;
	height: 50px;
	margin-bottom: 10px;
	text-align: center;
	background-color: #DC4C46;
	color: #fff;
}
.stay {
	font-size: 11px;
	width: 50px;
	height: 15px;
}
.topTable {
	width: 80%;
}

.topTable td {
	padding: 2px;
	text-align: center;
	vertical-align: inherit;
}

.topTr {
	padding: 2px;
	background-color: #e0e0e0;
}
.btn-default {
  width: 100%;
  padding: 10px 12px;
  font-size: 15px;
  font-weight: normal;
  text-align: center;
  vertical-align: middle;
  cursor: pointer;
  border: 1px solid transparent;
  border-radius: 4px;
  color: #555;
  background-color: #fff;
  border-color: #ccc;
}
.btn-default:hover {
  color: #333;
  background-color: #e6e6e6;
  border-color: #adadad;
}
.cal_btn {
	cursor: pointer;
    background-color: #ddd;
    border: 1px solid #ddd;
    padding: .375rem .75rem;
    border-radius: .25rem;
}

.cal_btn:hover {
	background-color: #ccc;
	transition: background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;
}
</style>
</head>
<body>
	<div class="header">
		<input type="text" id="planName" name="planname" value="${vo.planname}" placeholder="제목과 간단한 소개"/>
		<div class="divContents">
				<table class="topTable" border="1">
					<tr class="topTr">
						<td>출발일</td><td>도착일</td><td>day</td><td>인원</td><td>여행테마</td><td>공개여부</td><td>이미지</td>
					</tr>
					<tr>
						<td><input type="date" id="departuredate" name="departuredate" value="<%=vo.getDeparturedate()%>"></td>
						<td><input type="date" id="arrivaldate" name="arrivaldate" value="<%=vo.getArrivaldate()%>" onchange="getDate();"></td>
						<td><input type="text" id="day" value="<%=vo.getDay()%>"><button type="button" onclick="dayCheck();">변경</button></td>
						<td><input type="text" id="people" name="people" value="<%=vo.getPeople()%>"></td>
						<td>
							<select id="sel" name="categorynum">
        						<option value="11">나홀로여행</option>
								<option value="12">친구와여행</option>
  				 				<option value="13">가족여행</option>
			     				<option value="14">단체여행</option>
			     				<option value="15">커플여행</option>
			     				<option value="16">기타</option>
			  				</select>
			  			</td>
						<td>
							<div>
								<label class="switch"> 
									<input id="isopen_ck" type="checkbox" name="is" value="1"><span class="slider round"></span>
								</label>
									<input type="hidden" id="isopen" name="isopen" value="0">
							</div>
						</td>
						<td>
							<!-- 이미지 업로드 -->
							<div id="upload"></div>
							<form id="frm_img" method="post" enctype="multipart/form-data">
      							<input type="file" name="uploadFile" style="border: 1px solid grey">
      							<button type="button" onclick="imageAdd();">업로드</button>
  							</form>
							<!-- 이미지 업로드 -->			
						</td>
					</tr>
				</table>
			</div>
		</div>
	<div id="redips-drag">
		<div class="footer">
			<div class="column divNav" style="background-color:#aaa;">
				<div id="left">
					<input type="text" class="searchInput" id="searchInput-region" onkeyup="searchRegionFunction()" placeholder="Search.." title="Type in a name">
					<!-- <input type="text" class="searchInput" id="searchInput-place" onkeyup="searchPlaceFunction()" placeholder="Search for place.." title="Type in a name"> -->
					<table id="trashTD">
						<tr><td class="redips-trash" title="Trash" id="trashTD"><h3><strong>Trash</strong></h3></td></tr>
					</table>
					<table id="table1" border="1">
						<colgroup id="colgroup">
							<col width="180px"/>
						</colgroup>
						<tbody id="tbody">
							
						</tbody>
					</table>
					<br>
					<button class="btn" onclick="preView();">이전</button>
					<button class="btn" onclick="moreView();">다음</button>
					<br>
					<button id="newPlaceBtn" class="btn-default">새장소등록</button>
				</div>
			</div>
			<div class="column divMain" style="background-color:#bbb;">
				<div class="tab">
					<button class="tablinks" onclick="openTab(event, 'storyTab')">스토리</button>
					<button class="tablinks" onclick="openTab(event, 'planTab')" id="defaultOpen">지도/일정표</button>
				</div>
				<div id="storyTab" class="tabcontent">
				</div>
				<div id="planTab" class="tabcontent">
					<div id="googleMap" style="width: 100%; height: 400px;"></div>
					<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC6-5na3Y2gJSt31kHSeSWZqp3VM1hvgJg&libraries=places&callback=initMap"></script>
					<div id="planList">
						<div id="right">
							<table id="table2" border="1">
								<tbody>
									<tr>
									</tr>
									<tr>
										</tr>
										<tr>
										</tr>
										<tr>
										</tr>
										<tr>
										</tr>
										<tr>
										</tr>
										<tr>
										</tr>
										<tr>
										</tr>
										<tr>
										</tr>
										<tr>
										</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div id="divBtns" style="padding: 10px 0 10px 0;">
				<table style="width:100%;">
					<tr>
						<td style="width: 50%; border:0px;">
						<span>
						<select id="travel_mode" style="height:30px; width:18%;">
					      <option value="DRIVING">자동차</option>
					      <option value="WALKING">도보</option>
					      <option value="TRANSIT">대중교통</option>
					    </select>
						<input type="text" id="cal_dis" placeholder="day" style="width: 8%;">
						<button type="submit" id="submit" class="cal_btn" style="width: 70%;">거리계산</button>
					</span>
					</td>	
					<td style="width: 50%; border:0px;">
						<button class="btn btn-primary" type="button" onclick="savePlan();" style="width: 100%; cursor: pointer;">저장하기</button></td>
					</tr>
				</table>
			</div>
			<div id="directions-panel"></div>
			</div>
		</div>
	</div>
	
<!-- Modal -->
  <div class="modal fade" id="imageModal" role="dialog">
    <div class="modal-dialog modal-lg">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">썸네일 이미지</h4>
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <div id="imageBody" class="modal-body">
        </div>
      </div>
    </div>
  </div>
<!-- Modal End -->
<script type="text/javascript">
var isSave = false;
var dayCheckNum = 0;
var copy_num = 0;
//WebSocket start -----------------------------------
	var xhttp = new XMLHttpRequest();
	
	//★★★포트바꿔야!
	var webSocket = new WebSocket(
			'ws://localhost:8090/tourplan/websocket/sharePlan.do');
	webSocket.onerror = function(event) {
		onError(event)
	};
	webSocket.onopen = function(event) {
		var param = "plannum=" + plannum;
	
		onOpen(event)
	};
	webSocket.onmessage = function(event) {
		var msg = JSON.parse(event.data);
		 
		switch (msg.type) {
		case "insert":
			if($("#"+ msg.tdid + " div").length == 0) {
				
				//복제
				var div = $("#place_" + msg.placenum + "_").get(0);
				var copy_div = REDIPS.drag.cloneObject(div, true);
				var loc = $(copy_div).attr("name");
				var loc_arr = new Array();
				loc_arr = loc.split("_");
				var temp1 = parseFloat(loc_arr[1]);
				var temp2 = parseFloat(loc_arr[2]);
				var day = $("#"+ msg.tdid).attr("day");
				myMap(temp1, temp2, day);
				
				//복제품 속성부여
				$(copy_div).attr("class", 'redips-drag');
				$(copy_div).attr("id", $(div).attr("id") + copy_num);
				copy_num += 1;
				
				//복제품 변수에 담기
				var idid = $(copy_div).attr("id");
				var parent = $("#"+ msg.tdid).get(0);
				copy_div.lastChild.setAttribute("type", "text");
				
				//복제품 부모에게 이동
				REDIPS.drag.moveObject({
				    id: idid,
				    target: parent
				});
				
			} else {
				var div = $("#"+ msg.tdid + " div");
				
				var loc = div.attr("name");
				var loc_arr = new Array();
				loc_arr = loc.split("_");
				var temp1 = parseFloat(loc_arr[1]);
				var temp2 = parseFloat(loc_arr[2]);
				var day = $("#"+ msg.tdid).attr("day");
				myMap(temp1, temp2, day);
				
				var arr = new Array();
				arr = div.attr("id").split("_");
				var id = arr[0] + "_" + arr[1] + "_" + copy_num;
				copy_num += 1;
				div.attr("id", id);
			}
			break;
			
		case "update":
			if($("#"+ msg.tdid + " div").length == 0) {
			
				var div = $("#" + msg.willmove + " div");
				$(div).appendTo($("#"+ msg.tdid));
				$("#" + msg.willmove).empty();
				
			} else {
				console.log($("#"+ msg.tdid + " div"));
				console.log("밑에 if실행");
			}
			break;
		case "delete":
			$("#" + msg.tdid).parent().empty();
			break;
		case "imageUp":
			$("#upload").empty();
			$("<img src='<c:url value='/'/>resources/images/"+msg.tdid+"' width='100px'>").appendTo($("#upload"));
			break;
		case "planSave":
			alert('일정을 저장하였습니다');
			break;
		case "dayCheck":
			if($("#day").val() != msg.tdid) {
				$("#day").val(msg.tdid);
				dayCheck();
				
				$("#departuredate").val(msg.copynum);
				$("#arrivaldate").val(msg.placenum);
			}
			break;
		case "stayCheck":
			var td_id = msg.tdid;
			var st_time = msg.copynum;
			$("#"+td_id+" input").val(st_time);
			break;
		}
		//onMessage(event)
	};
	function onMessage(event) {
		console.log("onMessage");
	}
	
	function onOpen(event) {
		console.log("연결 성공");
	}
	function onError(event) {
		alert("에러발생 관리자에게 문의하세요");
	}
	function send(v_type, v_tdid,v_copynum, v_placenum, v_child1, v_child2, v_willMove) {
		// 서버로 전송할 데이터를 담을 msg 객체 생성.
		var msg = {
			type : v_type,
			tdid : v_tdid,
			copynum : v_copynum,
			placenum : v_placenum,
			child1 : v_child1,
			child2 : v_child2,
			willmove : v_willMove
		};
		//  Send  the msg  object  as  a  JSON-formatted  string.
		webSocket.send(JSON.stringify(msg));
	}
// WebSocket End -----------------------------------
function imageAdd(){
	if($("#upload img").length == 0) {
		$("#frm_img").ajaxForm({
			dataType:"json",
			data : {plannum: plannum},
			url:'../planAjax/insertImage',
			success: function(result, textStatus){
				if(result.code == 'success') {
					alert("등록되었습니다.");
					var post = "<img src='<c:url value='/'/>resources/images/" + result.imageName + "' width='100px'>";
					send("imageUp", result.imageName, "", "", "", "", "");
					$(post).appendTo($("#upload"));
				}
			},
			error: function(){
				alert("파일업로드 중 오류가 발생하였습니다.");
				return;
			}
		}).submit();
	} else {
		$("#frm_img").ajaxForm({
			dataType:"json",
			data : {plannum: plannum,
					planname: "otherUp"},
			url:'../planAjax/insertImage',
			success: function(result, textStatus){
				if(result.code == 'success') {
					alert("등록되었습니다.");
					var post = "<img src='<c:url value='/'/>resources/images/" + result.imageName + "' width='100px'>";
					send("imageUp", result.imageName, "", "", "", "", "");
					$("#upload").empty();
					$(post).appendTo($("#upload"));
				}
			},
			error: function(){
				alert("파일업로드 중 오류가 발생하였습니다.");
				return;
			}
		}).submit();
	}
}
function savePlan() {
	if($("#isopen_ck:checked").val() == null) {} 
	else { $("#isopen").val("1"); }
	var param2 = "planname=" + $("#planname").val() + "&departuredate=" + $("#departuredate").val() + "&arrivaldate=" + $("#arrivaldate").val()
	+ "&people=" + $("#people").val() + "&categorynum=" + $("#sel").val() + "&isopen=" + $("#isopen").val() + "&state=0";
	
	param2 += "&plannum=" + plannum;
	$.ajax({
	    url         : '../planAjax/update'
		,type        : 'GET'
	   	,data        : param2
		,dataType    : 'text'
		,success     : function(data,status) {
	      	if (status =="success") {
	    	   	if(data.length > 0) {
	    		   	alert("수정 성공");
	    	   		alert("update한 plannum : " + data);
	    	   		plannum = data;
	    	   		saveTable();
	    	   		}
	 		   else {
	    			alert("저장에 실패했습니다"); }
   		   	} else { alert("에러발생 관리자에게 문의하세요") }
   		}
	  });
}//savePlan()
function saveTable() {
	var parameter = []; 
	var day = "<%=vo_day%>";
	var tds = new Array();
	var divs = new Array();
	
		for(i=1; i<=day; i++) {
			for(j=0; j<9; j++) {
				var p = {};
			
				if($("[day='"+i+"'][tr='"+j+"'] div").length == 0) { }
				else {
				
				var div_id = $("[day='"+i+"'][tr='"+j+"'] div").attr("id");
				var divide_place = div_id.split("_")[1];
				var postnum = $("#"+i+"a"+j).attr("postnum");
				
				p.day = i;
				p.tr = j;
				p.placenum = divide_place
				p.plannum = plannum;
				p.fix = "0";
				p.sortnum = "5";
				p.staytime = "30";
				p.postnum = postnum;
				
				parameter.push(p);
				}
			}
		}
	
		$.ajax({
		    url         : '../planTableAjax/planUpdate'
		   ,type        : 'POST'
		   ,dataType    : 'json'
		   ,data		: JSON.stringify( parameter )
		   ,contentType	: 'application/json' 
		   ,mimeType: 'application/json'
		   ,success     : function(data,status) {
		       if (status =="success") {
		    	   if(data == true) {
			    	   	alert("저장 성공"); }
		    	   else {
			    		alert("저장에 실패했습니다"); }
	   		   } else { alert("에러발생 관리자에게 문의하세요") }
	   		}
		   	,error: function(result) {
	   		}
		});
		
	send("planSave");
}
function dayCheck() {
	console.log("dayCheck실행");
	var last_day = parseInt($("#table2 tr:eq(2) td").length);
	var form_day = parseInt($("#day").val());
	
	if($("#day").val() <= 0) {
		alert("0이하는 설정할 수 없습니다.");
		$("#day").val("1");
	} else if(form_day > last_day) {
		var sub = form_day - last_day;
		for(i=1; i<=sub; i++) {
			$("#table2 tr:eq(0)").append("<td class='redips-mark dark'>Day"+(last_day+i)+"</td>");
			for(j=0; j<9; j++) {
				var append_td = "<td id='" + (last_day+i) + "a" + j + "' day='" + (last_day+i) + "' tr='" + j + "'></td>"
				$("#table2 tr:eq(" + (j+1) + ")").append(append_td);
			}
			
			//포스트도 함께 추가
			var day_div = "<div id='postDay"+(last_day+i)+"' style='border: 1px solid red;'><font size='5'><b>" + (last_day+i) + " Day</b></font>"
			for(j=0; j<9; j++) {
				day_div += "<div id='post"+(last_day+i)+"a"+j+"'></div><button id='"+(last_day+i)+"b"+j+"' class='postbtn' style='display:none;'>포스트쓰기</button>"
			}
			day_div += "</div>";
			$("#storyTab").append(day_div);
		}
	} else if(form_day < last_day) {
		if(confirm("일정과 포스트도 함께 삭제됩니다 함께 동의하셔야 삭제됩니다")) {
			var sub = last_day - form_day;
			for(i=1; i<=sub; i++) {
				$("#table2 tr:eq(0) td:last").remove();
				for(j=0; j<9; j++) {
					$("#table2 tr:eq(" + (j+1) + ") td:last").remove();
				}
			
				//포스트도 함께 삭제
				$("#storyTab div[id^='postDay']:last").remove();
			}
		} else { $("#day").val(last_day); }
	} else if(form_day == last_day) {
	} else if($("#day").val() > 31) {
		alert('최대 31일까지 가능합니다');
	} else {
		alert('숫자만 입력가능합니다');
		$("#day").val("1");
	}
	var ddd = $("#day").val();
	send("dayCheck", ddd, $("#departuredate").val(), $("#arrivaldate").val(), "", "", "");
}
function stayCheck(obj) {
	var regTest = /[0-9]/g;
	var st_time = obj.value;
	var Tdid = $(obj).parent().parent().attr("id");
	
	if(!regTest.test(st_time)) {
		alert("분단위 숫자만 입력가능합니다");
		obj.value = 5;
		send("stayCheck", Tdid, 5, "", "", "", "");
	} else {
		send("stayCheck", Tdid, st_time, "", "", "", "");
	}
}


//구글맵스
var map;
var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var labelIndex = 0;
var MarkersArray = [];
var co= [];
var co2= [];
var co3= [];
var Coordinates = [];
var color;
var travelPathArray = [];
var t_mode;

function initMap() {
    var directionsService = new google.maps.DirectionsService;
    var directionsDisplay = new google.maps.DirectionsRenderer;
    map = new google.maps.Map(document.getElementById('googleMap'), {
      zoom: 6,
      center: {lat: 37.249289, lng: 127.076645}
    });
    directionsDisplay.setMap(map);
    
    document.getElementById('submit').addEventListener('click', function() {
 	   calculateAndDisplayRoute(directionsService, directionsDisplay);
    	});
    }

      function calculateAndDisplayRoute(directionsService, directionsDisplay) {
        var waypts = [];
        
        t_mode = $("#travel_mode").val();
        var calcul_day = $("#cal_dis").val();
        var count = $("[day='"+calcul_day+"'] div").length-1;
        
        var first_name = $("[day='"+calcul_day+"'] div:eq(0)").attr("name");
        var first_arr = new Array();
        first_arr = first_name.split("_");
        var last_name = $("[day='"+calcul_day+"'] div:eq("+count+")").attr("name");
        var last_arr = new Array();
        last_arr = last_name.split("_");
        
        var first_div_lat = parseFloat(first_arr[1]);
        var first_div_lng = parseFloat(first_arr[2]);
        var last_div_lat = parseFloat(last_arr[1]); 
        var last_div_lng = parseFloat(last_arr[2]); 
    	var wayArr_lat = new Array();
    	var wayArr_lng = new Array();
    	for(i=1; i<$("[day='"+calcul_day+"'] div").length-1; i++) {
    		var way_name = $("[day='"+calcul_day+"'] div:eq("+i+")").attr("name");
    		var way_arr = new Array();
    		way_arr = way_name.split("_");
    		
    		wayArr_lat[i] = parseFloat(way_arr[1]);
    		wayArr_lng[i] = parseFloat(way_arr[2]);
    		
    		waypts.push({
                location: {lat:wayArr_lat[i],lng:wayArr_lng[i]},
                stopover: true
              });
    	}
    	
        directionsService.route({
          origin: {lat:first_div_lat,lng:first_div_lng},
          destination: {lat:last_div_lat,lng:last_div_lng},
          waypoints: waypts,
          optimizeWaypoints: true,
          travelMode: t_mode
        }, function(response, status) {
          if (status === 'OK') {
            directionsDisplay.setDirections(response);
            //console.log(response);
            var route = response.routes[0];
            var summaryPanel = document.getElementById('directions-panel');
            summaryPanel.innerHTML = '';
            for (var i = 0; i < route.legs.length; i++) {
              var routeSegment = i + 1;
              summaryPanel.innerHTML += '<b>최적경로: ' + routeSegment +
                  '</b><br>';
            	if(i == 0) {
            		summaryPanel.innerHTML += $("[lat='"+first_div_lat+"']").contents().first().text() + ' to ';
            		summaryPanel.innerHTML += $("[lat='"+wayArr_lat[1]+"']").contents().first().text() + ' ';
            		summaryPanel.innerHTML += route.legs[i].distance.text + ' ' + route.legs[i].duration.text + '<br>';
            	}
            	else if(i == route.legs.length-1) {
            		summaryPanel.innerHTML += $("[lat='"+wayArr_lat[count-1]+"']").contents().first().text() + ' to ';
            		summaryPanel.innerHTML += $("[lat='"+last_div_lat+"']").contents().first().text() + ' ';
            		summaryPanel.innerHTML += route.legs[i].distance.text + ' ' + route.legs[i].duration.text + '<br>';
            	}
            	else {
            		summaryPanel.innerHTML += $("[lat='"+wayArr_lat[i]+"']").contents().first().text() + ' to ';
            		summaryPanel.innerHTML += $("[lat='"+wayArr_lat[i+1]+"']").contents().first().text() + ' ';
            		summaryPanel.innerHTML += route.legs[i].distance.text + ' ' + route.legs[i].duration.text + '<br>';
            	}
            }
            
          } else {
            window.alert('에러발생 관리자에게 문의하세요 : ' + status);
          }
        });
      }
	
      function addMarker(location) {
    	  var marker = new google.maps.Marker({
    	     position: location,
    	     label: labels[labelIndex++ % labels.length],
    	     map: map
      	});
    	map.setCenter(location);
      }
      
      function myMap(lat, lon, day) {
    	  if(day=='1') { Coordinates = co; color = "#FF0000"; }
    	  else if(day == '2') { Coordinates = co2; color = "#33cc33"; }
    	  else if(day == '3') { Coordinates = co3; color = "#0000ff"; }
    	  else {}
			var mapLocation = new google.maps.LatLng(lat, lon); // 지도에서 가운데로 위치할 위도와 경도
			var markLocation = new google.maps.LatLng(lat, lon);
			var marker = new google.maps.Marker({
			    position: markLocation,
			});
			Coordinates.push(markLocation);
			MarkersArray.push(marker);
			flightPath();
			for(i = 0; i < MarkersArray.length; i++) {
				MarkersArray[i].setMap(map);
			}
			map.setCenter(markLocation);
		}
		function flightPath(){
			var flightPath = new google.maps.Polyline({
				path: Coordinates,
				strokeColor: color,
				strokeOpacity: 0.5,
				strokeWeight: 3
			});
			flightPath.setMap(map);
		}
</script>
</body>
</html>