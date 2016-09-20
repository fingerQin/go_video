{{template "concise/Public/Header.tpl"}}

<div id="user">
	<div id="body"> 
		{{template "concise/User/LeftContent.tpl" .userinfo}}
		<div class="right">
			<div id="zil">
				<div class="box">
					<div class="hd">
						<h3>我的资料</h3>
					</div>
					<div class="bd">
						<div class="kclb">
							<div class="nav">
								<ul>
									<li><a href="/User/UserInfo">个人资料</a></li>
									<li class="dj"> <a href="/User/UpdateAvatar">更新头像</a> </li>
									<li> <a href="/User/EditPwd">修改密码</a> </li>
									<div class="clear"></div>
								</ul>
							</div>
							<div class="clear"></div>
							
							<div class="mod">
								<h2 style=" font-size:16px;margin:10px; margin-top:30px; text-indent:15px;">你当前的头像</h2>
								<p style=" margin:24px"> 	<div class="img"><img src="{{.userinfo.Avatar}}"></div>
								<div class="clear"></div>
								</p>
								<form style=" margin-left:24px" action="/User/UpdateAvatar" enctype="multipart/form-data" method="post" class="form">
									<p> 从你的电脑中选择你喜欢的图片: <br>
										<br>
											<input type="file" style="height:23px" name="avatar">
										<br>
										<br>
										<br>
										<span class="assist-text">你可以上传JPG、JPEG、GIF、PNG文件。</span> </p>
									<p style="margin-top:15px;">
										<input class="bc" type="submit" name="upload" value=" 保 存 " />
									</p>
								<input type="hidden" name="__hash__" value="0ea25fb0f82eb4ddda3182029fb81633_702364f5e3e80e9005fd0003108765ca" /></form>
							</div>
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