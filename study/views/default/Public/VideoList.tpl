{{template "default/Public/Header.tpl" .}}
 
<script type="text/javascript">
$(function(){
	//一次横向滚动一个
	$('#marquee1').kxbdSuperMarquee({
		distance:226,
		time:3,
		btnGo:{ left:'#goL',right:'#goR'},
		direction:'left'
	});
});
$(function(){
	$("#tab #zx").click(function(){
		var a = $(this).attr("class");
		if(a != "zx"){
			return false;
		}
	});
	$("#tab #zr").click(function(){
		var a = $(this).attr("class");
		if(a != "zr"){
			return false;
		}
	});
});
</script>
<div id="body">

	<div class="nr">
		<div class="left">
			<div id="list">
				<div class="top">
					<div class="px" id="tab">
						{{if eq .listorder "new"}}
						<p id="zx" class="zx_1"><a href="/index/videolist?sort=new">最新</a></p>
						<p id="zr" class="zr"> <a href="/index/videolist?sort=hot">最热</a></p>
						{{end}}

						{{if eq .listorder "hot"}}
						<p id="zx" class="zx"><a href="/index/videolist?sort=new">最新</a></p>
						<p id="zr" class="zr_1"> <a href="/index/videolist?sort=hot">最热</a></p>
						{{end}}
						
					</div>
					<div class="clear"></div>
				</div>
				<div class="bd">
					<div class="zuix">
						<ul class="list">
						{{with .Course}}
						{{range .}}							
							<li>
								<div class="img"><a href="/index/videoview?courseid={{.Courseid}}">  <img src="{{.Courseimg}}" />  </a></div>
								<div class="xq" style="width:280px;">
									<h3><a href="/index/videoview?courseid={{.Courseid}}">{{.Coursename}}</a></h3>
									<div class="co">{{.Intro}}</div>
									<p class="kc">课程数：<span> {{.Lessontimes}} </span>讲</p>
									<p class="gm">热度：<span> {{.Hits}} </span></p>
									<p class="jz">讲座人：{{.Teacher}}</p>
									<p class="hp" id="star_course_{{.Courseid}}"> <i></i><i></i><i></i><i></i><i></i> <span>5.0</span><b>(0人评价)</b> </p>
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
								<div class="pi"> <a href="/index/videoview?courseid={{.Courseid}}"></a></div>
								<div class="clear"></div>
							</li>
						{{end}}
						{{end}}
						</ul>
					</div>
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
		<div class="right">			
			<div class="box">
				<div class="hd">
					<h3>最新文章</h3>
				</div>
				<div class="bd">
					<ul class="zxdt">
					{{with .newslist}}
					{{range .}}
						<li><a href="/index/show?newsid={{.Newsid}}">{{.Title}}</a></li>
					{{end}}
					{{end}}
					</ul>
					<div class="clear"></div>
				</div>
			</div>
			
			<div class="box">
				<div class="hd">
					<h3>最热文章</h3>
				</div>
				<div class="bd">
					<ul class="zxdt">
					{{with .hotnewslist}}
					{{range .}}
						<li><a href="/index/show?newsid={{.Newsid}}">{{.Title}}</a></li>
					{{end}}
					{{end}}
					</ul>
					<div class="clear"></div>
				</div>
			</div>
			
			<div class="box">
				<div class="hd">
					<h3>热门标签</h3>
				</div>
				<div class="bd">
					<ul class="rmbq">
						{{with .tags}}
						{{range .}}
						<li><a href="/index/videolist?tag={{.Coursetag}}">{{.Coursetag}}</a></li>
						{{end}}
						{{end}}
					</ul>
					<div class="clear"></div>
				</div>
			</div>
		</div>
		<div class="clear"></div>
	</div>
</div>

{{template "default/Public/Footer.tpl"}}