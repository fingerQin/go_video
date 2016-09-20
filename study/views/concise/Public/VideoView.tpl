{{template "concise/Public/Header.tpl"}}

<div class="H_main">
  <div class="H_main_bg clearfix">
    <div class="H_main_l">
    	<!-- pic_slider -->
    	<div class="pic_slider">
            <div class="wrap_l">
                <ul class="piclist">
					<li><img src="{{.course.Courseimg}}" width="340" height="200" alt="" border=0/></li>
                </ul>
            </div>
            <div class="wrap_r">
                <h2>{{.course.Coursename}}</h2>
                <div class="help_problem_list">
                    <div class="problem_list_cont">
                        <ul>
                        	<li>讲座人：{{.course.Teacher}}</li>
                        	<li>课程数：{{.course.Lessontimes}} 节</li>
                        	<li>浏览数：{{.course.Hits}} 次</li>
                        	<li>购买数：{{.course.Buytimes}} 人</li>
							<li><p class="hp" id="star_course"> <i></i><i></i><i></i><i></i><i></i> <span>{{.course.Star}}.0</span><b>({{.course.Appraise}}人评价)</b></p></li>
							<script type="text/javascript">
								var star = {{.course.Star}}
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
								html += " <span>"+star+".0</span><b>({{.course.Appraise}}人评价)</b>"
								$("#star_course").empty();
								$("#star_course").html(html);
							</script>
                         </ul>
                    </div>
                </div>
            </div>
        </div>
		
		<!-- 课程介绍 -->
        <div class="help_title"><h2 class="bg_s">课程介绍</h2></div>
		<div class="help_conlist latest_links_box clearfix">				
		{{.course.Intro}}	
		</div>
		<!-- 课程介绍 end -->
        
        <!-- 视频列表 -->
        <div class="question_list">
            <div class="title">
                <h4 class="fl">视频列表</h4>
                <!--<span class="fr"><a href="/ask/0?status=K">» 更多</a>--></span>
            </div>
            <div class="list">
                <ul>
					{{with $field := .VideoList}}
					{{range $k, $item := $field}}					
					<li>
					<span class="fl"><a href="/Index/VideoPlay?relateid={{$item.Id}}">{{$item.Videoname}}[{{$item.Duration}}分钟]</a></span>
                   	<em class="fr W_textb"><a href="/Index/VideoPlay?relateid={{$item.Id}}">免费学习</a></em>
					</li>
					{{end}}
					{{end}}

                </ul>
            </div>
        </div>
        <!-- /视频列表 -->

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
				{{with .bestnewslist}}
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
		
		
		<!-- 课程评论 -->
        <div class="help_title"><h2 class="bg_s">课程评论</h2></div>
		<div class="help_conlist latest_links_box clearfix" style="height:200px;">				
							
		</div>
		<!-- 课程评论 end -->
    </div>
  	</div>
</div>

{{template "concise/Public/Footer.tpl"}}