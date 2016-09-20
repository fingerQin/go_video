{{template "concise/System/Header.tpl"}}

<div id="user">
	<div id="body">
		{{template "concise/System/LeftContent.tpl" .userinfo}}
   		 <div class="right">
         	<div id="note_list">
            	<div class="box">
                	<div class="hd"><h3>我的笔记</h3></div>
                    <div class="bd">
                        <div class="note_list">
                            <ul>
                            	{{with .NoteList}}
								{{range .}}
                                <li>
                               		<div class="top">
                                		<h4><a target="_blank" href="/Index/VideoView?courseid={{.Courseid}}">{{.Coursename}}</a></h4>
                                    	<a onClick="return confirm('您确定要删除么？');" href="/System/DeleteNote?noteid={{.Noteid}}">删除</a> 最近更新：<span>{{.Lasttime}}</span>
										&nbsp;&nbsp;</span>
										</p>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="con">{{.Content}}</div>
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
                    <div class="clear"></div>
                </div>
            </div>
         </div>        
    </div>
</div>
<div class="clear"></div>
{{template "concise/System/Footer.tpl"}}