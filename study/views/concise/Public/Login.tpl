{{template "concise/Public/Header.tpl"}}

<div class="H_main">
  <div class="H_main_bg clearfix">
    <div class="H_main_l">
		<img src="/static/themes/concise/images/lo.jpg" />
    </div>
    <div class="H_main_r">
    	
		<!--登录框-->
		<div class="login">
            <div class="form">
                <form action="/Index/Login" name="chuangen" method="post">
                    <ul id="form_log">
                        <li><span>用户名：</span>
                            <input id="username" name="username" type="text" value="">
                        </li>
                        <li><span>密码：</span>
                            <input name="password" type="password" value="">
                        </li>
                        <li class="yzm"><span>验证码：</span>
                            <input name="authcode" type="text" id="verify" value=""><img id="yzm" src="/Index/AuthCode" alt="验证码" /><a onclick="yz()" href="javascript:void(0);">换一张</a>
                        </li>
						<input name="type" value="u" type="hidden" style="width:auto; margin-top:5px;">
                        <input type="hidden" value="0" name="isverify" id="isverify">
                    </ul>
                    <input style="border:none" class="su" type="submit" value=" 登 陆 ">
                    <div><a class="ms" href="/Index/Register">马上注册</a></div>
                <input type="hidden" name="__hash__" value=""></form>
            </div>
        </div>
		<!--/登录框-->
       
    </div>
  	</div>
</div>

<script type="text/javascript">
function yz(){
	$("#yzm").attr("src","/Index/AuthCode?" + new Date().getTime())
}

$(function(){
	$("#verify").blur(function(){
		var a = $(this).val();
		$.post("/Index/AjaxCheck",{ name:"authcode",authcode:a},function(b){
			if(b == 1){
				$("#isverify").val(b);	
			}else{
				$("#isverify").val("0");
				$("#verify").attr("class","cw");
			}	
		},"json")
	})	
})
</script>


{{template "concise/Public/Footer.tpl"}}