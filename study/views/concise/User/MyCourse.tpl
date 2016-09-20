{{template "concise/Public/Header.tpl"}}

<div id="user">
	<div id="body">
		{{template "concise/User/LeftContent.tpl" .userinfo}}
		<div class="right">
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
									<div class="img"><a href="/Index/VideoView?courseid={{.Courseid}}">  <img src="{{.Courseimg}}" />  </a></div>
									<div class="xq">
										<h3><a href="/Index/VideoView?courseid={{.Courseid}}">{{.Coursename}}</a></h3>
										<div class="co">{{.Intro}}</div>
										<p class="kc">课程数：<span> {{.Lessontimes}} </span>讲</p>
										<p class="gm">热度：<span> {{.Hits}} </span></p>
										<p class="jz">讲座人：{{.Teacher}}</p>
										<p class="hp"> <i></i><i></i><i></i><i></i><i class='no'></i> <span>4.0</span><b>(13人评价)</b> </p>
									</div>
									<div class="pi"><a href="/Index/VideoView?courseid={{.Courseid}}"></a></div>
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
{{template "concise/Public/Footer.tpl"}}