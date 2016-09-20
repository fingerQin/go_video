{{template "concise/Public/Header.tpl"}}

<div class="H_main">
  <div class="H_main_bg clearfix">
    <div class="H_main_l">
		<div class="mbx">
			<a href="/">首页</a> >> <a href="/Index/News">文章列表</a>
		</div>
		
		<div id="news_list">
			<ul>
            {{with .newslist}}
			{{range .}}
              	<li>
                	<h3><a href="/Index/Show?newsid={{.Newsid}}">{{.Title}}</a></h3>
                	<div class="aa">{{.Addtime}}&nbsp;&nbsp;|&nbsp;&nbsp;Alan&nbsp;&nbsp;|&nbsp;&nbsp;{{.Author}}</div>
                    <div class="content">{{.Intro}}</div>
                </li>
            {{end}}
            {{end}}
            </ul>
        </div>

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


{{template "concise/Public/Footer.tpl"}}