{{template "default/Public/Header.tpl" .}}

<script src="/static/themes/default/js/SyntaxHighlighter/brush.js"></script>
<link href="/static/themes/default/js/SyntaxHighlighter/shCore.css" rel="stylesheet" type="text/css" />
<link href="/static/themes/default/js/SyntaxHighlighter/shThemeDefault.css" rel="stylesheet" type="text/css" />

<script type='text/javascript'>
$(document).ready(function(){
	SyntaxHighlighter.config.clipboardSwf = '/static/themes/default/js/SyntaxHighlighter/clipboard.swf';
	SyntaxHighlighter.all();
});
</script>

<div id="body">
	<div class="nr" id="news_c">
   	 	<div class="play">
        	<div class="dh">
            	<ul>
                	<li class="in"><a href="/index/index">首页</a></li>
                    <li><a href=""></a></li>
                    <li><a href="/index/news">文章列表</a></li>
                    <li>{{.news.Title}}</li>
                </ul>
                <div class="clear"></div>
            </div>
        </div>
        <div class="left">
        	<div id="wz">
            	<div class="wz">
                	<div class="top clear">
                    	<h1>{{.news.Title}}</h1>
                        <p>{{.news.Addtime}} &nbsp;&nbsp;出处：<span>{{.news.Source}}</span>作者：<span>{{.news.Author}}</span>责任编辑：<span>{{.news.Realname}}</span><!--<span class="pl">( 评论<b> 2 </b>条 )</span>-->&nbsp; 浏览次数：{{.news.Hits}}</p> 
                    </div>
                    <div class="content">{{str2html .news.Content}}</div>
                </div>
            </div>
            <div class="box" style="margin-top:10px;">
                <div class="hd">
                    <h3>评论文章</h3>
                </div>
                <div class="bd" id="comment" >
                	<div class="pjia_form" style=" border:none">
                    <form>
                        <ul>
							<li>
								<p style=" float:left;">先给文章打分：</p>
								<i id="a1" class=""></i>
								<i id="a2" class=""></i>
								<i id="a3" class=""></i>
								<i id="a4" class=""></i>
								<i id="a5" class=""></i>
								<p style=" float:left; color:#FF6600" id="fs_1">5.0</p>
								<div class="clear"></div>
							</li>
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
										<div class="img"><a href="/index.php/Blogs/user/userid/6272"><img style="max-width:48px;" src="{{.Avatar}}"/></a></div>
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
								<div style=" left: 430px;position: absolute; color:#CCC;top: 10px;">{{.Addtime}}</div>
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
        <div class="right">
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
$(function(){
	$("#mypl").click(function(){
		var star     = $("#fs_1").text();
		var relateid = $("#relateid").val();
		var content  = $("#comment_content").val();
		var typeid   = $("#comment_typeid").val();
		var touserid = $("#touserid").val();
		$.post("/user/addcomment",{ relateid:relateid,content:content,typeid:typeid,touserid:touserid,star:star},function(n){			
			if (n.status==403) {
				tis("请先登录");
			} else {
				tis(n.message);
			}
		},"json")
	})	
})
</script>

{{template "default/Public/Footer.tpl"}}