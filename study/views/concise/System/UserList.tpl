{{template "concise/System/Header.tpl"}}

<div id="user">
	<div id="body"> 
		{{template "concise/System/LeftContent.tpl" .userinfo}}
		<div class="right">
			<div class="box"> 
				<div class="hd"><h3>用户管理</h3></div>
				<div class="bd">
					<form action="" method="GET" id="search_form">
					<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:20px;">
            			<tbody>
						<tr>
            				<td align="right" style="width:60px">用户ID：</td>
	           				<td><input type="text" class="input_small" name="userid" value="{{.userid}}" /></td>
							<td align="right" style="width:60px">用户名：</td>
            				<td><input type="text" class="input_short" name="username" value="{{.username}}" /></td>
							<td align="right" style="width:60px">昵称：</td>
            				<td><input type="text" class="input_short" name="realname" value="{{.realname}}" /></td>
							<td><button name="submit" class="button" type="submit">搜索</button></td>
            			</tr>
					</table>
					</form>
					
					{{with .userlist}}
					{{range .}}
					
					<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:20px;">
            			<tbody>
						<tr>
            				<td align="right" style="width:60px">用户ID：</td>
            				<td style="width:80px">{{.Userid}}</td>
							<td align="right">用户名：</td>
            				<td>{{.Username}}</td>
							<td align="right">昵称：</td>
            				<td>{{.Realname}}</td>
							<td align="right">操作：</td>
            				<td style="width:35px;">
								<a onClick="return confirm('您确定要删除么？');" href="/System/DeleteUser?userid={{.Userid}}">[删除]</a>
							</td>
            			</tr>
            			<tr>
            				<td align="right">性别：</td>
            				<td>
								{{if eq .Sex 1}}男{{end}}
								{{if eq .Sex 2}}女{{end}}
							</td>
							<td align="right">邮箱激活：</td>
            				<td>{{if eq .Isactive 1}}是{{else}}否{{end}}</td>
							<td align="right">Email：</td>
            				<td colspan="3">{{.Email}}</td>
            			</tr>
						<tr>
							<td align="right">会员等级：</td>
            				<td>{{.Level}}</td>
							<td align="right">注册时间：</td>
            				<td colspan="2">{{.Regtime}}</td>
							<td align="right">最后登录：</td>
            				<td colspan="2">{{.Regtime}}</td>
						</tr>
						<tr>
							<td align="right">学分：</td>
            				<td>{{.Point}}</td>
							<td align="right">金币：</td>
            				<td>{{.Gold}}</td>
							<td align="right">现金：</td>
            				<td>{{.Cash}}</td>
							<td align="right">登录次数：</td>
            				<td>{{.LoginCount}}</td>
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

<!-- 试题添加弹出框 start -->
<div style="display:none;">
	<div class="fancy_modal" style="width: 500px; display: none;" id="addQuestion">
	   <div class="fancy_header">
	        <h3>添加试题</h3>
	   </div>
	   <div class="fancy_content" style="min-height:100px;">
	       <div class="fancy_text">
			<form id="addQuestionForm" action="/System/AddQuestion" enctype="multipart/form-data" method="POST">
	        <table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:0;">
	         	<tbody>
					<tr>
        				<td align="right" style="width:80px">试题题目：</td>
        				<td colspan="5"><input type="text" class="input_middle" name="qtitle" value="" ></td>
        			</tr>
					<tr>
        				<td align="right" style="width:80px">试题子标题：</td>
        				<td colspan="5"><input type="text" class="input_middle" name="qsubtitle" value="" ></td>
        			</tr>
					<tr>
        				<td align="right" style="width:80px">题类型类型：</td>
        				<td colspan="5">
							<select name="qtype">
								<option value="1">单选</option>
								<option value="2">多选</option>
								<option value="3">判断</option>
								<option value="4">填空</option>
								<option value="5">解答</option>
								<option value="6">作文</option>
							</select>
						</td>
        			</tr>
					<tr>
        				<td align="right">显示状态：</td>
        				<td colspan="5">
							<select name="display">
								<option value="1">显示</option>
								<option value="0">隐藏</option>
							</select>
						</td>
        			</tr>
        			<tr>
        				<td align="right">题目选项：</td>
        				<td colspan="5"><textarea rows="5" cols="70" style="width:98%" name="qoption"></textarea></td>
        			</tr>
					<tr>
        				<td align="right">题目答案：</td>
        				<td colspan="5"><textarea rows="5" cols="70" style="width:98%" name="qanswer"></textarea></td>
        			</tr>
	        	</tbody>
			</table>
			</form>
         	</div>
         </div>
         <div class="fancy_footer">
			<a onClick="$('#addQuestionForm').submit();" class="fancy_button fancy_button_success">保存</a>
         	<a class="fancy_button fancy_button_default fancy_close">关闭</a>
      </div>
    </div>
</div><!-- 试题添加弹出框 end -->

{{template "concise/System/Footer.tpl"}}