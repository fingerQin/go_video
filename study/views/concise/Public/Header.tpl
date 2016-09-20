<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns:wb="http://open.weibo.com/wb">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>微博帮助-首页</title>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta name="msapplication-tooltip" content="" />
<meta name="msapplication-window" content="width=1024;height=768" />
<meta content="#2994ce" name="msapplication-navbutton-color" />

<link href="/static/themes/concise/css/frame.css" type="text/css" rel="stylesheet" />
<link href="/static/themes/concise/css/skin.css" type="text/css" rel="stylesheet" />
<link href="/static/themes/concise/css/help_homepage.css" type="text/css" rel="stylesheet" />

<link rel="stylesheet" href="/static/themes/concise/js/kindeditor/plugins/code/prettify.css">
<link rel="stylesheet" href="/static/themes/concise/css/style.css">
<script type="text/javascript" src="/static/themes/concise/js/jquery.js"></script>
<script src="/static/themes/concise/js/artDialog.basic.source.js"></script>
<script src="/static/themes/concise/js/jquery.cookie.min.js"></script>
<script src="/static/themes/concise/js/jquery.kinMaxShow-1.1.min.js"></script>

<script type="text/javascript">
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

function tis(n){
	art.dialog({
	content:'<img src="/static/themes/default/images/warning.png"/><span style=" line-height:48px;">'+n+'<span>',
	width:260,
	height:80,
	opacity:0.5,
	drag:true,
	lock:true,
	ok:function(){
		switch(n) {
		case "请先登录":
			window.location.href="/Index/Login";
			break;
		case "没有注册":
			window.location.href="/Index/Register";
			break;
		default:
			window.location.reload();
			break;
		}
	}
  })	
}

$(function(){
	// 设置COOKIE。
	var username = $.cookie('username');
	var realname = $.cookie('realname');
	if ( username ) {
		$('#userinfoStatus').empty();
		var html = "<li><a href=\"/User/Index\">"+username+"</a></li><li><a href=\"/Index/Logout\">退出</a></li>"
		$('#userinfoStatus').html(html);
	} else {
		$('#userinfoStatus').empty();
		var html = "<li><a href=\"/Index/Login\">登陆</a></li><li><a href=\"/Index/Register\">注册</a></li>"
		$('#userinfoStatus').html(html);
	}
})


// 评星。
$(function(){
	$("#a1").click(function(){ 
		$(this).attr("class","");
		$("#a2").attr("class","no");
		$("#a3").attr("class","no");
		$("#a4").attr("class","no");
		$("#a5").attr("class","no");
		$("#fs_1").html("1.0");
		$("#fs").val("1");
	})
	$("#a2").click(function(){ 
		$(this).attr("class","");
		$("#a1").attr("class","");
		$("#a3").attr("class","no");
		$("#a4").attr("class","no");
		$("#a5").attr("class","no");
		$("#fs_1").html("2.0");
		$("#fs").val("2");
	})
	$("#a3").click(function(){ 
		$(this).attr("class","");
		$("#a2").attr("class","");
		$("#a1").attr("class","");
		$("#a4").attr("class","no");
		$("#a5").attr("class","no");
		$("#fs_1").html("3.0");
		$("#fs").val("3");
	})
	$("#a4").click(function(){ 
		$(this).attr("class","");
		$("#a2").attr("class","");
		$("#a3").attr("class","");
		$("#a1").attr("class","");
		$("#a5").attr("class","no");
		$("#fs_1").html("4.0");
		$("#fs").val("4");
	})
	$("#a5").click(function(){ 
		$(this).attr("class","");
		$("#a2").attr("class","");
		$("#a3").attr("class","");
		$("#a4").attr("class","");
		$("#a1").attr("class","");
		$("#fs_1").html("5.0");
		$("#fs").val("5");
	})
})
</script>

</head>
<body class="B_homepage">



<div class="header_help clearfix">
	<div class="header_rp">
	<div class="header_main">
		<div class="clearfix">
			<h1 class="help_logo">
				<a href="/" title="微博帮助">微博帮助</a>
			</h1>
			<div class="help_search_bar" id="pl_help_notice">

				<div class="search_area" id="pl_help_search" >
					<input type="text" value="请输入搜索词，如密码、达人" class="search_con" node-type="help_searchI" maxlength =300 />
					<a href="javascript:void(0);" class="search_btn" title="搜索帮助" node-type="help_searchK">搜索帮助</a>
				</div>
			</div>
		</div>
		<div class="header_nav_bg">
			<ul class="head_nav">
				<li class="cur"><a href="/" title="帮助首页" class="nav_index" suda-uatrack="key=tblog_help&value=nav_index">帮助首页</a></li>
				<li><a href="/faq" title="问题分类" class="nav_cat" suda-uatrack="key=tblog_help&value=nav_cat">问题分类</a></li>
				<li><a href="/ask" title="互助专区" class="nav_help" suda-uatrack="key=tblog_help&value=nav_zhidao">互助专区</a></li>
				<li><a href="/self/query" title="我要提问" class="nav_ask" suda-uatrack="key=tblog_help&value=nav_ask">我要提问</a></li>
				<li><a href="/selfservice" title="自助服务" class="nav_service" suda-uatrack="key=tblog_help&value=nav_service">自助服务</a></li>
				<li><a href="/safecenter" title="安全中心" class="nav_secure" suda-uatrack="key=tblog_help&value=nav_secure">安全中心</a>				</li>
			</ul>

			<!-- 
			<div class="help_center" id="pl_help_usercenter" >
				<a class="hc_btn"  href="/uq"  suda-uatrack="key=tblog_help&value=hc_btn">个人中心</a> 
			</div>
			-->
		</div>
	</div>
	</div>
</div>
