{{template "default/Public/Header.tpl" .}}

<script type="text/javascript">
function yz(){
	$("#yzm").attr("src","/index/authcode?" + new Date().getTime())
}
$(function(){
	$("#verify").blur(function(){
		var a = $(this).val();
		$.post("/index/ajaxcheck",{ name:"authcode",authcode:a},function(b){
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


<div id="reg">
    <div id="body">
        <div class="reg">
            <div class="top">
                <h2>登录</h2>
                <p>立即登录，畅想大量精品专业课程。</p>
            </div>
            <div class="form">
                <form action="/index/login" name="chuangen" method="post">
                    <ul id="form_log">
                        <li><span>用户名：</span><input id="username" name="username" type="text" value=""/></li>
                        <li><span>密码：</span><input name="password" type="password" value=""/></li>
                        <li class="yzm"><span>验证码：</span>
                              <input name="authcode" type="text" maxlength="4" id="verify" value=""/>
                              <div class="yz_img" style="width:100px;height:40px;"><img id="yzm" src="/index/authcode"/></div>
                              <div class="ht"><a href="javascript:;" onClick="yz()">看不清换一张</a></div>
                        </li>
                    </ul>
						<input name="type" value="u" type="hidden" style="width:auto; margin-top:5px;"/>
                        <input type="hidden" value="0" name="isverify" id="isverify" />
                        <input style="border:none" class="su" type="submit" value=" 登 陆 " />
                        <a class="ms" href="/index/register">马上注册</a>
					    <a class="ms" href="/index/forgetpassword">忘记密码</a>
                </form>
            </div>

			<div id="open" style="margin: 10px 0 0;padding: 0 0 0 30px; float:left;" class="clear"> 
				<span id="qqLoginBtn"><a href="/index/qqlogin"><img src="/static/themes/default/images/qq_connect_logo.png" alt="QQ登录" border="0"></a></span> 
			</div>
			<div class="clear"></div>
			
        </div>
    </div>
    <div class="clear"></div>
</div>

{{template "default/Public/Footer.tpl"}}