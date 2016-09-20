{{template "default/System/Header.tpl" .}}

<div id="user">
	<div id="body">
		{{template "default/System/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div id="video">
				<div class="box">
					<div class="hd"><h3>我的课程</h3>
					<a class="fancy" href="/system/addcourse">添加课程</a></div>
					<div class="bd">
						
						<form action="" method="GET" id="search_form">
						<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:20px;margin-bottom:10px;">
	            			<tbody>
							<tr>
	            				<td align="right" style="width:60px">课程名称：</td>
		           				<td><input type="text" class="input_middle" name="coursename" value="{{.coursename}}" /></td>
								<td align="right" style="width:60px">讲师名称：</td>
	            				<td><input type="text" class="input_short" name="teacher" value="{{.teacher}}" /></td>
								<td align="center"><button name="submit" class="button" type="submit">搜索</button></td>
	            			</tr>
						</table>
						</form>

						<div class="kclb"> 							
							<ul class="list">
							{{with .Course}}
							{{range .}}							
								<li>
									<div class="img"><a target="_blank" href="/index/videoview?courseid={{.Courseid}}">  <img src="{{.Courseimg}}" />  </a></div>
									<div class="xq" style="width:400px;">
										<h3><a target="_blank" href="/index/videoview?courseid={{.Courseid}}">{{.Coursename}}</a></h3>
										<div class="co">{{str2html .Intro}}</div>
										<p class="kc">课程数：<span> {{.Lessontimes}} </span>讲</p>
										<p class="gm">购买数：<span> {{.Buytimes}} </span>人</p>
										<p class="jz">讲座人：{{.Teacher}}</p>
										<p class="hp" id="star_course_{{.Courseid}}"> <i></i><i></i><i></i><i></i><i></i> <span>5.0</span><b>({0人评价)</b> </p>
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
									<div class="pi">
										<a style="background-image:none;height:25px;font-size:14px;padding-left:20px;" class="fancy" href="#showCourse_{{.Courseid}}">查看</a>
										<a style="background-image:none;height:25px;font-size:14px;padding-left:20px;" class="fancy" href="/system/editcourse?courseid={{.Courseid}}" href="">编辑</a>
										<a style="background-image:none;height:25px;font-size:14px;padding-left:20px;" onClick="return confirm('您确定要删除么？')" href="/system/deletecourse?courseid={{.Courseid}}">删除</a>
										<div class="jg">{{.Price}}</div>
									</div>
									<div class="clear"></div>
									<!-- 课程详情弹出框 start -->
									<div style="display:none;">
										<div class="fancy_modal" style="width: 600px; display: none;" id="showCourse_{{.Courseid}}">
									     <div class="fancy_header">
									         <h3>查看课程详情</h3>
									     </div>
									     <div class="fancy_content" style="min-height:100px;">
									         <div class="fancy_text">
							            		<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:0;">
							            			<tbody><tr>
							            				<td align="right" style="width:80px">课程标题：</td>
							            				<td colspan="5">{{.Coursename}}</td>
							            			</tr>
							            			<tr>
							            				<td align="right">课程介绍：</td>
							            				<td colspan="5">{{.Intro}}</td>
							            			</tr>
													<tr>
							            				<td align="right">讲师：</td>
							            				<td>{{.Teacher}}</td>
														<td align="right">显示状态：</td>
							            				<td colspan="3">{{if eq .Display 1}}显示{{else}}隐藏{{end}}</td>
							            			</tr>
													<tr>
														<td align="right">备注：</td>
														<td colspan="5">{{.Remark}}</td>
													</tr>
													<tr>
														<td align="right">课程标签：</td>
														<td colspan="5">{{.Coursetag}}</td>
													</tr>
													<tr>
														<td align="right">封面图片：</td>
														<td colspan="5"><img height="140" src="{{.Courseimg}}" alt="封面" /></td>
													</tr>
													<tr>
							            				<td align="right">价格：</td>
							            				<td>{{.Price}} (元)</td>
														<td align="right">购买次数：</td>
							            				<td>{{.Buytimes}}</td>
														<td align="right">课程数：</td>
							            				<td>{{.Lessontimes}}</td>
							            			</tr>
													<tr>
							            				<td align="right">评价人数：</td>
							            				<td>{{.Appraise}}</td>
														<td align="right">星级：</td>
							            				<td colspan="3">{{.Star}}</td>
							            			</tr>
							            		</tbody>
												</table>
							            	</div>
							            </div>
							            <div class="fancy_footer">
								            <a class="fancy_button fancy_button_default fancy_close">关闭</a>
								        </div>
					            	</div>
					            </div><!-- 课程详情弹出框 end -->
									
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
		</div>
	</div>
</div>
<div class="clear"></div>

{{template "default/System/Footer.tpl"}}