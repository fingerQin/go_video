{{template "default/Public/Header.tpl" .}}

<div id="user">
	<div id="body">
		{{template "default/User/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div class="box">
				
				<div class="bd order">
					<div class="hd">
						<h3>充值记录</h3>
					</div>
				
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
					  <tbody>
						<tr class="top">
							<td height="30" width="250">订单号</td>
							<td>金额</td>
							<td>状态</td>
							<td>充值方式</td>
							<td width="130">充值日期</td>
						</tr> 

						{{with .orders}}
						{{range .}}
						<tr style="background-color: rgb(255, 255, 255);">
							<td>{{.Orderno}}</td>
							<td>{{.Money}}</td>
							<td>
								<a href="/user/alipayverify?orderno={{.Orderno}}" target="_blank">
								{{if eq .Status 0}}<span style="color:#F00">失败</span>（点击完成付款）</a>{{else}}支付成功{{end}}
							</td>
							<td>支付宝</td>
							<td>{{.Addtime}}</td>
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
{{template "default/Public/Footer.tpl"}}