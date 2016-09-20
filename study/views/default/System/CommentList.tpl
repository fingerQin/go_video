{{template "default/System/Header.tpl" .}}

<div id="user">
	<div id="body">
		{{template "default/System/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div class="box">
				<div class="hd"><h3>留言管理</h3></div>
				<div class="bd">

					<ul class="mlist">
						{{with .CommentList}}
						{{range .}}
						<li>
							<div>提交人：<span style="color:#03C;"> {{.Username}} </span> <span>提交时间：{{.Addtime}}</span> <a onClick="return confirm('您确定要删除么？');" href="/system/deletecomment?commentid={{.Commentid}}">删除</a></div>
							<div class="lynr">
								<p class="nr">{{.Content}}</p>
								<div class="huifu_13 huifu"></div>
							</div>
						</li>
						{{end}}
						{{end}}
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
<div class="clear"></div>
{{template "default/System/Footer.tpl"}}