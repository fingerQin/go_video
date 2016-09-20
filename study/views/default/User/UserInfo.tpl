{{template "default/Public/Header.tpl" .}}

<div id="user">
	<div id="body"> 
		{{template "default/User/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div id="zil">
				<div class="box">
					<div class="hd">
						<h3>我的资料</h3></div>
						<div class="bd">
						<div class="kclb">
							<div class="nav">
								<ul>
									<li class="dj"><a href="/user/userinfo">个人资料</a></li>
									<li> <a href="/user/updateavatar">更新头像</a> </li>
									<li> <a href="/user/editpwd">修改密码</a> </li>
									<div class="clear"></div>
								</ul>
							</div>
							<div class="clear"></div>
         			
							<form action="/user/userinfo" method="post">
								<table width="100%" cellspacing="0" cellpadding="2" border="0">
									<tr>
										<td width="150"></td>
										<td width="300"></td>
									</tr>
									<tr>
										<td style="font-weight:700" height="30" align="right"> 用户名：</td>
										<td>{{.userinfo.Username}}</td>
									</tr>							
                                    <tr>
						                <td style="font-weight:700" height="30" align="right"> 昵 称：</td>
                                        <td><input name="nickname" type="text"  value="{{.userinfo.Realname}}"/></td>
                                        <td></td>
                                    </tr>
									<tr>
										<td style="font-weight:700" height="30" align="right"> 性 别：</td>
										<td>
											<select name="sex" style=" width:100px">
												<option value="0">请选择</option>
												<option {{if eq .userinfo.Sex 1}}selected="selected"{{end}} value="1">男</option>
												<option {{if eq .userinfo.Sex 2}}selected="selected"{{end}} value="2">女</option>
											</select>
										</td>
										<td></td>
									</tr>
									<tr>
										<td style="font-weight:700" height="30" align="right">E-mail：</td>
										<td><input type="text" value="{{.userinfo.Email}}" id="mail" name="email"/>&nbsp;{{if ne .userinfo.Isactive 1}}<a onClick="sendMailActive()" style="color:#F00;" href="javascript:void(0);">邮箱激活</a>{{end}}</td>
										<td id="mail_t"></td>
									</tr>
									<tr>
										<td style="font-weight:700" height="30" align="right"></td>
										<td><input class="bc" type="submit" id="gxbc" name="sub_1" value=" 保 存 " /></td>
										<td></td>
									</tr>
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

<script type="text/javascript">
// 发送邮箱激活邮件。
function sendMailActive()
{
	$.ajax({
	    type: "POST",
	    url: "/user/sendactivatemail",
		dataType: 'json',
	    success: function(data){
	        alert(data.message);
	   }
	});
}
</script>
{{template "default/Public/Footer.tpl"}}