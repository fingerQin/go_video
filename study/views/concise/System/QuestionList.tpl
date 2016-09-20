{{template "concise/System/Header.tpl"}}

<div id="user">
	<div id="body"> 
		{{template "concise/System/LeftContent.tpl" .userinfo}}
		<div class="right">
			<div class="box"> 
				<div class="hd"><h3>题库</h3>
				<a class="fancy" href="#addQuestion">添加试题</a></div>
				<div class="bd">			
					
					<form action="" method="GET" id="search_form">
					<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:20px;margin-bottom:10px;">
            			<tbody>
						<tr>
            				<td align="right" style="width:60px">试题题目：</td>
	           				<td><input type="text" class="input_short" name="qtitle" value="{{.qtitle}}" /></td>
							<td align="right" style="width:60px">添加时间：</td>
            				<td><input type="text" class="input_short" name="addtime" value="{{.addtime}}" /></td>
							<td align="right" style="width:60px">类型：</td>
							<td>
								<select name="qtype">
									<option value="">请选择</option>
									<option {{if eq .qtype "1"}}selected="selected"{{end}}>单选</option>
									<option {{if eq .qtype "2"}}selected="selected"{{end}}>多选</option>
									<option {{if eq .qtype "3"}}selected="selected"{{end}}>判断</option>
									<option {{if eq .qtype "4"}}selected="selected"{{end}}>填空</option>
									<option {{if eq .qtype "5"}}selected="selected"{{end}}>解答</option>
									<option {{if eq .qtype "6"}}selected="selected"{{end}}>作文</option>
								</select>
							</td>
							<td align="center"><button name="submit" class="button" type="submit">搜索</button></td>
            			</tr>
					</table>
					</form>
					
					{{with .Question}}
					{{range .}}
					
					<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:20px;">
            			<tbody>
						<tr>
            				<td align="right" style="width:80px">题目ID：</td>
            				<td>{{.Qid}}</td>
							<td align="right" style="width:80px">操作：</td>
            				<td colspan="3">
								<a class="fancy" href="#editQuestion_{{.Qid}}">[编辑]</a>
								<a onClick="return confirm('您确定要删除么？');" href="/System/DeleteQuestion?qid={{.Qid}}">[删除]</a>
							</td>
            			</tr>
            			<tr>
            				<td align="right">题目类型：</td>
            				<td>
								{{if eq .Qtype 1}}单选{{end}}
								{{if eq .Qtype 2}}多选{{end}}
								{{if eq .Qtype 3}}判断{{end}}
								{{if eq .Qtype 4}}填空{{end}}
								{{if eq .Qtype 5}}解答{{end}}
								{{if eq .Qtype 6}}作文{{end}}
							</td>
							<td align="right">显示状态：</td>
            				<td>{{if eq .Display 1}}显示{{else}}隐藏{{end}}</td>
							<td align="right">添加时间：</td>
            				<td>{{.Addtime}}</td>
            			</tr>
						<tr>
							<td align="right" style="width:80px">题目标题：</td>
            				<td colspan="5">{{.Qtitle}}</td>
						</tr>
						<tr>
            				<td align="right">题目选项：</td>
            				<td colspan="5">{{.Qoption}}</td>
            			</tr>
						<tr>
							<td align="right">答案：</td>
							<td colspan="5">{{.Qanswer}}</td>
						</tr>
            			</tbody>
					</table>
					
					<!-- 试题编辑弹出框 start -->
					<div style="display:none;">
						<div class="fancy_modal" style="width: 500px; display: none;" id="editQuestion_{{.Qid}}">
						   <div class="fancy_header">
						        <h3>添加试题</h3>
						   </div>
						   <div class="fancy_content" style="min-height:100px;">
						       <div class="fancy_text">
								<form id="editQuestionForm_{{.Qid}}" action="/System/EditQuestion" enctype="multipart/form-data" method="POST">
						        <table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:0;">
						         	<tbody>
										<tr>
					        				<td align="right" style="width:80px">试题题目：</td>
					        				<td colspan="5"><input type="text" class="input_middle" name="qtitle" value="{{.Qtitle}}" ></td>
					        			</tr>
										<tr>
					        				<td align="right" style="width:80px">试题子标题：</td>
					        				<td colspan="5"><input type="text" class="input_middle" name="qsubtitle" value="{{.Qsubtitle}}" ></td>
					        			</tr>
										<tr>
					        				<td align="right" style="width:80px">题类型类型：</td>
					        				<td colspan="5">
												<select name="qtype">
													<option {{if eq .Qtype 1}}selected="selected"{{end}} value="1">单选</option>
													<option {{if eq .Qtype 2}}selected="selected"{{end}} value="2">多选</option>
													<option {{if eq .Qtype 3}}selected="selected"{{end}} value="3">判断</option>
													<option {{if eq .Qtype 4}}selected="selected"{{end}} value="4">填空</option>
													<option {{if eq .Qtype 5}}selected="selected"{{end}} value="5">解答</option>
													<option {{if eq .Qtype 6}}selected="selected"{{end}} value="6">作文</option>
												</select>
											</td>
					        			</tr>
										<tr>
					        				<td align="right">显示状态：</td>
					        				<td colspan="5">
												<select name="display">
													<option {{if eq .Display 1}}selected="selected"{{end}} value="1">显示</option>
													<option {{if eq .Display 0}}selected="selected"{{end}} value="0">隐藏</option>
												</select>
											</td>
					        			</tr>
					        			<tr>
					        				<td align="right">题目选项：</td>
					        				<td colspan="5"><textarea rows="5" cols="70" style="width:98%" name="qoption">{{.Qoption}}</textarea></td>
					        			</tr>
										<tr>
					        				<td align="right">题目答案：</td>
					        				<td colspan="5"><textarea rows="5" cols="70" style="width:98%" name="qanswer">{{.Qanswer}}</textarea></td>
					        			</tr>
						        	</tbody>
								</table>
								</form>
					         	</div>
					         </div>
					         <div class="fancy_footer">
								<a onClick="$('#editQuestionForm_{{.Qid}}').submit();" class="fancy_button fancy_button_success">保存</a>
					         	<a class="fancy_button fancy_button_default fancy_close">关闭</a>
					      </div>
					    </div>
					</div><!-- 试题编辑弹出框 end -->
					
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