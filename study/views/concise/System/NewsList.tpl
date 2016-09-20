{{template "concise/System/Header.tpl"}}

<div id="user">
	<div id="body"> 
		{{template "concise/System/LeftContent.tpl" .userinfo}}
		<div class="right">
			<div class="box"> 
				<div class="hd"><h3>文章管理</h3>
				<a href="/System/AddNews">添加文章</a></div>
				<div class="bd">			
					
					<form action="" method="GET" id="search_form">
					<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:20px;margin-bottom:10px;">
            			<tbody>
						<tr>
            				<td align="right" style="width:60px">文章标题：</td>
	           				<td><input type="text" class="input_short" name="title" value="{{.title}}" /></td>
							<td align="right" style="width:60px">是否公告：</td>
            				<td>
								<select name="isnotice">
									<option value="">请选择</option>
									<option {{if eq .isnotice "0"}}selected="selected"{{end}} value="0">否</option>
									<option {{if eq .isnotice "1"}}selected="selected"{{end}} value="1">是</option>
								</select>
							</td>
							<td align="right" style="width:60px">允许评论：</td>
							<td>
								<select name="iscomment">
									<option value="">请选择</option>
									<option {{if eq .iscomment "0"}}selected="selected"{{end}} value="0">否</option>
									<option {{if eq .iscomment "1"}}selected="selected"{{end}} value="1">是</option>
								</select>
							</td>
							<td align="center"><button name="submit" class="button" type="submit">搜索</button></td>
            			</tr>
					</table>
					</form>
					
					{{with .newslist}}
					{{range .}}
					<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:20px;">
            			<tbody>
						<tr>
            				<td align="right" style="width:80px">文章ID：</td>
            				<td>{{.Newsid}}</td>
							<td align="right" style="width:80px">作者：</td>
							<td>{{.Author}}</td>
							<td align="right" style="width:80px">操作：</td>
            				<td>
								<a href="/System/EditNews?newsid={{.Newsid}}">[编辑]</a>
								<a onClick="return confirm('您确定要删除么？');" href="/System/DeleteNews?newsid={{.Newsid}}">[删除]</a>
							</td>
            			</tr>
						<tr>
							<td align="right" style="width:80px">标题：</td>
            				<td colspan="5"><a target="_blank" href="/Index/Show?newsid={{.Newsid}}">{{.Title}}</a></td>
						</tr>
						<tr>
							<td align="right" style="width:80px">显示状态：</td>
            				<td>{{if eq .Display 1}}显示{{else}}隐藏{{end}}</td>
							<td align="right" style="width:80px">浏览次数：</td>
            				<td>{{.Hits}}</td>
							<td align="right" style="width:80px">添加人：</td>
            				<td>{{.Username}}--{{.Realname}}</td>
						</tr>
            			<tr>
            				<td align="right">允许评论：</td>
            				<td>{{if eq .Iscomment 1}}是{{else}}否{{end}}</td>
							<td align="right">是否公告：</td>
            				<td>{{if eq .Isnotice 1}}是{{else}}否{{end}}</td>
							<td align="right">添加时间：</td>
            				<td>{{.Addtime}}</td>
            			</tr>
						<tr>
							<td align="right" style="width:80px">文章介绍：</td>
            				<td colspan="5">{{.Intro}}</td>
						</tr>
            			</tbody>
					</table>
					{{end}}
					{{end}}
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
<div class="clear"></div>


{{template "concise/System/Footer.tpl"}}