
<div id="foot">
    <div class="ft">
        <div class="ll">
            <div class="p1 clear">
            <div class="clear"></div>
            </div>
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