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
<div id="login">
    <div id="body">
        <div class="login">
            <div class="img"><img src="/static/themes/default/images/lo.jpg" /></div>
            <div class="log">
                <div class="form clear">
                    <form action="/index/forgetpassword" name="ForgetPassword" method="post">
                        <ul id="form_log">
                            <li><span>邮箱：</span><input id="email" name="email" type="text" value="" style="width:200px;" /></li>
                            <li class="yzm"><span>验证码：</span>
                                <input name="authcode" type="text" id="verify" value=""/>
                                <div class="yz_img" style="width:100px;height:40px;"><img id="yzm" src="/index/authcode"/></div>
                                <div class="ht"><a href="javascript:;" onClick="yz()">看不清换一张</a></div>
                            </li>
							<input name="type" value="u" type="hidden" style="width:auto; margin-top:5px;"/>
                            <input type="hidden" value="0" name="isverify" id="isverify" />
                        </ul>
                        <input style="border:none" class="su" type="submit" value=" 提 交 " />
                        <a class="ms" href="/index/index">返回首页</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
</div>

{{template "default/Public/Footer.tpl"}}