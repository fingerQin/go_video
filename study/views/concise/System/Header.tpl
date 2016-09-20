<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=7" >
<title>PHP技术云课堂 - 中国自媒体技术课堂</title>
<meta content="PHP技术云课堂,是由一线PHP开发工程师创办的自媒体技术视频资讯平台。全方位360度讲解PHP技术及其他相关的前沿技术。" name="description">
<meta content="PHP技术云课堂,PHP云课堂,云课堂,PHP初学者,PHP初学,PHP,编程,教程,andriod,iOS" name="keywords">
<link href="/static/themes/default/css/css.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="/static/themes/default/css/default.css">
<script type="text/javascript" src="/static/themes/default/js/jquery.js"></script>
<script src="/static/themes/default/js/artDialog.basic.source.js"></script>
<script src="/static/themes/default/js/highlight.pack.js"></script>
{{str2html "<!--[if lte IE 6]>"}}
<script src="/js/ie6png.js" type="text/javascript"></script>
<script type="text/javascript">
	DD_belatedPNG.fix('div,a,li,span,img,p,i');
</script>
{{str2html " <![endif]-->"}}
<script type="text/javascript">
$(function(){
	$("#xzdh").mouseover(function(){
		$(this).attr("class","hg");
		$("#xzdh .tc").css("display","block")
	})	
	$("#xzdh .tc").mouseout(function(){
		$("#xzdh .tc").css("display","none");
		$("#xzdh").attr("class","zc");	
	})
	$("#xzdh").mouseout(function(){
		$("#xzdh .tc").css("display","none");
		$("#xzdh").attr("class","zc");	
	})
})
function soso(){
	var a = $("#sos_v").val();
	window.location.href="/Index/VideoList?keyword="+a;
}
$(function(){
	$("#sos_v").keydown(function(n){
		if(n.keyCode == 13){
			var a = $("#sos_v").val();
	 		window.location.href="/Index/VideoList?keyword="+a;
		}
	});	
})
$(function(){
	$("#topnav").mouseover(function(){
		$(this).attr("class","hg");
		$("#topnav .tc").css("display","block")
	})	
	$("#topnav .tc").mouseout(function(){
		$("#topnav .tc").css("display","none");
		$("#topnav").attr("class","zc");	
	})
	$("#topnav").mouseout(function(){
		$("#topnav .tc").css("display","none");
		$("#topnav").attr("class","zc");	
	})
})
$(function(){
	$("form[name='sos'] input[name='__hash__']").attr("name","");
})
</script>
</head>
<body>
<script type="text/javascript">
$(function(){
	$("#lyb_1").toggle(
	function(){
		$("#lyb_2").animate({ left:"0"}, "slow")
		$("#lyb_1").animate({ left:"+200px"}, "slow")
	},
	function(){
		$("#lyb_2").animate({ left:"-200px"}, "slow")
		$("#lyb_1").animate({ left:"0"}, "slow")	
	})
	$("#lyb_3").click(function(){
		var a = $("#dluid").val();
		var b = $("textarea[name='kc_ly']").val();
		if(a.length==0){
			tis("请先登陆")
			window.location.href="/Index/Login";	
			return false
		}
		if(b.match(/^\s*$/)){
			tis("请输入内容")
			return false
		}
		if(b.length == 0){
			tis("请输入内容")
			return false
		}	
		$.post("/Index/message",{ content:b,uid:a},function(n){
			tis(n)
			$("#lyb_2").animate({ left:"-200px"}, "slow")
			$("#lyb_1").animate({ left:"0"}, "slow")
		})
	})
	
	// 设置COOKIE。
	var username = $.cookie('username');
	var realname = $.cookie('realname');
	if ( username.length > 0 ) {
		$('#userinfoStatus').empty();
		var html = "<li><a href=\"/User/Index\">"+username+"</a></li><li><a href=\"/Index/Logout\">退出</a></li>"
		$('#userinfoStatus').html(html);
	} else {
		$('#userinfoStatus').empty();
		var html = "<li><a href=\"/Index/Login\">登陆</a></li><li><a href=\"/Index/Register\">注册</a></li>"
		$('#userinfoStatus').html(html);
	}
})
</script>
<div id="lyb">
	<div id="lyb_2" style=" float:left;">
		<form action="" method="post">
			<ul>
				<li>
					<textarea class="nr" name="kc_ly" ></textarea>
				</li>
				<li><a href="javascript:;" id="lyb_3" ><img src="/static/themes/default/images/dl.gif"/></a></li>
			</ul>
		<input type="hidden" name="__hash__" value="" /></form>
	</div>
	<div id="lyb_1" style=" float:left;"> </div>
</div>
<div id="head">
	<div class="top">
		<div class="top_1">
			<div class="logo"><a href="/"><img src="/static/themes/default/images/logo.png"></a></div>
			<div class="nav">
				<ul>
					<li><a href="/index.php">首页</a></li>
					<li><a href="/Index/VideoList">发现云课程</a></li>
				</ul>
			</div>
			<div class="land">
				<ul id="userinfoStatus">
					<li><a href="/Index/Login">登陆</a></li>
					<li><a href="/Index/Register">注册</a></li>
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