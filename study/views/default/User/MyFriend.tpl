{{template "default/Public/Header.tpl" .}}

<div id="user">
	<div id="body"> 
		{{template "default/User/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div id="note">
				<div class="box">
					<div class="hd">
						<h3>我的好友</h3>
					</div>
					<div class="bd" style="padding:15px 0 0 0">
						<ul id="myfriend">
							{{with .FriendList}}
							{{range .}}
							<li style="float:left; width:128px; height:128px; margin:0 15px; margin-bottom:15px; _display:inline;">
								<div style=" width:128px; height:128px; overflow:hidden;">
								<a href="/index.php/Blogs/user/userid/378" target="_blank">
								<img width="128" height="128" title="{{.Username}}" src="{{.Avatar}}"></a></div>
								<div style="margin-top:5px;">{{.Username}}&nbsp;&nbsp;<a href="javascript:;" class="ly" data-id="378">给他留言</a></div>
							</li>
							{{end}}
							{{end}}
							<div class="clear"></div>
						</ul>
					</div>
					{{if gt .Page.TotalPage 1}}
					<div class="ft" id="fy">  
						<li class="s"><a href="{{.Page.PrevUrl}}" class="d">上一页</a></li> 
						<!-- <li><a class="dj">1</a></li>
						<li><a href="">&nbsp;2</a></li> -->
						{{with $field := .Page}}
						{{range $index, $url := $field.Urls}}
							{{if eq $index $field.PageNumber }}
							<li><a class="dj" href="javascript:void(0)">{{$index}}</a></li>
							{{else}}
							<li><a href="{{$url}}">{{$index}}</a></li>
							{{end}}
						{{end}}
						{{end}}
						<li class="x"><a href="{{.Page.NextUrl}}">下一页</a></li> 
					</div>
					{{end}}
					<div class="clear"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="clear"></div>
{{template "default/Public/Footer.tpl"}}