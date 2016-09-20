{{template "concise/System/Header.tpl"}}

<div id="user">
	<div id="body"> 
		{{template "concise/System/LeftContent.tpl" .userinfo}}
		<div class="right">
			<div class="box"> 
				<div class="hd"><h3>文章添加</h3>
				<a href="/System/NewsList">返回列表</a></div>
				<div class="bd"> 
					<form id="addNewsForm" action="/System/AddNews" enctype="multipart/form-data" method="POST">
				        <table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:0;">
				         	<tbody>
								<tr>
			        				<td align="right" style="width:80px">文章标题：</td>
			        				<td colspan="5"><input type="text" class="input_middle" name="title" value="" ></td>
			        			</tr>
								<tr>
			        				<td align="right" style="width:80px">作者：</td>
			        				<td><input type="text" class="input_short" name="author" value="" ></td>
									<td align="right">分类：</td>
									<td colspan="3" width="45%">
										<label>父类</label>
										<select id="parentid">
											<option value="0">请选择</option>
											{{with .catlist}}
											{{range .}}
											<option value="{{.Catid}}">{{.Catname}}</option>
											{{end}}
											{{end}}
										</select>
										<label>子类</label>
										<select name="catid" id="catid">
											<option value="0">请选择</option>
										</select>
									</td>
			        			</tr>
								<tr>
									<td align="right">允许评论：</td>
									<td>
										<select name="iscomment">
											<option value="1">是</option>
											<option value="0">否</option>
										</select>
									</td>
									<td align="right">是否公告：</td>
									<td colspan="3">
										<select name="iscomment">
											<option value="1">是</option>
											<option value="0">否</option>
										</select>
									</td>
								</tr>
								<tr>
									<td align="right">来源：</td>
									<td><input type="text" class="input_short" name="source" value="" /></td>
									<td align="right">显示状态：</td>
									<td>
										<select name="display">
											<option value="1">是</option>
											<option value="0">否</option>
										</select>
									</td>
								</tr>
			        			<tr>
			        				<td align="right">文章摘要：</td>
			        				<td colspan="5"><textarea  style="width:98%" name="intro"></textarea></td>
			        			</tr>
								<tr>
			        				<td align="right">文章内容：</td>
			        				<td colspan="5"><textarea class="kindeditor" rows="8" cols="70" style="width:100%;height:200px;visibility:hidden;" name="content"></textarea></td>
			        			</tr>
								<tr>
									<td></td>
									<td colspan="5"><button name="submit" class="button" type="submit">保存</button></td>
								</tr>
				        	</tbody>
						</table>
					</form>

				<div class="clear"></div>
			</div>
		</div>
	</div>
</div>
<div class="clear"></div>

<link rel="stylesheet" href="/static/themes/default/js/kindeditor/themes/default/default.css">
<script type="text/javascript">

$(function($) {
	$('#parentid').change(function(){
		var parentid = $('#parentid').val()
		if (parentid.length > 0 && parentid != 0 )
		{
			$.ajax({
			    type: "GET",
			    url: "/System/AjaxCategory",
			    data: "parentid=" + parentid,
			    success: function(data){
			    	var html = "<option value=\"\">请选择</option>"
					$.each(data, function(k, v){
						html += "<option value=\"" + v.Catid + "\">" + v.Catname + "</option>"
					});
					$('#catid').empty();
					$('#catid').html(html);
			    }
			});
		}
	});
});

// KindEditor富文本编辑器
KindEditor.ready(function(K) {
	K.create('.kindeditor', {
		cssPath : ['/static/themes/default/js/kindeditor/plugins/code/prettify.css', 'index.css'],
		items : [
			'source', '|', 'bold','italic','underline','fontname','fontsize','forecolor','hilitecolor','justifyleft','justifycenter','justifyright','justifyfull','insertorderedlist','insertunorderedlist','link','image','code','clearhtml'
		]
	});
});
</script>

{{template "concise/System/Footer.tpl"}}