{{template "default/Public/Header.tpl" .}}

<script type="text/javascript">

// 获取验证码。
function yz(){
	$("#yzm").attr("src", "/index/authcode?" + new Date().getTime())
}

$(function(){
	$("#verify").blur(function(){
		yz_4();
	});
	$("#password").blur(function(){
		yz_3();
	});
	$("#qrpsw").blur(function(){
		yz_2();
	});
	$("#email").blur(function(){
		yz_5();
	})
	$("#username").blur(function(){
		yz_1();
	})
	$("#sub").click(function(){
		yz_1();
		yz_2();
		yz_3();
		yz_4();
		yz_5();
		var a = $("#isverify").val();
		var b = $("#isusername").val();
		var c = $("#ispassword").val();
		var d = $("#isqrpsw").val();
		var e = $("#isemail").val();
		if(a=="1" && b=="1" && c=="1" && d=="1" && e=="1"){
			return true;	
		}else{
			return false;	
		}
	});
})

// 邮箱验证。
function yz_5() {
	var a = $("#email").val();
	if(a != ""){
		$.post("/index/ajaxcheck",{ name:"email",email:a},function(b){
			if(b == 1){
				$("#isemail").val("0");
				$("#email").attr("class","cw");
				$("#email").closest("li").find(".ts_r").html("邮箱不能为空");
			}else if(b == 2){
				$("#isemail").val("0")
				$("#email").attr("class","cw");
				$("#email").closest("li").find(".ts_r").html("<div class=\"ts\">邮箱格式不正确</div>");
			}else if(b == 3){
				$("#isemail").val("0")
				$("#email").attr("class","cw");
				$("#email").closest("li").find(".ts_r").html("<div class=\"ts\">邮箱长度似乎有些异常</div>");
			}else if(b == 4){
				$("#isemail").val("0")
				$("#email").attr("class","cw");
				$("#email").closest("li").find(".ts_r").html("<div class=\"ts\">邮箱已经存在</div>");
			}else if(b == 5){
				$("#isemail").val("1")
				$("#email").attr("class","xz");
				$("#email").closest("li").find(".ts_r").html("");
			}
		})
	}else{
		$("#isverify").val("0")
		$("#email").attr("class","cw");
		$("#email").closest("li").find(".ts_r").html("<div class=\"ts\">邮箱不能为空</div>");	
	}
}

// 验证码验证。
function yz_4(){
	var a = $("#verify").val();
	if(a != ""){
		$.post("/index/ajaxcheck",{ name:"authcode",authcode:a},function(b){
			if(b == 1){
				$("#isverify").val("1");
				$("#verify").attr("class","xz");
				$("#verify").closest("li").find(".ts_r").html("");
			}else{
				$("#isverify").val("0")
				$("#verify").attr("class","cw");
				$("#verify").closest("li").find(".ts_r").html("<div class=\"ts\">验证码不正确</div>");
			}
		})
	}else{
		$("#isverify").val("0")
		$("#verify").attr("class","cw");
		$("#verify").closest("li").find(".ts_r").html("<div class=\"ts\">验证码不能为空</div>");	
	}
}

// 密码验证。
function yz_3(){
	var a = $("#password").val();
	a = a.length;
	if(a < 6 && a != 0){
		$("#ispassword").val("0");
		$("#password").attr("class","cw");
		$("#password").closest("li").find(".ts_r").html("<div class=\"ts\">密码小于6位</div>");	
	}else if(a == 0){
		$("#ispassword").val("0");
		$("#password").attr("class","cw");
		$("#password").closest("li").find(".ts_r").html("<div class=\"ts\">密码不能为空</div>");
	}else{
		$("#ispassword").val("1");
		$("#password").attr("class","xz");
		$("#password").closest("li").find(".ts_r").html("");
	}
}

// 确认密码验证。
function yz_2(){
	var a = $("#password").val();
	var b = $("#qrpsw").val();
	c = b.length;
	if(c != 0 && b != ""){
		if(a != b){
			$("#isqrpsw").val("0")
			$("#qrpsw").attr("class","cw");
			$("#qrpsw").closest("li").find(".ts_r").html("<div class=\"ts\">密码不一致</div>");	
		}else{
			$("#isqrpsw").val("1")
			$("#qrpsw").attr("class","xz");	
			$("#qrpsw").closest("li").find(".ts_r").html("");	
		}
	}else{
		$("#isqrpsw").val("0")
		$("#qrpsw").attr("class","cw");
		$("#qrpsw").closest("li").find(".ts_r").html("<div class=\"ts\">确认密码不能为空</div>");	
	}
}

// 验证用户名。
function yz_1(){
	var a = $("#username").val();
	if(a != ""){	
		$.post("/index/ajaxcheck",{ name:"username",username:a},function(b){
			if(b == 1){
				$("#isusername").val("0")
				$("#username").attr("class","cw");
				$("#username").closest("li").find(".ts_r").html("<div class=\"ts\">用户名不能为空</div>");	
			}else if(b == 2){
				$("#isusername").val("0")
				$("#username").attr("class","cw");
				$("#username").closest("li").find(".ts_r").html("<div class=\"ts\">用户名只能是数字加字母</div>");	
			}else if(b == 3){
				$("#isusername").val("0")
				$("#username").attr("class","cw");
				$("#username").closest("li").find(".ts_r").html("<div class=\"ts\">用户名长度必须6到20个字符间</div>");	
			}else if(b == 4){
				$("#isusername").val("0")
				$("#username").attr("class","cw");
				$("#username").closest("li").find(".ts_r").html("<div class=\"ts\">用户已经存在</div>");	
			}else if(b == 5){
				$("#isusername").val("1")
				$("#username").attr("class","xz");
				$("#username").closest("li").find(".ts_r").html("");	
			}
		})
	}else{
		$("#isusername").val("0")
		$("#username").attr("class","cw");
		$("#username").closest("li").find(".ts_r").html("<div class=\"ts\">用户名不能为空</div>");
	}
}
</script>
<div id="reg">
    <div id="body">
        <div class="reg">
            <div class="top">
                <h2>注册</h2>
                <p>请花一分钟时间注册，专业全面的 WEB开发技术 任你学！</p>
            </div>
            <div class="form">
                <form action="/index/register" method="post">
                    <ul id="form">
                        <li><span>用户名：</span>
                            <input name="username" id="username" type="text"/>
                            <div class="ts_r"></div>
                        </li>
						<li><span>邮箱：</span>
                            <input name="email" id="email" type="text"/>
                            <div class="ts_r"></div>
                        </li>
                        <li><span>创建密码：</span>
                            <input name="password" id="password" type="password"/>
                            <div class="ts_r"></div>
                        </li>
                        <li><span>确认密码：</span>
                            <input name="repeatpwd" id="qrpsw" type="password"/>
                            <div class="ts_r"></div>
                        </li>
                        <li class="yzm"><span>验证码：</span>
                            <input name="authcode" maxlength="4" type="text" id="verify" />
                            <div class="yz_img" style="height:40px;width:100px;"><img id="yzm" alt="验证码" src="/index/authcode" /></div>
                            <div class="ht"><a href="javascript:;" onClick="yz()">看不清换一张</a></div>
                            <div class="ts_r"></div>
                        </li>
						<input type="hidden" value="0" name="isverify" id="isverify" />
                        <input type="hidden" value="0" name="isusername" id="isusername" />
                        <input type="hidden" value="0" name="ispassword" id="ispassword" />
                        <input type="hidden" value="0" name="isqrpsw" id="isqrpsw" />
                        <input type="hidden" value="0" name="isemail" id="isemail" />
                        <li>
                            <input style="border:none" class="su" name="sub" id="sub" type="submit" value=" 注 册 " />
                        </li>
                    </ul>
                </form>
            </div>
        </div>
    </div>
    <div class="clear"></div>
</div>

{{template "default/Public/Footer.tpl"}}