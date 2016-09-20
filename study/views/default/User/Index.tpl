{{template "default/Public/Header.tpl" .}}

<div id="user">
	<div id="body"> 
		{{template "default/User/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div class="box"> 

				<div class="bd"> 
					
					<div class="myin">
						<ul class="nav">
							<li class=dj><a href="/user/index">课程推荐</a></li>
							<li > <a href="/user/myfavorites">我的收藏</a> </li>
							<p class="clear"> </p>
						</ul>
					</div>
					<div class="clear"></div>
					<ul class="list">
						{{with .Course}}
						{{range .}}							
							<li>
								<div class="img"><a href="/index/videoview?courseid={{.Courseid}}">  <img src="{{.Courseimg}}" />  </a></div>
								<div class="xq" style="width:400px;">
									<h3><a href="/index/videoview?courseid={{.Courseid}}">{{.Coursename}}</a></h3>
									<div class="co">{{.Intro}}</div>
									<div style="width:320px;">
										<p class="kc">课程数：<span> {{.Lessontimes}} </span>讲</p>
										<p class="gm">热度：<span> {{.Hits}} </span></p>
										<p class="jz">讲座人：{{.Teacher}}</p>
										<p class="hp" id="star_course_{{.Courseid}}"> <i></i><i></i><i></i><i></i><i></i> <span>0.0</span><b>(0人评价)</b> </p>
										<script type="text/javascript">
											var cid = "star_course_{{.Courseid}}"
											var star = {{.Star}}
											var diff = 5 - star
											var html = ''
											for(i = 1; i <= star; i++)
											{
												html += "<i></i>"
											}
											for(i = 1; i <= diff; i++)
											{
												html += "<i class=\"no\"></i>"
											}
											html += " <span>"+star+".0</span><b>({{.Appraise}}人评价)</b>"
											$("#" + cid).empty();
											$("#" + cid).html(html);
										</script>
									</div>
								</div>
								<div class="pi"><a href="/index/videoview?courseid={{.Courseid}}"></a></div>
								<div class="clear"></div>
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

{{template "default/Public/Footer.tpl"}}