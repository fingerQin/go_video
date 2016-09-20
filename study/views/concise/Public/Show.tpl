{{template "concise/Public/Header.tpl"}}

<div class="H_main">
  <div class="H_main_bg clearfix">
    <div class="H_main_l">
		<div class="mbx">
			<a href="/">首页</a> >> <a href="/Index/News">文章列表</a> >> {{.news.Title}}
		</div>

    	<div class="article_title">
        	<h1>{{.news.Title}}</h1>
            <p>{{.news.Addtime}} &nbsp;&nbsp;出处：<span>{{.news.Source}}</span>作者：<span>{{.news.Author}}</span>责任编辑：<span>{{.news.Realname}}</span><!--<span class="pl">( 评论<b> 2 </b>条 )</span>-->&nbsp; 浏览次数：{{.news.Hits}}</p> 
        </div>
        <div class="article_content">{{str2html .news.Content}}</div>
		
		<div class="box" style="margin-top:10px;">
            <div class="hd">
                <h3>评论文章</h3>
            </div>
            <div class="bd" id="comment" >
            	<div class="pjia_form" style=" border:none">
                <form>
                    <ul>
                        <li>
	                        <textarea style=" float:left; width:460px; height:80px;" name="comment_content" id="comment_content"></textarea>
	                        <div class="clear"></div></li>
	                        <li><a style="margin-left:0;" href="javascript:;" id="mypl">发&nbsp; &nbsp; 表</a>
	                        <div class="clear"></div>
						</li>
                    </ul>
                   <input type="hidden" name="relateid" id="relateid" value="{{.news.Newsid}}"/>
                   <input type="hidden" name="comment_typeid" id="comment_typeid" value="5"/>
                   <input type="hidden" name="touserid" value="0" id="touserid" />
                    </form>
                </div>
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
									<p>{{.Username}}</p>
									<div class="pl"> <i></i><i></i><i></i><i></i><i></i> <span>5.0</span> </div>
								</div>
								<div class="clear"></div>
							</div>
							<div class="b2 gb"> {{.Content}} </div>
							<div style=" left: 110px;position: absolute; color:#CCC;top: 10px;">{{.Addtime}}</div>
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
            </div>
        </div>

    </div>
    <div class="H_main_r">
    	
		<!--广告位-->
		<div class="user_info">
		    <div>广告位</div>
		</div>
		<!--/广告位-->

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
    </div>
  	</div>
</div>


<script type="text/javascript">
$(function(){
	$("#mypl").click(function(){
		var relateid = $("#relateid").val();
		var content  = $("#comment_content").val();
		var typeid   = $("#comment_typeid").val();
		var touserid = $("#touserid").val();
		$.post("/User/AddComment",{ relateid:relateid,content:content,typeid:typeid,touserid:touserid},function(n){			
			if (n.status==403) {
				tis("请先登录");
			} else {
				tis(n.message);
			}
		},"json")
	})	
})
</script>

{{template "concise/Public/Footer.tpl"}}