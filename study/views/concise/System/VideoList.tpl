{{template "concise/System/Header.tpl"}}

<div id="user">
	<div id="body"> 
		{{template "concise/System/LeftContent.tpl" .userinfo}}
		<div class="right">
			<div class="box"> 

				<div class="bd"> 
					<div class="hd"><h3>视频管理</h3>
					<a class="fancy" href="#AddVideo">添加视频</a></div>
					
					<form action="" method="GET" id="search_form">
					<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:20px;margin-bottom:10px;">
            			<tbody>
						<tr>
            				<td align="right" style="width:60px">视频名称：</td>
	           				<td><input type="text" class="input_short" name="videoname" value="{{.videoname}}" /></td>
							<td align="right" style="width:60px">添加时间：</td>
            				<td><input type="text" class="input_short" name="videoaddtime" value="{{.videoaddtime}}" /></td>
							<td align="center"><button name="submit" class="button" type="submit">搜索</button></td>
            			</tr>
					</table>
					</form>

					<div class="do_4">
						<div class="kclb">
							<table width="100%" border="0" cellpadding="2" cellspacing="0">
								<tr class="top">
									<td align="center" width="50">视频ID</td>
									<td align="left">视频名称</td>
									<td align="center" width="50">时长</td>
									<td align="center" width="100">操作</td>
								</tr>
	
								{{with $field := .videolist}}
								{{range $k, $item := $field}}
								<tr>
									<td align="center">{{$item.Videoid}}</td>
									<td>{{$item.Videoname}}</td>
									<td align="center">{{$item.Duration}}分钟</td>
									<td align="center"> 
										<a class="fancy" href="#showVideo_{{.Videoid}}">查看</a>
										<a class="fancy" href="#editVideo_{{.Videoid}}">编辑</a>
										<a onClick="return confirm('您确定要删除此视频么？')" href="/System/DeleteVideo?videoid={{$item.Videoid}}">删除</a>

										<!-- 视频详情弹出框 start -->
										<div style="display:none;">
											<div class="fancy_modal" style="width: 500px; display: none;" id="showVideo_{{.Videoid}}">
											    <div class="fancy_header">
											         <h3>查看视频详情</h3>
											    </div>
											    <div class="fancy_content" style="min-height:100px;">
											        <div class="fancy_text">
									            		<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:0;">
									            			<tbody><tr>
									            				<td align="right" style="width:80px">视频名称：</td>
									            				<td colspan="5">{{.Videoname}}</td>
									            			</tr>
									            			<tr>
									            				<td align="right">视频介绍：</td>
									            				<td colspan="5">{{.Videointro}}</td>
									            			</tr>
															<tr>
									            				<td align="right">视频标签：</td>
									            				<td colspan="5">{{.Videotag}}</td>
									            			</tr>
															<tr>
																<td align="right">视频地址：</td>
																<td colspan="3">{{if eq .Videourl ""}}还没有添加{{else}}<a target="_blank" href="{{.Videourl}}">下载</a>{{end}}</td>
															</tr>
															<tr>
																<td align="right">添加时间：</td>
																<td colspan="5">{{.Videoaddtime}}</td>
															</tr>
									            		</tbody>
														</table>
									            	</div>
									            </div>
									            <div class="fancy_footer">
										            <a class="fancy_button fancy_button_default fancy_close">关闭</a>
										        </div>
							            	</div>
							            </div><!-- 视频详情弹出框 end -->
										
										<!-- 视频编辑弹出框 start -->
										<div style="display:none;">
											<div class="fancy_modal" style="width: 500px; display: none;" id="editVideo_{{.Videoid}}">
											    <div class="fancy_header">
											         <h3>查看视频详情</h3>
											    </div>
											    <div class="fancy_content" style="min-height:100px;">
											        <div class="fancy_text">
													<form id="editVideo_{{.Videoid}}_form" action="/System/EditVideo" enctype="multipart/form-data" method="POST">
													<input type="hidden" name="videoid" value="{{.Videoid}}" />
									            		<table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:0;">
									            			<tbody><tr>
									            				<td align="right" style="width:80px">视频名称：</td>
									            				<td colspan="5"><input type="text" class="input_middle" name="videoname" value="{{.Videoname}}" ></td>
									            			</tr>
									            			<tr>
									            				<td align="right">视频介绍：</td>
									            				<td colspan="5"><textarea rows="5" cols="70" style="width:98%" name="videointro">{{.Videointro}}</textarea></td>
									            			</tr>
															<tr>
									            				<td align="right">视频标签：</td>
									            				<td colspan="5"><input type="text" class="input_middle" name="videotag" value="{{.Videotag}}" ></td>
									            			</tr>
															<tr>
																<td align="right">视频地址：</td>
																<td colspan="3"><input type="text" class="input_middle" name="videourl" value="{{.Videourl}}" ></td>
															</tr>
									            		</tbody>
														</table>
														</form>
									            	</div>
									            </div>
									            <div class="fancy_footer">
													<a onClick="$('#editVideo_{{.Videoid}}_form').submit();" class="fancy_button fancy_button_success">保存</a>
										            <a class="fancy_button fancy_button_default fancy_close">关闭</a>
										        </div>
							            	</div>
							            </div><!-- 视频编辑弹出框 end -->
										
									</td>
								</tr>
								{{end}}
								{{end}}
							</table>
						</div>
					</div>

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


<!-- 视频添加弹出框 start -->
<div style="display:none;">
	<div class="fancy_modal" style="width: 500px; display: none;" id="AddVideo">
	   <div class="fancy_header">
	        <h3>添加视频</h3>
	   </div>
	   <div class="fancy_content" style="min-height:100px;">
	       <div class="fancy_text">
			<form id="addVideoForm" action="/System/AddVideo" enctype="multipart/form-data" method="POST">
	        <table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:0;">
	         	<tbody>
					<tr>
        				<td align="right" style="width:80px">视频名称：</td>
        				<td colspan="5"><input type="text" class="input_middle" name="videoname" value="" ></td>
        			</tr>
        			<tr>
        				<td align="right">视频介绍：</td>
        				<td colspan="5"><textarea rows="5" cols="70" style="width:98%" name="videointro"></textarea></td>
        			</tr>
				<tr>
        				<td align="right">视频标签：</td>
        				<td colspan="5"><input type="text" class="input_middle" name="videotag" value="" ></td>
        			</tr>
				<tr>
					<td align="right">视频地址：</td>
					<td colspan="3"><input type="text" class="input_middle" name="videourl" value="" ></td>
				</tr>
	        	</tbody>
			</table>
			</form>
         	</div>
         </div>
         <div class="fancy_footer">
			<a onClick="$('#addVideoForm').submit();" class="fancy_button fancy_button_success">保存</a>
         	<a class="fancy_button fancy_button_default fancy_close">关闭</a>
      </div>
    </div>
</div><!-- 视频添加弹出框 end -->

{{template "concise/System/Footer.tpl"}}