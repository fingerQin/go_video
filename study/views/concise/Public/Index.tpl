{{template "concise/Public/Header.tpl"}}


<script type="text/javascript">
	// 焦点图滚动。
	$(function(){
		$("#kinMaxShow").kinMaxShow({intervalTime:2, height:200});
	});
</script>

<div class="H_main">
<!--栏目当前状 帮助首页-->
  <div class="H_main_bg clearfix">
		<div class="H_main_l">
			<!--换页头图-->
            <div class="help_picshow clearfix">
				<!-- 广告区域 -->
				<div id="kinMaxShow">
				    <div><a href="/"><img src="/static/themes/concise/images/7834999djw1ebddforymuj20hd05iq4o.jpg" /></a></div>
				    <div><a href="/"><img src="/static/themes/concise/images/7834999djw1ebeirebptzj20hd05it92.jpg" /></a></div>
				    <div><a href="/"><img src="/static/themes/concise/images/7834999djw1e2n3uee07kj.jpg" /></a></div>			    
				    <div><a href="/"><img src="/static/themes/concise/images/7834999djw1e25nqafu9kj.jpg" /></a></div>
				</div>
			</div>
			<!--/换页头图-->

			<div class="help_title"><h2 class="bg_h"><span class="product">推荐课程</span></h2></div>
			<div class="help_slidershow clearfix" id="pl_help_slider">
				<div class="s_left"></div>
				<div class="slider_content" node-type="slider">
					<ul class="clearfix">
					
						{{with .recommendCourse}}
						{{range $k, $v := .}}							
							<li>
								<div class="slider_col">
								<a href="/Index/VideoView?courseid={{.Courseid}}" title="{{.Coursename}}"><img src="{{.Courseimg}}" width="160" height="90" class="slider_img"></a>
								<div class="s_title"><a href="/Index/VideoView?courseid={{.Courseid}}" title="{{.Coursename}}">{{.Coursename}}</a></div>
								</div>
							</li>
						{{end}}
						{{end}}
					
						{{with .hotCourse}}
						{{range $k, $v := .}}							
							<li>
								<div class="slider_col">
								<a href="/Index/VideoView?courseid={{.Courseid}}" title="{{.Coursename}}" target="_blank"><img src="{{.Courseimg}}" width="160" height="90" class="slider_img"></a>
								<div class="s_title"><a href="/Index/VideoView?courseid={{.Courseid}}" title="{{.Coursename}}"  target="_blank">{{.Coursename}}</a></div>
								</div>
							</li>
						{{end}}
						{{end}}
					</ul>
				</div>
				<div class="s_right"></div>
			</div>
			
			<div class="help_title"><h2 class="bg_h"><span class="hotque">热点问题</span></h2></div>
			
			<div class="hot_que_list">
				<div class="help_conlist clearfix">
					<ul class="havelf">
		               <li><span class="sorts W_linkb"><a href="/faq/q/1973">[活动专区]</a></span><em><a href="/faq/q/1973/15848#15848">如果他们都是微博控之雷神篇</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1973">[活动专区]</a></span><em><a href="/faq/q/1973/15977#15977">“好久没____”2014跨年有奖活动</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1576">[绑定手机]</a></span><em><a href="/faq/q/1576/15744#15744">为何无法更改或解除手机绑定？</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/201">[个人资料]</a></span><em><a href="/faq/q/201/15041#15041">雅虎邮箱注册用户更换微博登录名流程</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/225">[密码]</a></span><em><a href="/faq/q/225/12505#12505">怎样提高帐号安全?</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1582">[微盾]</a></span><em><a href="/faq/q/1582/13651#13651">什么是微盾?微盾有何作用？</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1286">[修改昵称]</a></span><em><a href="/faq/q/1286/393#393">企业认证用户是否可以修改昵称？</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1572">[后续服务]</a></span><em><a href="/faq/q/1572/12604#12604">想申请V认证，如何撤销微博达人？</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1565">[会员特权]</a></span><em><a href="/faq/q/1565/13523#13523">微博会员特权介绍</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1582">[微盾]</a></span><em><a href="/faq/q/1582/13654#13654">微盾如何通过网页绑定帐号？</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1576">[绑定手机]</a></span><em><a href="/faq/q/1576/329#329">手机如何绑定？</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1573">[认证申请]</a></span><em><a href="/faq/q/1573/37#37">如何申请个人认证？</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1564">[开通会员]</a></span><em><a href="/faq/q/1564/13480#13480">如何开通微博会员？</a></em></li>
		              <li><span class="sorts W_linkb"><a href="/faq/q/1261">[微博帮助]</a></span><em><a href="/faq/q/1261/14337#14337">如何领取“悦分享”勋章？</a></em></li>
        			</ul>
				</div>
			</div>
		</div>
		

		<div class="H_main_r">
		
			<!--已登录 用户信息-->
			<!-- 自助服务登录状态下无登录者信息 -->
			<div class="user_info">
			    <dl class="clearfix">
					<iframe width="200" height="80" class="share_self" frameborder="0" scrolling="no" src="http://widget.weibo.com/weiboshow/index.php?language=&amp;width=200&amp;height=80&amp;fansRow=2&amp;ptype=1&amp;speed=0&amp;skin=5&amp;isTitle=0&amp;noborder=0&amp;isWeibo=0&amp;isFans=0&amp;uid=2061773167&amp;verifier=4d7daebc&amp;dpc=1"></iframe>
				</dl>
			    <ul class="data_num_log clearfix">
			    <li><a href="/uq" class="W_emplinkb"><em>0</em>客服回复</a></li>
			    <li><a href="http://weiwen.wenwo.com/question/myquestions" target="_blank"><em>0</em>互助提问</a></li>
			    <li><a href="http://weiwen.wenwo.com/question/myanswered" target="_blank"><em>0</em>互助回答</a></li>
			    <li class="last"><a href="http://weiwen.weibo.com/sinahelp/apply" target="_blank"><em>10</em>等我回答</a></li>
			    </ul>
			</div>
			<!--/已登录 用户信息-->
	          
			<div class="help_title"><h2 class="bg_s">最新文章</h2></div>
			<div class="help_conlist latest_links_box clearfix" style="height:200px;">
				<ul class="sidebar_txt">
					{{with .bestnewslist}}
					{{range $k, $v := .}}
						<li><a title="{{.Title}}" href="/Index/Show?newsid={{.Newsid}}">{{.Title}}</a></li>
					{{end}}
					{{end}}
					</ul>
				</ul>				
			</div>
			
			<div class="help_title"><h2 class="bg_s">最热文章</h2></div>
			<div class="help_conlist latest_links_box clearfix" style="height:200px;">				
				<ul class="sidebar_txt">
					{{with .hotnewslist}}
					{{range $k, $v := .}}
						<li><a title="{{.Title}}" href="/Index/Show?newsid={{.Newsid}}">{{.Title}}</a></li>
					{{end}}
					{{end}}
					</ul>
				</ul>				
			</div>

			<div class="help_title"><h2 class="bg_s">服务向导</h2></div>
			<!--自助服务为当前选项-->
			<div class="help_tab">
				<div class="tab_list_con clearfix">
					<ul class="tab_list">
						<li class="cur"><a href="javascript:void(0);">自助服务</a></li>
						<li><a href="javascript:void(0);">人工服务</a></li>
					</ul>
				</div>
				<div class="tab_b">
					<div class="tab_con clearfix">
						<div class="list_l"><span class="icon_offical_acc"></span></div>
						<div class="list_r">
							<p class="tit W_f14"><a href="http://e.weibo.com/weibokefu"  target="_blank">官方帐号</a></p>
							 <ul class="link_list">
								<li><a href="http://e.weibo.com/weibokefu" target="_blank">@微博客服</a></li>
							 </ul>
						</div>
					</div>
					<div class="tab_con clearfix">
						<div class="list_l"><span class="icon_service_ask"></span></div>
						<div class="list_r">
							<p class="tit W_f14"><a href="/self/query">向客服提问</a></p>
							<p>你将收到客服人员的回复通知</p>
						</div>
					</div>
					<div class="tab_con clearfix">
						<div class="list_l"><span class="icon_speech_ser"></span></div>
						<div class="list_r">
							<p class="tit W_f14"><a href="/phone/person">语音服务</a></p>
							<ul class="link_txt_list">
								<li><p>4000 960 960个人<a href="/faq/q/1261/15718#15718" class="l_space">查看流程</a></p></li>
								<li><p>4000 980 980企业<a href="/faq/q/1261/15719#15719" class="l_space">查看流程</a></p></li>
							 </ul>
						</div>
					</div>
				</div>
			</div>
			<!--自助服务为当前选项-->
			<!-- 提个建议 -->
        <div class="M_suggest"><a href="javascript:void(0);" class="h_suggetBtn"  action-type="h_suggest"
       suda-uatrack="key=tblog_help&value=s_suggest" title="#微建议#提个建议">#微建议#提个建议</a></div>
        <!-- 提个建议 --->
		</div>
		
  </div>
</div>


{{template "concise/Public/Footer.tpl"}}