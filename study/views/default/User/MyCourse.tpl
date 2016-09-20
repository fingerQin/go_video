{{template "default/Public/Header.tpl" .}}

<div id="user">
	<div id="body">
		{{template "default/User/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div id="video">
				<div class="box">
					<div class="hd">
						<h3>我的课程</h3>
					</div>
					<div class="bd">
						<div class="kclb"> 							
							<ul class="list">
							{{with .Course}}
							{{range .}}							
								<li>
									<div class="img"><a href="/index/videoview?courseid={{.Courseid}}">  <img src="{{.Courseimg}}" />  </a></div>
									<div class="xq" style="width:400px;">
										<h3><a href="/index/videoview?courseid={{.Courseid}}">{{.Coursename}}</a></h3>
										<div class="co">{{str2html .Intro}}</div>
										<div style="width:320px;">
										<p class="kc">课程数：<span> {{.Lessontimes}} </span>讲</p>
										<p class="gm">热度：<span> {{.Hits}} </span></p>
										<p class="jz">讲座人：{{.Teacher}}</p>
										<p class="hp" id="star_course_{{.Courseid}}"> <i></i><i></i><i></i><i></i><i class='no'></i> <span>5.0</span><b>(0人评价)</b> </p>
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
					</div>
					<div class="clear"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="clear"></div>
{{template "default/Public/Footer.tpl"}}