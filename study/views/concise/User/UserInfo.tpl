{{template "concise/Public/Header.tpl"}}

<div id="user">
	<div id="body"> 
		{{template "concise/User/LeftContent.tpl" .userinfo}}
		<div class="right">
			<div id="zil">
				<div class="box">
					<div class="hd">
						<h3>我的资料</h3></div>
						<div class="bd">
						<div class="kclb">
							<div class="nav">
								<ul>
									<li class="dj"><a href="/User/UserInfo">个人资料</a></li>
									<li> <a href="/User/UpdateAvatar">更新头像</a> </li>
									<li> <a href="/User/EditPwd">修改密码</a> </li>
									<div class="clear"></div>
								</ul>
							</div>
							<div class="clear"></div>
         			
							<form action="/User/UserInfo" method="post">
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
										<td><input type="text" value="{{.userinfo.Email}}" id="mail" name="email"/></td>
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
{{template "concise/Public/Footer.tpl"}}