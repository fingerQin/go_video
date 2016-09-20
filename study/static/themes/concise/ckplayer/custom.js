// 视频播放配置
// @date 2013年11月20日
var flashvars={
	f:'http://studyresource.u.qiniudn.com/demo1.flv?token=bbnyISD29weVthTXAOT5lcJ-ftYrNjuAO-m8cnvQ:mLPbQOuWEUhou7D889h3aIWGtGc=:eyJTIjoic3R1ZHlyZXNvdXJjZS51LnFpbml1ZG4uY29tL2RlbW8xLmZsdiIsIkUiOjEzODc2OTkwNDF9&download', // 视频播放地址
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
swfobject.embedSWF('/static/themes/default/ckplayer/ckplayer/ckplayer.swf', 'a1', '928', '500', '10.0.0','/static/themes/default/ckplayer/ckplayer/expressInstall.swf', flashvars, params, attributes);	

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
// 开关灯
var box = new LightBox("flashcontent");
function closelights(){ //关灯
		box.Show();
		$('#video').css("width","928px");
		$('#video').css("height","500px");
		swfobject.getObjectById('ckplayer_a1').width=928;
		swfobject.getObjectById('ckplayer_a1').height=500;
	}
	function openlights(){ //开灯
		box.Close();
		$('#video').css("width","928px");
		$('#video').css("height","500px");
		swfobject.getObjectById('ckplayer_a1').width=928;
		swfobject.getObjectById('ckplayer_a1').height=500;
	}