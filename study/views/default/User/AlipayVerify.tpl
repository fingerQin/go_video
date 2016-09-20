{{template "default/Public/Header.tpl" .}}

<div id="user">
	<div id="body"> 
		<div class="box">
			<div class="hd">
				<h3>订单确认</h3>
			</div>
			<div class="bd orderDiv">
				<div class="czym clear">
					<ul>
						<li>
							<p class="p1">订单号：</p>
							<p>{{.order.Orderno}}</p>
						</li>
						<li>
							<p class="p1">付款总金额：</p>
							<p style=" color:#F00;">{{.order.Money}} 元</p>
						</li>
						<li>
						   <p class="p1">订单备注：</p>
							<p style=" width:210px">{{.order.Remark}}</p> 
						</li>
						<li>
							</li>
						<li>
							<div>
								{{str2html .orderHtml}}
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="clear"></div>

<script type="text/javascript">

$(function($) {
	$('#doAlipy').click(function(){
		art.dialog({
			title:'账号充值',
			content:'<div style="width:500px;"><div style="width:400px; margin:0 auto;"> <div style="margin:10px 0;"><img src="/static/themes/default/images/chuangen_logo.jpg"/> </div><div style=" width:400px; margin:30px auto"><a href="/User/UserAlipay"><img src="/static/themes/default/images/cg.png"/></a> &nbsp;&nbsp;<a href="/User/Alipay"><img src="/static/themes/default/images/sb.png"/></a></div></div></div>',
			width:500,
			height:300,
			opacity:0.5,
			drag:true,
			lock:true						
		})
	});
});

</script>

{{template "default/Public/Footer.tpl"}}