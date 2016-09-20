{{template "default/Public/Header.tpl" .}}

<div id="user">
	<div id="body"> 
		{{template "default/User/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div class="box orderDiv">
				<div class="hd">
					<h3>充值</h3>
				</div>
				<div class="bd" style="padding-bottom:100px;">
					<form name="alipayment" action="/user/alipay" method="post">
						<div class="czym clear">
							<ul>
								<li>
									<p class="p1"><span>*</span>充值金额：</p>
									<p><input size="30" name="money"></p>
									
								</li>
								<li>
									<p class="p1"><span>*</span>备注信息：</p>
									<p><textarea name="remark"></textarea></p>
									<p id="czts" style="color:#F00; clear:both; margin-left:95px;"></p>
								</li>
								<li>
									<div><input type="submit" class="sub" value="确认充值"></div>
								</li>
							</ul>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="clear"></div>

<script type="text/javascript">
$(function(){
	$("input[class='sub']").click(function(){
		var c = $("input[name='money']").val();
		var b = $("textarea[name='remark']").val();
		var zz = /^[1-9]\d*|0.\d*/;
		if(c.length == 0){
			$('#czts').html('请输入充值金额');
			return false;	
		}else{
			$('#czts').html('');
		}
		if(c < 5){
			$('#czts').html('');
			$('#czts').html('亲，充值5元起哦！');
			return false;		
		}else{
			$('#czts').html('');	
		}
		if(zz.test(c) != true){
			$('#czts').html('请正确输入金额');
			return false	
		}else{
			$('#czts').html('');
		}
		if(b.length == 0){
			$('#czts').html('请输入备注');
			return false;
		}
	})
})
</script>

{{template "default/Public/Footer.tpl"}}