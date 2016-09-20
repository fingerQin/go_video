{{template "default/System/Header.tpl" .}}

<div id="user">
	<div id="body"> 
		{{template "default/System/LeftContent.tpl" .userinfo}}
		<div class="right" style="width:760px">
			<div class="box"> 

				<div class="hd"><h3>系统配置</h3></div>
				<div class="bd"> 
					<form id="addNewsForm" action="/system/index" enctype="multipart/form-data" method="POST">
				        <table class="tabsList" width="100%" border="0" cellspacing="1" cellpadding="0" style="margin-top:0;">
				         	<tbody>
								<tr>
			        				<td align="right" style="width:50px">首页广告</td>
			        				<td>
										<div style="margin: 5px 0;">
											<label>图片：<input type="file" name="indexad1_imgurl" class="input_short" style="width:180px;" value="" /></label>
											<label>URL：<input type="text" name="indexad1_url" class="input_short" style="width:300px;" value="{{.IndexOneAdUrl}}" /></label>
											<input type="hidden" name="old_indexad1_imgurl" value="{{.IndexOneAdImgUrl}}" />
											{{if ne .IndexOneAdImgUrl ""}}<a target="_blank" href="{{.IndexOneAdImgUrl}}">浏览图片</a>{{end}}
										</div>
										<div style="margin: 5px 0;">
											<label>图片：<input type="file" name="indexad2_imgurl" class="input_short" style="width:180px;" value="" /></label>
											<label>URL：<input type="text" name="indexad2_url" class="input_short" style="width:300px;" value="{{.IndexTwoAdUrl}}" /></label>
											<input type="hidden" name="old_indexad2_imgurl" value="{{.IndexTwoAdImgUrl}}" />
											{{if ne .IndexTwoAdImgUrl ""}}<a target="_blank" href="{{.IndexTwoAdImgUrl}}">浏览图片</a>{{end}}
										</div>
										<div style="margin: 5px 0;">
											<label>图片：<input type="file" name="indexad3_imgurl" class="input_short" style="width:180px;" value="" /></label>
											<label>URL：<input type="text" name="indexad3_url" class="input_short" style="width:300px;" value="{{.IndexThreeAdUrl}}" /></label>
											<input type="hidden" name="old_indexad3_imgurl" value="{{.IndexThreeAdImgUrl}}" />
											{{if ne .IndexThreeAdImgUrl ""}}<a target="_blank" href="{{.IndexThreeAdImgUrl}}">浏览图片</a>{{end}}
										</div>
										<div style="margin: 5px 0;">
											<label>图片：<input type="file" name="indexad4_imgurl" class="input_short" style="width:180px;" value="" /></label>
											<label>URL：<input type="text" name="indexad4_url" class="input_short" style="width:300px;" value="{{.IndexFourAdUrl}}" /></label>
											<input type="hidden" name="old_indexad4_imgurl" value="{{.IndexFourAdImgUrl}}" />
											{{if ne .IndexFourAdImgUrl ""}}<a target="_blank" href="{{.IndexFourAdImgUrl}}">浏览图片</a>{{end}}
										</div>
										<div style="margin: 5px 0;">
											<label>图片：<input type="file" name="indexad5_imgurl" class="input_short" style="width:180px;" value="" /></label>
											<label>URL：<input type="text" name="indexad5_url" class="input_short" style="width:300px;" value="{{.IndexFiveAdUrl}}" /></label>
											<input type="hidden" name="old_indexad5_imgurl" value="{{.IndexFiveAdImgUrl}}" />
											{{if ne .IndexFiveAdImgUrl ""}}<a target="_blank" href="{{.IndexFiveAdImgUrl}}">浏览图片</a>{{end}}
										</div>
									</td>
			        			</tr>
								<tr>
									<td align="right" style="width:50px">视频广告</td>
			        				<td>
										<div style="margin: 5px 0;">
											<label>图片：<input type="file" name="video_imgurl" class="input_short" style="width:180px;" value="" /></label>
											<label>URL：<input type="text" name="video_url" class="input_short" style="width:300px;" value="{{.videoAd.LinkUrl}}" /></label>
											<input type="hidden" name="old_video_imgurl" value="{{.videoAd.ImgUrl}}" />
											{{if ne .videoAd.ImgUrl ""}}<a target="_blank" href="{{.videoAd.ImgUrl}}">浏览图片</a>{{end}}
										</div>
									</td>
								</tr>
								<tr>
									<td align="right" style="width:50px">赞助广告</td>
			        				<td>
										<div style="margin: 5px 0;">
											<label>图片：<input type="file" name="sponsor_imgurl" class="input_short" style="width:180px;" value="" /></label>
											<label>URL：<input type="text" name="sponsor_url" class="input_short" style="width:300px;" value="{{.sponsorAd.LinkUrl}}" /></label>
											<input type="hidden" name="old_sponsor_imgurl" value="{{.sponsorAd.ImgUrl}}" />
											{{if ne .sponsorAd.ImgUrl ""}}<a target="_blank" href="{{.sponsorAd.ImgUrl}}">浏览图片</a>{{end}}
										</div>
									</td>
								</tr>
								<tr>
									<td align="right" style="width:50px">合作</td>
			        				<td>
										<div style="margin: 5px 0;">
											<label>图片：<input type="file" name="hezuo_imgurl" class="input_short" style="width:180px;" value="" /></label>
											<label>URL：<input type="text" name="hezuo_url" class="input_short" style="width:300px;" value="{{.hezuoAd.LinkUrl}}" /></label>
											<input type="hidden" name="old_hezuo_imgurl" value="{{.hezuoAd.ImgUrl}}" />
											{{if ne .hezuoAd.ImgUrl ""}}<a target="_blank" href="{{.hezuoAd.ImgUrl}}">浏览图片</a>{{end}}
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="6"><button name="submit" class="button" type="submit">保存</button></td>
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

<script type="text/javascript">
$(function(){
	$(".tabsList").on('click', '.addOutline', function(){
        $(this).parent().clone().insertAfter($(this).parent()).find('input').val('');
    });
    
    $(".tabsList").on('click', '.delOutline', function(){
        if($(this).parents('td').find(".delOutline").length > 1){
            $(this).parent().remove();
        }else{
            $(this).parent().find('input').val('');
        }
    });
    
    $(".tabsList").on('click', '.moveUp', function(){
        var the = $(this).parent();
        var prev = the.prev();
        if(prev.length > 0){
            the.insertBefore(prev);
        }
    });

    $(".tabsList").on('click', '.moveDown', function(){
        var the = $(this).parent();
        var next = the.next();
        if(next.length > 0){
            the.insertAfter(next);
        }
    });
});
</script>

{{template "default/System/Footer.tpl"}}