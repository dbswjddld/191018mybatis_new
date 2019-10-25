<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Chart.jsp</title>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">

      // Load the Visualization API and the corechart package.
      google.charts.load('current', {'packages':['corechart']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.charts.setOnLoadCallback(drawChart);

      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', '부서');
        data.addColumn('number', '사원수');
        
        // ajax 요청해서 데이터 받아오기
        var rows = [];
        $.ajax("./getEmpCnt", {dataType:"json", async:false})
        										// 동기방식 - 함수가 끝나고 반환값을 받은 뒤, 다음 함수를 실행
         .done(function(result){
        	 for(i=0; i<result.length; i++) {
        		 rows.push( [result[i].departmentName, result[i].cnt] );
        	 }
         });

        // 데이터 입력
        data.addRows(rows);

        // Set chart options
        var options = {'title':'부서 별 인원수',
                       'width':800,
                       'height':300,
                       'legend':'top',
                       colors:['gold'],
                       bar: {groupWidth: '50%'},
                       vAxis: { gridlines: { count: 10 } }
        };

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
        									// 차트 종류						// 차트가 들어갈 공간
        chart.draw(data, options);

		// 차트 클릭시 이벤트 발생		
        google.visualization.events.addListener(chart,'select', selectHandler);
        function selectHandler() {
        	var r = chart.getSelection()[0].row;
        	var c = chart.getSelection()[0].column;
        	var dept = data.getFormattedValue(r,c);
        	alert(dept);
        }
      } // drawChart()
    </script>
</head>
<body>
	<!--Div that will hold the pie chart-->
    <div id="chart_div"></div>
</body>
</html>