<!DOCTYPE html>
<html>
  <head>
    <title>自助教育系统</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
	<meta name="author" content="">
	
    <link rel="stylesheet" href="/static/css/bootstrap.css">
	
	<!--[if lt IE 9]>
        <script src="/static/js/html5shiv.min.js"></script>
        <script src="/static/js/respond.min.js"></script>
	 <![endif]-->
  </head>
  	<body>


<form action="/System/EditPaper" method="POST">
<p>试卷标题：<input type="text" name="ptitle" value="{{.Paper.Ptitle}}" /></p>
<p>试卷介绍：<textarea rows="5" cols="60" name="pintro">{{.Paper.Pintro}}</textarea></p>
<input type="hidden" name="pid" value="{{.Paper.Pid}}" />
<input type="submit" name="submit" value="确定" />
</form>


<script src="/static/js/holder.js"></script>

    <script src="/static/js/jquery.js"></script>
    <script src="/static/js/bootstrap.min.js"></script>
  </body>
</html>