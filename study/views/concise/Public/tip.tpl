<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>提示信息</title>
<style type="text/css">
body {
    color: #333333;
    font-family: Arial;
	height:100%;
	width:100%;background:url(/static/themes/default/images/index_08.jpg);
	margin:0;
}
*{
	font-size:12px;
	font-family:"微软雅黑"}
a {
    color: #266AAE;
    text-decoration: none;
}
.show_tips_wrap{ width:400px;margin:100px auto; background:url("/static/themes/default/images/bg_two.jpg") repeat scroll 0 0; border:1px solid #d9cdbf}
.show_tips{ padding:20px 30px 30px 110px;background:url("/static/themes/default/images/show_tips.png") no-repeat scroll  19px 62px transparent}
.show_tips h2{ font:bold 14px Arial;margin-bottom:5px;line-height:1.8;}
</style>
</head>
<body>
	<div class="wrap">
		<div class="show_tips_wrap">
			<div class="show_tips">
				<h2 style="font-size:14px">{{.Message}}</h2>
				{{if eq .Url ""}}
				<p>系统将在 <span style="color:blue;font-weight:bold">{{.Second}}</span> 秒后自动跳转,如果不想等待,直接点击 <a href="javascript:window.history.go(-1);">这里</a> 跳转</p>
				<script language="javascript">setTimeout(window.history.go(-1),{{.Second}}*1000);</script>
				{{else}}
				<p>系统将在 <span style="color:blue;font-weight:bold">{{.Second}}</span> 秒后自动跳转,如果不想等待,直接点击 <a href="{{.Url}}">这里</a> 跳转</p>
				<script language="javascript">setTimeout("window.location.href='{{.Url}}';",{{.Second}}*1000);</script>
				{{end}}
			</div>
		</div>
	</div>
</body>
</html>