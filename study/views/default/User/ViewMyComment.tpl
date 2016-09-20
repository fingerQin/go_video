{{template "default/Public/Header.tpl" .}}

<div id="user">
	<div id="body">
		{{template "default/User/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div class="box">
				<div class="bd">
					<div class="myin">
						<ul class="nav">
							<li><a href="/user/viewcomment">我的留言</a></li>
							<li class="dj"> <a href="/user/viewmycomment">给我的留言</a> </li>
							<p class="clear"> </p>
						</ul>
					</div>
					<div class="clear"></div>
					
					<ul class="mlist">
						{{with .CommentList}}
						{{range .}}
						<li>
							<div><span style="color:#03C;"> {{.Username}} </span>给我的留言 </div>
							<div class="lynr">
								<p class="nr">{{.Content}}</p>
								<div class="huifu_13 huifu"></div>
								<p style="text-align:right">
									<span>时间：{{.Addtime}}</span>
									<a class="chf" data-id="13" href="javascript:;">回复</a>
								</p>
							</div>
						</li>
						{{end}}
						{{end}}
					</ul>
				</div>
				<div class="clear"></div>
			</div>
		</div>
	</div>
</div>
<div class="clear"></div>
{{template "default/Public/Footer.tpl"}}