<script type="text/javascript">
//图片淡隐淡现
var defaultOpts ={ interval:60000, fadeInTime:800, fadeOutTime:700 };
	var _titles = $("ul.slide-txt li");
	var _titles_bg = $("ul.op li");
	var _bodies = $("ul.slide-pic li");
	var _count = _titles.length;
	var _current = 0;
	var _intervalID = null;
	
	var stop = function(){
		window.clearInterval(_intervalID);
	};
	
	var slide = function(opts){
		if (opts){
			_current = opts.current || 0;
		} else{
			_current = (_current >= (_count - 1)) ? 0 :(++_current);
		};
		_bodies.filter(":visible").fadeOut(defaultOpts.fadeOutTime, function(){
			_bodies.eq(_current).fadeIn(defaultOpts.fadeInTime);
			_bodies.removeClass("current").eq(_current).addClass("current");
		});
		_titles.removeClass("current").eq(_current).addClass("current");
		_titles_bg.removeClass("current").eq(_current).addClass("current");
	}; 
	
	var go = function(){
		stop();
		_intervalID = window.setInterval(function(){
			slide();
		}, defaultOpts.interval);
	}; 
	
	var itemMouseOver = function(target, items){
		stop();
		var i = $.inArray(target, items);
		slide({ current:i });
	};
	
	_titles.hover(function(){
		if($(this).attr('class')!='current'){
			itemMouseOver(this, _titles);
		}else{
			stop();
		}
	}, go);
	_bodies.hover(stop, go);
	go();
</script>

<div id="foot">
    <div class="ft">
        <div class="ll">
            <div class="p1 clear">
			<span><!-- Baidu Button BEGIN -->
			<div id="bdshare" class="bdshare_t bds_tools_32 get-codes-bdshare">
			<a class="bds_qzone"></a>
			<a class="bds_tsina"></a>
			<a class="bds_tqq"></a>
			<a class="bds_renren"></a>
			<a class="bds_t163"></a>
			<span class="bds_more"></span>
			<a class="shareCount"></a>
			</div>
			<script type="text/javascript" id="bdshare_js" data="type=tools&amp;uid=541572" ></script>
			<script type="text/javascript" id="bdshell_js"></script>
			<script type="text/javascript">
			document.getElementById("bdshell_js").src = "http://bdimg.share.baidu.com/static/js/shell_v2.js?cdnversion=" + Math.ceil(new Date()/3600000)
			</script>
			<!-- Baidu Button END --></span>
            <div class="clear"></div>
            </div>
            <div class="p2">2013 lesson100.com&nbsp;&nbsp;<a href="">关于</a>&nbsp;&nbsp;<a href="">合作</a>&nbsp;&nbsp;<a href="">投资</a>&nbsp;&nbsp;<a target=blank href="">在线客服</a></div>
        </div>
        <div class="rr">
            <p class="p1"><a href="" target="_blank"><img width="60" src="/static/themes/default/images/100.jpg"/></a></p>
            <div class="p2">有问题、建议，欢迎给我留言！<br />我是“PHP云课堂” 寒冰</div>
            <div class="clear"></div>
        </div>
        <div class="clear"></div>
    </div>
    </div>
</body>

<link type="text/css" rel="stylesheet" href="/static/themes/default/js/fancybox/jquery.fancybox.css" />
<link type="text/css" rel="stylesheet" href="/static/themes/default/js/fancybox/fancy-modal.css" />
<script type="text/javascript" src="/static/themes/default/js/fancybox/jquery.fancybox.pack.js"></script>
<script src="/static/themes/default/js/jquery.cookie.min.js"></script>
<script type="text/javascript">
  // 左边导航
  (function($){ 
 	// 自定义弹出层
    $('.fancy').click(function(){
        var $this = $(this);
        var $modal = $($this.attr('href'));
        
        $.fancybox($modal, {
            closeBtn: false,
            padding: 0
        });
        
        $('.fancy_close').click(function() {
            $.fancybox.close(true);
        });
        return false;
    });
    
  })(jQuery);
</script>

</html>