{{template "default/Public/Header.tpl" .}}

<div id="body">
	<div class="nr">
        <div class="left">
        	<div id="wz_li">
				<ul>
                	{{with .newslist}}
					{{range .}}
                	<li>
                    	<h3><a href="/index/show?newsid={{.Newsid}}">{{.Title}}</a></h3>
                    	<div class="aa">{{.Addtime}}&nbsp;&nbsp;|&nbsp;&nbsp;责任编辑：{{.Realname}}&nbsp;&nbsp;|&nbsp;&nbsp;作者：{{.Author}}</div>
                        <div class="content clear">{{.Intro}}</div>
                    </li>
                	{{end}}
                	{{end}}
                </ul>
				
				{{if gt .Page.TotalPage 1}}
				<div class="ft" id="fy">
					<li class="s" style="border-bottom:none;"><a href="{{.Page.PrevUrl}}" class="d">上一页</a></li> 
					{{with $field := .Page}}
					{{range $index, $url := $field.Urls}}
						{{if eq $index $field.PageNumber }}
						<li style="border-bottom:none;"><a class="dj" href="javascript:void(0)">{{$index}}</a></li>
						{{else}}
						<li style="border-bottom:none;"><a href="{{$url}}">{{$index}}</a></li>
						{{end}}
					{{end}}
					{{end}}
					<li class="x" style="border-bottom:none;"><a href="{{.Page.NextUrl}}">下一页</a></li> 
				</div>
				{{end}}
				<div class="clear"></div>
            </div>

        </div>
        <div class="right">
			<div class="box">
				<div class="hd">
					<h3>文章分类</h3>
				</div>
				<div class="bd">
					<ul class="cla">
						<li>
							<h3 ><a href="/index/news">所有文章</a></h3>
						</li>						
						<li>
							<ul>
								{{with .category}}
								{{range .}}
								<li><a href="/index/news?catid={{.Catid}}">{{.Catname}}</a></li>
								{{end}}
								{{end}}
							</ul>
						</li>
					</ul>
				</div>
			</div>
			
			<div class="box">
				<div class="hd">
					<h3>合作推荐</h3>
				</div>
				<div class="bd">
					<a href="{{.hezuoAd.LinkUrl}}"><img width="260" src="{{.hezuoAd.ImgUrl}}" alt="赞助推荐" /></a>
				</div>
			</div>
			
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
{{template "default/Public/Footer.tpl"}}