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


<form action="/System/AddQuestion" method="POST">
<p>试卷标题：<input type="text" name="qtitle" value="" /></p>
<p>试卷子标题：<input type="text" name="qsubtitle" value="" /></p>
<p>题目类型：<select name="qtype">
<option value="1">单选</option>
<option value="2">多选</option>
<option value="3">判断</option>
<option value="4">填空</option>
<option value="5">解答</option>
<option value="6">作文</option>
</select></p>
<p>题目选项：<textarea rows="5" cols="20" name="qoption"></textarea></p>
<p>题目答案：<input type="text" name="qanswer" value="" /></p>
<p>显示状态：<select name="display">
<option value="1">显示</option>
<option value="0">隐藏</option>
</select></p>
<input type="submit" name="submit" value="保存" />
</form>


<script src="/static/js/holder.js"></script>

    <script src="/static/js/jquery.js"></script>
    <script src="/static/js/bootstrap.min.js"></script>
  </body>
</html>