{{template "default/Public/Header.tpl" .}}

<script type="text/javascript" src="/js/offlights.js" charset="utf-8"></script>
<script type="text/javascript">
$(function(){
	$("#gju_an").toggle(
		function(){
			//$("#gju iframe").attr("stc","/index.php/user/note_play/sxx/" + new Date().getTime())
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
<div id="gju_an">笔记速记</div>
<div id="gju">
     <iframe scrolling="no" height="100%" width="100%" src="/index.php/user/note_play/id/156" name="inside"></iframe> 
</div>
<div id="play">
<div id="body">
	<div class="nr">
    	<div class="play">
        	<div class="dh">
            	<ul>
                	<li class="in"><a href="/">首页</a></li>
                    <li><a href="/index/videolist">课程列表</a></li>
                    <li><a href="/index/videoview?courseid={{.course.Courseid}}">{{.course.Coursename}}</a></li>
                    <li>{{.video.Videoname}}</li>
                </ul>
                <div class="clear"></div>
            </div>
        	<div class="bfq">
            	<div id="flashcontent"></div>
                <div id="video" style="position:relative;z-index: 100;width:928px;height:500px;"><div id="a1"></div></div>
            </div>
        </div>
        
        <div class="box_1">
        	<div class="kclb">
                <table width="100%" cellspacing="0" cellpadding="2" border="0">
                    <tbody>
					<tr class="top">
                        <td width="425">课时（共{{.course.Lessontimes}}节）</td><td width="60">学习状态</td>
                    </tr>
					<!--
					<tr>
                        <td>
						<p class="p1">L1</p><p class="p2">
						<span>Javascript介绍及应用</span>
                        </p></td>
                        <td class="xxzt">
                        	<span></span>
                        </td>
                    </tr>
					-->

					{{with .VideoList}}
					{{range $k, $item := .}}
					<tr>
                        <td>
							<p class="p1">V:{{$k}}</p><p class="p2">
							<a href="/index/videoplay?courseid={{.Courseid}}&videoid={{.Videoid}}">{{.Videoname}}</a>
                        	</p>
						</td>
                        <td class="xxzt"> 
							<a style="background: url(/static/themes/default/images/mf.jpg) 0 0 no-repeat;" href="/index/videoplay?courseid={{.Courseid}}&videoid={{.Videoid}}"></a> 
						</td>
                    </tr>
					{{end}}
					{{end}}
                    
				</tbody></table>
            </div>
        </div>
        <div style=" float:right;">
        <div class="box_2" style=" float:none;">
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
            <div class="clear"></div>
        </div>
		</div>
        <div class="clear"></div>
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
	i:'',//初始图片地址
	d:'',//暂停时播放的广告
	u:'',//暂停时如果是图片的话，加个链接地址
	l:'{{.VideoAd.ImgUrl}}',//前置广告，swf/图片/视频，多个用竖线隔开，图片和视频要加链接地址
	r:'{{.VideoAd.LinkUrl}}',// 前置广告URL。
	t:'5', // 前置广告播放时长。
	v:'80',//默认音量，0-100之间
	e:'2',//视频结束后的动作，0是调用js函数，1是循环播放，2是暂停播放并且不调用广告，3是调用视频推荐列表的插件，4是清除视频流并调用js功能和1差不多，5是暂停播放并且调用暂停广告
	o:'',//当m=1时，可以设置视频的时间，单位，秒
	w:'',//当m=1时，可以设置视频的总字节数
	g:'',//视频直接g秒开始播放
	j:'',//视频提前j秒结束
	h:'0',//播放http视频流时采用何种拖动方法，=0不使用任意拖动，=1是使用按关键帧，=2是按时间点，=3是自动判断按什么(如果视频格式是.mp4就按关键时间，.flv就按关键帧)，=4也是自动判断(只要包含字符mp4就按mp4来，只要包含字符flv就按flv来)
	};
var params={ bgcolor:'#000000',allowFullScreen:true,allowScriptAccess:'always',wmode:'opaque'};
var attributes={ id:'ckplayer_a1',name:'ckplayer_a1'};
swfobject.embedSWF('/static/themes/default/ckplayer/ckplayer/ckplayer.swf', 'a1', '928', '500', '10.0.0','/static/themes/default/ckplayer/ckplayer/expressInstall.swf', flashvars, params, attributes);	

/*
下面三行是调用html5播放器用到的
var video='视频地址和类型';
var support='支持的平台或浏览器内核名称';
*/
videoAndUrl=videourl+'->video/mp4'
var video=[videoAndUrl];
var support=['iPad','iPhone','ios','android+false','msie10+false'];//默认的在ipad,iphone,ios设备中用html5播放,android,ie10上没有安装flash的也调用html5
CKobject.embedHTML5('video','ckplayer_a1',928,500,video,flashvars,support);
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

</div>

{{template "default/Public/Footer.tpl"}}