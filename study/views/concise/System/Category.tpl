{{template "concise/System/Header.tpl"}}

<div id="user">
	<div id="body"> 
		{{template "concise/System/LeftContent.tpl" .userinfo}}
		<div class="right">
			<div class="box"> 
				<div class="hd"><h3>分类管理</h3>
				<a class="fancy" href="#addCategory">添加分类</a></div>
				<div class="bd">			

					<form action="" method="GET" id="search_form">
					<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:20px;margin-bottom:10px;">
            			<tbody>
						<tr>
            				<td align="right" style="width:60px">分类名称：</td>
	           				<td style="width:350px"><input type="text" class="input_short" name="catname" value="{{.catname}}" /></td>
							<td align="center"><button name="submit" class="button" type="submit">搜索</button></td>
            			</tr>
					</table>
					</form>
					
					<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:20px;">
						<tr>
            				<td align="center" style="width:10%">分类ID</td>
							<td align="center" style="width:55%">分类名称</td>
							<td align="center" style="width:10%">排序</td>
            				<td align="center" style="width:25%">操作</td>
            			</tr>
            			<tbody>
						{{with .category}}
						{{range .}}
						<tr>
            				<td align="center">{{.Catid}}</td>
            				<td align="center">{{.Catname}}</td>
            				<td align="center">{{.Listorder}}</td>
            				<td align="center">
								<a href="/System/AddNews?catid={{.Catid}}">[添加文章]</a>
								<a class="fancy" href="#editCategory_{{.Catid}}">[编辑]</a>
								<a onClick="return confirm('您确定要删除么？');" href="/System/DeleteCategory?newsid={{.Catid}}">[删除]</a>
								
								<!-- 分类编辑弹出框 start -->
								<div style="display:none;">
									<div class="fancy_modal" style="width: 300px; display: none;" id="editCategory_{{.Catid}}">
									   <div class="fancy_header">
											<h3>分类编辑</h3>
									   </div>
									   <div class="fancy_content" style="min-height:100px;">
										   <div class="fancy_text">
											<form id="editCategoryForm_{{.Catid}}" action="/System/EditCategory" enctype="multipart/form-data" method="POST">
											<input type="hidden" name="catid" value="{{.Catid}}" />
											<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:0;">
												<tbody>
													<tr>
														<td align="right" style="width:80px">分类名称：</td>
														<td><input type="text" class="input_middle" name="catname" value="{{.Catname}}" ></td>
													</tr>
													<tr>
														<td align="right" style="width:80px">父分类：</td>
														<td><input type="text" class="input_short" name="parentid" value="{{.Parentid}}" ></td>
													</tr>
													<tr>
														<td align="right">排序：</td>
														<td><input type="text" class="input_small" name="listorder" value="{{.Listorder}}" ></td>
													</tr>
												</tbody>
											</table>
											</form>
											</div>
										 </div>
										 <div class="fancy_footer">
											<a onClick="$('#editCategoryForm_{{.Catid}}').submit();" class="fancy_button fancy_button_success">保存</a>
											<a class="fancy_button fancy_button_default fancy_close">关闭</a>
									  </div>
									</div>
								</div><!-- 试题编辑弹出框 end -->
								
							</td>
            			</tr>
					{{end}}
					{{end}}
					</tbody>
					</table>
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

<!-- 分类添加弹出框 start -->
<div style="display:none;">
	<div class="fancy_modal" style="width: 500px; display: none;" id="addCategory">
	   <div class="fancy_header">
	        <h3>添加分类</h3>
	   </div>
	   <div class="fancy_content" style="min-height:100px;">
	       <div class="fancy_text">
			<form id="addCategoryForm" action="/System/AddCategory" enctype="multipart/form-data" method="POST">
	        <table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:0;">
	         	<tbody>
					<tr>
        				<td align="right" style="width:80px">分类名称：</td>
        				<td><input type="text" class="input_middle" name="catname" value="{{.Catname}}" ></td>
        			</tr>
					<tr>
        				<td align="right" style="width:80px">父分类：</td>
        				<td><input type="text" class="input_short" name="parentid" value="{{.Parentid}}" ></td>
        			</tr>
					<tr>
						<td align="right">排序：</td>
						<td><input type="text" class="input_small" name="listorder" value="{{.Listorder}}" ></td>
					</tr>
	        	</tbody>
			</table>
			</form>
         	</div>
         </div>
         <div class="fancy_footer">
			<a onClick="$('#addCategoryForm').submit();" class="fancy_button fancy_button_success">保存</a>
         	<a class="fancy_button fancy_button_default fancy_close">关闭</a>
      </div>
    </div>
</div><!-- 分类添加弹出框 end -->

{{template "concise/System/Footer.tpl"}}