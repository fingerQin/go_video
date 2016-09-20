{{template "default/Public/Header.tpl" .}}
 
<script type="text/javascript">

// 收藏。
function sc(){
	var relateid = $("#relateid").val();
	$.post("/User/AddFavorite",{courseid:relateid},function(n){
		if (n.status==403) {
			tis("请先登录")
			window.location.href="/index/login"
		} else {
			tis(n.message)
		}	
	},"json")
}

$(function(){
	// 评论。
	$("#mypl").click(function(){
		var star     = $("#fs_1").text();
		var relateid = $("#relateid").val();
		var content  = $("#comment_content").val();
		var typeid   = $("#comment_typeid").val();
		var touserid = $("#touserid").val();
		if (content.length==0) {
			tis("没有评论内容");
			return false;
		} 
		$.post("/user/addcomment",{ relateid:relateid,content:content,typeid:typeid,touserid:touserid,star:star},function(n){			
			if (n.status==403) {
				tis("请先登录")
			} else {
				tis(n.message)
			}
		},"json")
	})	
})
</script>

<div id="body">
	<div class="nr">
		<div class="left">
			<div id="kcjs">
				<div class="do_1">
					<div class="img"><img width="190" height="140" src="{{.course.Courseimg}}" /></div>
					<div class="xq">
						<h3><a name="top" href="javascript:void(0)">{{.course.Coursename}}</a></h3>
						<p class="kc">课程数：<span> {{.course.Lessontimes}} </span>讲</p>
						<p class="gm">购买数：<span> {{.course.Buytimes}} </span>人</p>
						<p class="jz">讲座人：{{.course.Teacher}}</p>
                     	<p class="rd"> &nbsp;热&nbsp; 度：{{.course.Hits}}</p>
						<p class="hp" id="star_course"> <i></i><i></i><i></i><i></i><i></i> <span>{{.course.Star}}.0</span><b>({{.course.Appraise}}人评价)</b></p>
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
					</div>
					<div class="pi">
					{{if .isBuy}}
						<!--<a href="/index/videoview?courseid=1"></a>-->
					{{else}}
						<div class="bb"> <span class="jg">{{.course.Price}}</span> </div>
						<a class="gm" href="javascript:void(0);" onclick="buy()" data-id="130"></a>  
					{{end}}
					</div>
					<div class="clear"></div>
					<div class="myin" style=" margin:0; margin-top:20px;">
						<ul class="nav" style="padding:0;">
							<li {{if ne .iscomment "is"}}class="dj"{{end}}><a href="/index/videoview?courseid={{.course.Courseid}}">课程详情</a></li>
							<li {{if eq .iscomment "is"}}class="dj"{{end}} > <a href="/index/videoview?courseid={{.course.Courseid}}&comment=is">所有评论</a> </li>
							<p class="clear"></p>
						</ul>
					</div>
				</div>
				
				{{if eq .iscomment "is"}}
					<div id="news_c">
						<div id="comment" >
							<div class="comment_1 content">
								<ul>
									{{with .commlist}}
									{{range .}}
									<li>
										<div class="b1">
											<div class="tx">
												<div class="img"><img style="max-width:48px;" src="{{.Avatar}}"/></div>
											</div>
											<div class="rt">
												<p>{{.Realname}}</p>												
												<div class="pl" id="star_cont_{{.Commentid}}"><i></i><i></i><i></i><i></i><i></i> <span>5.0</span></div>
												<script type="text/javascript">
												var cid = "star_cont_{{.Commentid}}"
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
												html += " <span>"+star+".0</span>"
												$("#" + cid).empty();
												$("#" + cid).html(html);
												</script>	
											</div>
											<div class="clear"></div>
										</div>
										<div class="b2 gb"> {{.Content}} </div>
										<div style="left: 420px;position: absolute; color:#CCC;top: 10px;">{{.Addtime}}</div>
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
					<div class="clear"></div>
				{{else}}
					<div class="do_2">
						<p class="tt">简介：</p>
						<div class="intro">{{str2html .course.Intro}}</div>
	                </div>
					<!-- <div class="do_3">
						<ul class="rmbq">
							<li><a href="/index.php/Video/listf/tags/javascript">	</a></li>
							<li><a href="/index.php/Video/listf/tags/jquery">jquery</a></li>
						</ul>
						<div class="clear"></div>
					</div>-->
					<div class="do_4">
						<div class="kclb">
							<table width="100%" border="0" cellpadding="2" cellspacing="0">
								<tr class="top">
									<td width="450">课时（共{{.course.Lessontimes}}节）</td>
									<td width="105">视频时长</td>
									<td>学习状态</td>
								</tr>
	
								{{with $field := .VideoList}}
								{{range $k, $item := $field}}
								<tr>
									<td><p class="p1">V:{{$k}}</p>
										<p class="p2"><a href="/index/videoplay?courseid={{$item.Courseid}}&videoid={{$item.Videoid}}">{{$item.Videoname}}</a></p>
									</td>
									<td><span>{{$item.Duration}}</span> 分钟</td>
									<td class="xxzt"> 
										<a style="background: url(/static/themes/default/images/mf.jpg) 0 0 no-repeat;" href="/index/videoplay?courseid={{$item.Courseid}}&videoid={{$item.Videoid}}"></a> 
									</td>
								</tr>
								{{end}}
								{{end}}
							</table>
						</div>
					</div>
				{{end}}			
				</div>
			<div id="kc">
				<div class="hd">
					<h3>推荐课程</h3>
				</div>
				<div class="bd">
					<ul class="clear">
					{{with .recommendCourse}}
					{{range $k, $v := .}}
						<li {{if eq $k 0}}{{end}}>
							<div class="img"><a href="/index/videoview?courseid={{.Courseid}}">  <img width="190" height="140" src="{{.Courseimg}}" />  </a></div>
							<h4>{{.Coursename}}</h4>
							<!-- <p class="co"><a href="/index/videoview?courseid={{.Courseid}}">{{.Intro}}</a></p> -->
							<p class="zh">课程数：<span>{{.Lessontimes}}</span>讲</p>
							<p class="jk">讲座人：<a href="">{{.Teacher}}</a></p>
							<div class="jg">{{.Price}}</div>
						</li>
					{{end}}
					{{end}}
					<div class="clear"></div>
					</ul>
					<div class="clear"></div>
				</div>
			</div>
		</div>
		<div class="right">
			<div class="box">
				<div class="hd">
					<h3>学习助手</h3>
				</div>
				<div class="bd">
					<ul class="xxgj">
						<li> 
							<a href="javascript:;">
								<p><img src="/static/themes/default/images/view_03.jpg"/></p>
								<p style="padding-left:8px;">笔记</p>
							</a> 
						</li>
						<li> 
							<a href="javascript:;" onclick="sc()">
								<p><img src="/static/themes/default/images/view_05.jpg"/></p>
								<p>收藏</p>
							</a> 
						</li>
						<li> 
							<a href="javascript:;">
								<p><img src="/static/themes/default/images/view_07.jpg"/></p>
								<p>试试</p>
							</a> 
						</li>
						<li> 
							<a href="javascript:;">
								<p><img src="/static/themes/default/images/view_07.jpg"/></p>
								<p>代码</p>
							</a> 
						</li>
					</ul>
					<div class="clear"></div>
				</div>
			</div>
			<div class="box" style="border:none; margin-top:20px">
				<div class="hd">
					<h3>评论课程</h3>
				</div>
				<div class="bd" id="comment" >
					<div class="pjia_form" style="display:block">
						<form action="/User/AddComment" method="post">
							<ul>
								<li>
									<p style=" float:left;">先给课程打分：</p>
									<i id="a1" class=""></i> <i id="a2" class=""></i> <i id="a3" class=""></i> <i id="a4" class=""></i> <i id="a5" class=""></i>
									<p style=" float:left; color:#FF6600" id="fs_1">5.0</p>
									<div class="clear"></div>
								</li>
								<li>
									<textarea name="content" id="comment_content"></textarea>
								</li>
							</ul>
							<input type="hidden" name="relateid" id="relateid" value="{{.course.Courseid}}"/>
							<input name="typeid" value="2" id="comment_typeid" type="hidden"/>
							<input name="touserid" value="0" id="touserid" type="hidden"/>
							<a href="javascript:;" id="mypl">发&nbsp; &nbsp; 表</a>
						</form>
					</div>
					<div class="content" id="content">
						<ul>
						{{with .CommentList}}
						{{range .}}
							<li>
								<div class="b1">
									<div class="tx">
										<div class="img"><img src="{{.Avatar}}"/></div>
									</div>
									<div class="rt">
										<p>{{.Realname}}</p>
										<div class="pl" id="star_right_{{.Commentid}}"><i></i><i></i><i></i><i></i><i></i> <span>5.0</span></div>
										<script type="text/javascript">
										var cid = "star_right_{{.Commentid}}"
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
										html += " <span>"+star+".0</span>"
										$("#" + cid).empty();
										$("#" + cid).html(html);
										</script>										
									</div>
									<div class="clear"></div>
								</div>
								<div class="b2 gb">{{.Content}}</div>
								<p class="zk"><span style="text-align:left">{{.Addtime}}</span></p>
								<div class="clear"></div>
							</li>
						{{end}}	
						{{end}}	
						</ul>
					</div>
					<div class="clear"></div>
				</div>
			</div>
			
			<div class="box">
				<div class="hd">
					<h3>赞助推荐</h3>
				</div>
				<div class="bd">
					<a href="{{.sponsorAd.LinkUrl}}"><img width="260" src="{{.sponsorAd.ImgUrl}}" alt="赞助推荐" /></a>
				</div>
			</div>
			
			<!--
			<div class="box">
				<div class="hd">
					<h3>同学们</h3>
				</div>
				<div class="bd">
					<ul class="xxgj txm">							
						<li>
							<p class="p1"><a href="/index.php/Blogs/user/userid/262"><img src="/static/themes/default/images/t1_user.jpg"/></a></p>
							<p>juirceyy</p>
						</li>
					</ul>
					<div class="clear"></div>
				</div>
			</div> 
			-->
			<div class="box">
				<div class="hd">
					<h3>最新文章</h3>
				</div>
				<div class="bd">
					<ul class="zxdt">
					{{with .bestnewslist}}
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
		</div>
		<div class="clear"></div>
	</div>
</div>

<script type="text/javascript">
function buy()
{
	$.ajax({
	   type: "POST",
	   url: "/user/getuserinfo",
	   dataType: "json",
	   success: function(data){
	    	if ( typeof(data.status) != "undefined" && data.status == "403")
			{
				tis("请先登录");return;
			}
			else
			{
				art.dialog({
					title:'购买课程',
					content:'<div id="buy"><div class="b_1">你的当前余额：<span> ' + data.Cash + '元</span> </div><div class="b_2"><img src="/static/themes/default/images/gm_3.png"/></div><div class="b_3"><div class="img"><img width="130" height="96" src="{{.course.Courseimg}}" /> </div> <div class="nr"><p><span>讲师：</span>{{.course.Teacher}}</p><p><span>课&nbsp;&nbsp;程：</span>{{.course.Coursename}}</p> <p style=" color:#Fb0000"><span>价&nbsp;&nbsp;格：</span>{{.course.Price}} 元</p> </div></div> <div class="b_4"><form action="/User/CourseBuy" method="post"><input type="hidden" name="courseid" value="{{.course.Courseid}}" /><p><input type="image" id="sub_buy" style="border:none;" src="/static/themes/default/images/gm_1.png"/></p> <p><a href="/User/Alipay"><img src="/static/themes/default/images/gm_2.png"/></a></p></form></div><div class="clear"></div></div>',
					width:400,
					height:250,
					opacity:0.5,
					drag:true,
					lock:true
				})
			}
	   }
	});
}
</script>

{{template "default/Public/Footer.tpl"}}