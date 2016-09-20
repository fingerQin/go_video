{{template "default/Public/Header.tpl" .}}

<div id="user">
	<div id="body"> 
		{{template "default/User/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div id="zil">
				<div class="box">
					<div class="hd">
						<h3>我的资料</h3>
					</div>
					<div class="bd">
						<div class="kclb">
							<div class="nav">
								<ul>
									<li><a href="/user/userinfo">个人资料</a></li>
									<li> <a href="/user/updateavatar">更新头像</a> </li>
									<li class="dj"> <a href="/user/editpwd">修改密码</a> </li>
									<div class="clear"></div>
								</ul>
							</div>
							<div class="clear"></div>							
							 
							<script type="text/javascript">
								$(function(){
									$("#jiu").blur(function(){
										jiu();	
									})
									$("#psw").blur(function(){
										psw();	
									})
									$("#new_q").blur(function(){
										psw_q();	
									})
									$("#mm_bc").click(function(){
										jiu();psw();psw_q();
										var a =$("#jiu_a").val();
										var b =$("#psw_a").val();
										var c =$("#new_a").val();
										if(a == "1" && b=="1" && c=="1"){
											return true;	
										}else{
											return false;	
										}
									})	
								});	
								function jiu(){
									var a = $("#jiu").val();							
									if(a.length == 0){ 
										$("#jiu_t").html("<span style=\" color:#F00;\">请输入旧密码</span>");
										$("#jiu_a").val("0");
									}else{ 
										$("#jiu_t").html("");
										$("#jiu_a").val("1");
									}	
								}
								function psw(){
									var a = $("#psw").val();
									if(a.length == 0){ 
										$("#psw_t").html("<span style=\" color:#F00;\">请输入密码</span>");
										$("#psw_a").val("0");
									}else{ 
										if(a.length < 6){
											$("#psw_t").html("<span style=\" color:#F00;\">密码小于6位</span>");
											$("#psw_a").val("0");
										}else{
											$("#psw_t").html("");
											$("#psw_a").val("1");
										}
									}	
								}
								function psw_q(){
									var a = $("#psw").val();
									var b = $("#new_q").val();
									if(a !== b){ 
										$("#new_t").html("<span style=\" color:#F00;\">密码不一致</span>");
										$("#new_a").val("0");
									}else{ 
										$("#new_t").html("");
										$("#new_a").val("1");
									}	
								}
							</script>
							<form action="/user/editpwd" method="post">
								<table width="100%" cellspacing="0" cellpadding="2" border="0">
									<input type="hidden" value="0" id="jiu_a" />
									<input type="hidden" value="0" id="psw_a" />
									<input type="hidden" value="0" id="new_a" />
									<tr>
										<td width="150"></td>
										<td width="235"></td>
										<td></td>
									</tr>
									<tr>
										<td style="font-weight:700" height="30" align="right">旧密码：</td>
										<td><input type="password" id="jiu" name="oldPwd"/></td>
										<td id="jiu_t"></td>
									</tr>
									<tr>
										<td style="font-weight:700" height="30" align="right">新密码：</td>
										<td><input type="password" value="" id="psw" name="newPwd"/></td>
										<td id="psw_t"></td>
									</tr>
									<tr>
										<td style="font-weight:700" height="30" align="right">确认密码：</td>
										<td><input type="password" id="new_q" name="verify"/></td>
										<td id="new_t"></td>
									</tr>
									<tr>
										<td style="font-weight:700" height="30" align="right"></td>
										<td><input class="bc" type="submit" id="mm_bc" name="sub_2" value=" 保 存 " /></td>
									</tr>
									<input type="hidden" name="uid" value="6246" />
								</table>
								<input type="hidden" name="__hash__" value="" />
							</form>
						</div>
					</div>
					<div class="clear"></div>
				</div>
			</div>
		</div>
		<div class="clear"></div>
	</div>
</div>
<div class="clear"></div>
{{template "default/Public/Footer.tpl"}}