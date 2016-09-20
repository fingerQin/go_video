{{template "concise/Public/Header.tpl"}}

<script type="text/javascript" src="/js/offlights.js" charset="utf-8"></script>
<script type="text/javascript">
$(function(){
	$("#gju_an").toggle(
		function(){
			//$("#gju iframe").attr("stc","/index.php/User/note_play/sxx/" + new Date().getTime())
			$(this).attr("class","dk").html("关闭笔记");
			$("#gju").css("display","block")
		},
		function(){
			$(this).attr("class","").html("笔记速记")
			$("#gju").css("display","none")
		}
	)
})
</script>

<div class="H_main">
  	<div class="H_main_bg clearfix">
		<div class="play_top">
			<div class="mbx" style="padding-bottom:20px;">
				<a href="/">首页</a> >> <a href="/Index/VideoList">课程列表</a> >> 
				<a href="/Index/VideoView?courseid={{.course.Courseid}}">{{.course.Coursename}}</a> >>
				{{.video.Videoname}}
			</div>
		
			<div id="flashcontent"></div>
	        <div id="video" style="position:relative;z-index: 100;width:928px;height:500px;"><div id="a1"></div></div>
		</div>
		
		<div class="H_main_l" style="margin-top:30px;">
			<!-- 视频列表 -->
	        <div class="question_list">
	            <div class="title">
	                <h4 class="fl">视频列表</h4>
	                <!--<span class="fr"><a href="/ask/0?status=K">» 更多</a>--></span>
	            </div>
	            <div class="list">
	                <ul>
						{{with $field := .VideoList}}
						{{range $k, $item := $field}}					
						<li>
						<span class="fl"><a href="/Index/VideoPlay?relateid={{$item.Id}}">{{$item.Videoname}}[{{$item.Duration}}分钟]</a></span>
	                   	<em class="fr W_textb"><a href="/Index/VideoPlay?relateid={{$item.Id}}">免费学习</a></em>
						</li>
						{{end}}
						{{end}}
	
	                </ul>
	            </div>
	        </div>
	        <!-- /视频列表 -->
		</div><!-- class H_main_l end -->

		<div class="H_main_r" style="margin-top:20px;">
			<!-- 课程介绍 -->
			<div class="VideoPlay">
	        	<h3>{{.course.Coursename}}</h3>
	            <div class="img">
	                <img style="width:155px" src="{{.course.Courseimg}}" />
	            </div>
	        	<div class="xq">
	                <p class="kc">课程数：<span> {{.course.Lessontimes}} </span>讲</p>
	                <p class="gm">购买数：<span> {{.course.Buytimes}} </span>人</p>
	                <p class="jz">讲座人：<a href="/index.php/Blogs/teacher/teacherid/3">{{.course.Teacher}}</a></p>
	                <p class="rd"> &nbsp;热&nbsp; 度：{{.course.Hits}}</p>
	                <p class="hp" id="star_course_{{.course.Courseid}}"><i></i><i></i><i></i><i></i><i></i><span>0.0</span><b>(0人评价)</b></p>
					<script type="text/javascript">
						var cid = "star_course_{{.course.Courseid}}"
						var star = {{.course.Star}}
						var diff = 5 - star
						var html = ''
						for(i = 1; i <= star; i++)
						{
							html += "<i></i>"
						}
						for(i = 1; i <= diff; i++)
						{
							html += "<i class=\"no\"></i>"
						}
						html += " <span>"+star+".0</span><b>({{.course.Appraise}}人评价)</b>"
						$("#" + cid).empty();
						$("#" + cid).html(html);
					</script>
	            </div>
	        </div>
			<!-- 课程介绍 end -->
		</div><!-- class H_main_r end -->
		
	</div>	
</div>

<!-- 因为Golang会把URL链接在JS里面进行转义。所以，我要放到HTML里面再通过JS获取来解决问题。 -->
<span style="display:none" id="videourl">{{str2html .videourl}}</span>
<script type="text/javascript" src="/static/themes/default/ckplayer/js/offlights.js"></script>
<script type="text/javascript" src="/static/themes/default/ckplayer/ckplayer/ckplayer.js" charset="utf-8"></script>

<script type="text/javascript">
var videourl = encodeURIComponent( $('#videourl').text() );
//var videourl = encodeURIComponent( $('#videourls').text() );

// 视频播放配置
// @date 2013年11月20日
var flashvars={
	f:videourl, // 视频播放地址
	c:0, //是否读取文本配置,0不是，1是
	s:'0',//调用方式，0=普通方法（f=视频地址），1=网址形式,2=xml形式，3=swf形式(s>0时f=网址，配合a来完成对地址的组装)
	i:'/static/Upload/Poster/loadimg3.jpg',//初始图片地址
	d:'/static/Upload/Poster/pause6.1_1.swf|/static/Upload/Poster/pause6.1_2.swf',//暂停时播放的广告
	u:'',//暂停时如果是图片的话，加个链接地址
	l:'/static/Upload/Poster/adv6.1_1.swf',//前置广告，swf/图片/视频，多个用竖线隔开，图片和视频要加链接地址
	v:'80',//默认音量，0-100之间
	e:'3',//视频结束后的动作，0是调用js函数，1是循环播放，2是暂停播放并且不调用广告，3是调用视频推荐列表的插件，4是清除视频流并调用js功能和1差不多，5是暂停播放并且调用暂停广告
	o:'',//当m=1时，可以设置视频的时间，单位，秒
	w:'',//当m=1时，可以设置视频的总字节数
	g:'',//视频直接g秒开始播放
	j:'',//视频提前j秒结束
	};


var params={ bgcolor:'#000000',allowFullScreen:true,allowScriptAccess:'always',wmode:'opaque'};
var attributes={ id:'ckplayer_a1',name:'ckplayer_a1'};
swfobject.embedSWF('/static/themes/default/ckplayer/ckplayer/ckplayer.swf', 'a1', '979', '520', '10.0.0','/static/themes/default/ckplayer/ckplayer/expressInstall.swf', flashvars, params, attributes);	

/*
=================================================================
以下代码并不是播放器里的，只是播放器应用时用到的
=================================================================
*/
function playerstop(){
	//只有当调用视频播放器时设置e=0或4时会有效果
	alert('播放完成');	
}
var _nn=0;//用来计算实时监听的条数的，超过100条记录就要删除，不然会消耗内存
var watt=false;
function ckplayer_status(str){
	_nn+=1;
	if(_nn>200){
		_nn=0;
		document.getElementById('statusvalue').value='';
	}
	document.getElementById('statusvalue').value=str+'\n'+document.getElementById('statusvalue').value;
	if(str=='video:play'){
		if(!watt){
			watt=true;
			setInterval('getstart()',1000);
		}
	}
}
function getstart(){
	var a=swfobject.getObjectById('ckplayer_a1').ckplayer_getstatus();
	var ss='';
	for (var k in a){
		ss+=k+":"+a[k]+'\n';
	}
	document.getElementById('obj').innerHTML=ss;
}
function aboutstr(str,f){//查看str字符里是否有f
	var about=false;
	var strarray=new Array();
	var farray=new Array();
	farray=f.split(",");
	if(str){
		for(var i=0;i<farray.length;i++){
			strarray=str.split(farray[i]);
			if(strarray.length>1){
				about=true;
				break;
			}
		}
	}
	return about;
}
// 跳过广告
function ckadjump(){
	//alert('你点击了跳过广告按钮，注册成为本站会员，可不用观看前置广告');
	swfobject.getObjectById('ckplayer_a1').ckplayer_advunload();
}
</script>

{{template "concise/Public/Footer.tpl"}}