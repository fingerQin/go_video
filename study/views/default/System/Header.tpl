<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=7" >
<title>{{.SiteTitle}}</title>
<meta content="{{.SiteDesc}}" name="description">
<meta content="{{.SiteKeys}}" name="keywords">
<link href="/static/themes/default/css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/static/themes/default/js/jquery.js"></script>
<link rel="stylesheet" href="/static/themes/default/js/kindeditor/plugins/code/prettify.css">
<script src="/static/themes/default/js/artDialog.basic.source.js"></script>
<script src="/static/themes/default/js/highlight.pack.js"></script>
{{str2html "<!--[if lte IE 6]>"}}
<script src="/js/ie6png.js" type="text/javascript"></script>
<script type="text/javascript">
	DD_belatedPNG.fix('div,a,li,span,img,p,i');
</script>
{{str2html " <![endif]-->"}}
<script type="text/javascript">

function soso(){
	var a = $("#sos_v").val();
	window.location.href="/index/videolist?keyword="+a;
}
$(function(){
	$("#sos_v").keydown(function(n){
		if(n.keyCode == 13){
			var a = $("#sos_v").val();
	 		window.location.href="/index/videolist?keyword="+a;
		}
	});	
})

</script>
</head>
<body>
<script type="text/javascript">
$(function(){
	// 设置COOKIE。
	var username = $.cookie('username');
	var realname = $.cookie('realname');
	if ( username.length > 0 ) {
		nickname = realname.length == 0 ? username : realname;
		$('#userinfoStatus').empty();
		var html = "<li><a href=\"/user/index\">"+nickname+"</a></li><li><a href=\"/index/logout\">退出</a></li>"
		$('#userinfoStatus').html(html);
	} else {
		$('#userinfoStatus').empty();
		var html = "<li><a href=\"/index/login\">登陆</a></li><li><a href=\"/index/register\">注册</a></li>"
		$('#userinfoStatus').html(html);
	}
})
</script>

<div id="head">
	<div class="top">
		<div class="top_1">
			<div class="logo"><a href="/"><img src="/static/themes/default/images/logo.png"></a></div>
			<div class="nav">
				<ul>
					<li><a href="/index.php">首页</a></li>
					<li><a href="/index/videolist">云视频</a></li>
					<li><a href="/index/news">文章</a></li>
				</ul>
			</div>
			<div class="land">
				<ul id="userinfoStatus">
					<li><a href="/index/login">登陆</a></li>
					<li><a href="/index/register">注册</a></li>
				</ul>
			</div>
						
			<div class="so" id="soso">
				<input class="te" id="sos_v" name="k" value="搜索课程" type="text">
				<button class="su" onclick="soso();"></button>
			</div>
			<div class="clear"></div>
		</div>
	</div>
	<div class="bg_1"></div>
</div>

<script charset="utf-8" src="/static/themes/default/js/kindeditor/kindeditor-min.js"></script>
<script charset="utf-8" src="/static/themes/default/js/kindeditor/lang/zh_CN.js"></script>