{{template "concise/User/Userheader.tpl"}}

<div class="H_main" style="margin-top:-20px;">
	<div class="H_main_bg">
		<div class="IC_main_bg clearfix">
			<div class="H_main_l" style="width:230px;">
				{{template "concise/User/LeftContent.tpl" .userinfo}}
			</div><!-- class H_main_l end -->

			<div class="H_main_r" style="width:708px;">
				<div class="IC_main_r">
	            	<!--标题-->
	                <div class="IC_title title_list" style="padding-bottom:0px;">
	                    <h2>课程推荐</h2>
	                </div>
	                <!--/标题-->

					<!--列表-->
	                {{with .Course}}
					{{range .}}	
					<div class="pic_slider" style="width:685px;margin-left:10px;">
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
					<div id="pagenav" style="margin-left:20px;">
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
		            <!--/列表-->
		        </div>
			</div><!-- class H_main_r end -->
		</div><!-- class IC_main_bg end -->
	</div>
</div>

{{template "concise/Public/Footer.tpl"}}