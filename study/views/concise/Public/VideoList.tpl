{{template "concise/Public/Header.tpl"}}

<div class="H_main">
  <div class="H_main_bg clearfix">
    <div class="H_main_l">
    	
    	{{with .Course}}
		{{range .}}	
		<div class="pic_slider">
            <div class="wrap_l">
                <ul class="piclist">
					<li><a href="/Index/VideoView?courseid={{.Courseid}}"><img src="{{.Courseimg}}" width="340" height="200" alt="{{.Coursename}}" border="0"/></a></li>
                </ul>
            </div>
            <div class="wrap_r">
                <h2><a href="/Index/VideoView?courseid={{.Courseid}}">{{.Coursename}}</a></h2>
                <div class="help_problem_list">
                    <div class="problem_list_cont">
                        <ul>
                        	<li>讲座人：{{.Teacher}}</li>
                        	<li>课程数：{{.Lessontimes}} 节</li>
                        	<li>浏览数：{{.Hits}} 次</li>
                        	<li>购买数：{{.Buytimes}} 人</li>
							<li><p class="hp" id="star_course"> <i></i><i></i><i></i><i></i><i></i> <span>{{.Star}}.0</span><b>({{.Appraise}}人评价)</b></p></li>
							<script type="text/javascript">
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
								$("#star_course").empty();
								$("#star_course").html(html);
							</script>
                         </ul>
                    </div>
                </div>
            </div>
        </div>
		{{end}}
		{{end}}
		
		{{if gt .Page.TotalPage 1}}
		<div id="pagenav">
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
		
		<div style="height:20px;margin-top:20px;clear:both;"></div>

    </div>
    <div class="H_main_r">
    	
		<!--工具栏-->
		<div class="user_info">
		    <ul class="data_num_log clearfix">
		    <li><a href="/uq" class="W_emplinkb"><em>0</em>笔记</a></li>
		    <li><a href="http://weiwen.wenwo.com/question/myquestions" target="_blank"><em>0</em>收藏</a></li>
		    <li><a href="http://weiwen.wenwo.com/question/myanswered" target="_blank"><em>0</em>试试</a></li>
		    <li class="last"><a href="http://weiwen.weibo.com/sinahelp/apply" target="_blank"><em>10</em>帮助</a></li>
		    </ul>
		</div>
		<!--/工具栏-->

        <!-- 最新文章 -->
        <div class="help_title"><h2 class="bg_s">最新文章</h2></div>
		<div class="help_conlist latest_links_box clearfix" style="height:200px;">				
			<ul class="sidebar_txt">
				{{with .newslist}}
				{{range $k, $v := .}}
					<li><a title="{{.Title}}" href="/Index/Show?newsid={{.Newsid}}">{{.Title}}</a></li>
				{{end}}
				{{end}}
				</ul>
			</ul>				
		</div>
		<!-- 最新文章 end -->

		<!-- 最热文章 -->
        <div class="help_title"><h2 class="bg_s">最热文章</h2></div>
		<div class="help_conlist latest_links_box clearfix" style="height:200px;">				
			<ul class="sidebar_txt">
				{{with .hotnewslist}}
				{{range $k, $v := .}}
					<li><a title="{{.Title}}" href="/Index/Show?newsid={{.Newsid}}">{{.Title}}</a></li>
				{{end}}
				{{end}}
				</ul>
			</ul>				
		</div>
		<!-- 最热文章 end -->

		<!-- 热门标签 -->
        <div class="help_title"><h2 class="bg_s">热门标签</h2></div>
		<div class="help_conlist latest_links_box clearfix" style="height:200px;">				
							
		</div>
		<!-- 热门标签 end -->
    </div>
  	</div>
</div>

{{template "concise/Public/Footer.tpl"}}