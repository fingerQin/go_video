{{template "default/Public/Header.tpl" .}}

<div id="body" style="margin-top:-40px;">
    <div class="dtu">		
		<div class="slider-wrap" id="slider-wrap">
	        <div class="slider-img-wrap">
	            <div class="slider-img-l">
	            </div>
	            <div class="slider-img-c">
	                <div class="slider-img-c-inner">
						{{with .indexAds}}
						{{range .}}
					    <a href="{{.LinkUrl}}"><img src="{{.ImgUrl}}" /></a>
						{{end}}
						{{end}}
	                </div>
	            </div>
	            <div class="slider-img-r">
	            </div>
	            <div class="slider-img-mask">
	                <div class="slider-img-mask-l"></div>
	                <div class="slider-img-mask-r"></div>
	            </div>
	        </div>
	    </div>
    </div>

	<div class="nr" style="margin-top:-40px;"><!-- 主页中间主体 -->
		<!-- 左侧主区域 -->
		<div class="left">
			<div id="kc">
				<div class="hd">
					<h3>推荐课程</h3>
				</div>
				<div class="bd">
					<ul>
					{{with .recommendCourse}}
					{{range $k, $v := .}}
						<li {{if eq $k 0}}{{end}}>
							<div class="img"><a href="/index/videoview?courseid={{.Courseid}}">  <img width="190" height="140" src="{{.Courseimg}}" />  </a></div>
							<h4>{{.Coursename}}</h4>
							<!-- <p class="co"><a href="/index/videoview?courseid={{.Courseid}}">{{.Intro}}</a></p> -->
							<p class="zh">课程数：<span>{{.Lessontimes}}</span>讲</p>
							<p class="jk">讲座人：{{.Teacher}}</p>
							<div class="jg">{{.Price}}</div>
						</li>
					{{end}}
					{{end}}
					</ul>
					<div class="clear"></div>
				</div>
			</div>
			
			<div id="kc">
				<div class="hd">
					<h3>最新课程</h3>
				</div>
				<div class="bd">
					<ul>
					{{with .newCourse}}
					{{range $k, $v := .}}
						<li {{if eq $k 0}}{{end}}>
							<div class="img"><a href="/index/videoview?courseid={{.Courseid}}">  <img width="190" height="140" src="{{.Courseimg}}" />  </a></div>
							<h4>{{.Coursename}}</h4>
							<!-- <p class="co"><a href="/index/videoview?courseid={{.Courseid}}">{{.Intro}}</a></p> -->
							<p class="zh">课程数：<span>{{.Lessontimes}}</span>讲</p>
							<p class="jk">讲座人：{{.Teacher}}</p>
							<div class="jg">{{.Price}}</div>
						</li>
					{{end}}
					{{end}}
					</ul>
					<div class="clear"></div>
				</div>
			</div>
			<div id="kc">
				<div class="hd">
					<h3>最热课程</h3>
				</div>
				<div class="bd">
					<ul>
					{{with .hotCourse}}
					{{range $k, $v := .}}
						<li {{if eq $k 0}}{{end}}>
							<div class="img"><a href="/index/videoview?courseid={{.Courseid}}">  <img width="190" height="140" src="{{.Courseimg}}" />  </a></div>
							<h4>{{.Coursename}}</h4>
							<!-- <p class="co"><a href="/index/videoview?courseid={{.Courseid}}">{{.Intro}}</a></p> -->
							<p class="zh">课程数：<span>{{.Lessontimes}}</span>讲</p>
							<p class="jk">讲座人：{{.Teacher}}</p>
							<div class="jg">{{.Price}}</div>
						</li>
					{{end}}
					{{end}}
					</ul>
					<div class="clear"></div>
				</div>
			</div>
		</div><!-- 左侧主区域 end -->
		
		<!-- 右侧副区域 -->
		<div class="right" style="margin-top:50px;">
		
			<div class="box">
				<div class="hd">
					<h3>分享达人</h3>
				</div>
				<div class="bd">
					<iframe width="200" height="80" class="share_self" frameborder="0" scrolling="no" src="http://widget.weibo.com/weiboshow/index.php?language=&amp;width=200&amp;height=80&amp;fansRow=2&amp;ptype=1&amp;speed=0&amp;skin=5&amp;isTitle=0&amp;noborder=0&amp;isWeibo=0&amp;isFans=0&amp;uid=2061773167&amp;verifier=4d7daebc&amp;dpc=1"></iframe>
					技术分享达人，致力于将PHP与Golang技术推向更多的人。同时积极带动更多的技术人分享一线的开发经验。
					<div class="clear"></div>
				</div>
			</div>
			
			<div class="box">
				<div class="hd">
					<h3>赞助推荐</h3>
				</div>
				<div class="bd">
					<a href="{{.sponsorAd.LinkUrl}}"><img width="260" src="{{.sponsorAd.ImgUrl}}" alt="赞助推荐" /></a>
				</div>
			</div>
		
			<div class="box">
				<div class="hd">
					<h3>最新文章</h3>
				</div>
				<div class="bd">
					<ul class="zxdt">
					{{with .bestnewslist}}
					{{range .}}
						<li><a href="/index/show?newsid={{.Newsid}}">{{.Title}}</a></li>
					{{end}}
					{{end}}
					</ul>
					<div class="clear"></div>
				</div>
			</div>
			
			<div class="box">
				<div class="hd">
					<h3>合作推荐</h3>
				</div>
				<div class="bd">
					<a href="{{.hezuoAd.LinkUrl}}"><img width="260" src="{{.hezuoAd.ImgUrl}}" alt="赞助推荐" /></a>
				</div>
			</div>

			<div class="box">
				<div class="hd">
					<h3>最热文章</h3>
				</div>
				<div class="bd">
					<ul class="zxdt">
					{{with .hotnewslist}}
					{{range .}}
						<li><a href="/index/show?newsid={{.Newsid}}">{{.Title}}</a></li>
					{{end}}
					{{end}}
					</ul>
					<div class="clear"></div>
				</div>
			</div>
		</div><!-- 右侧副区域 end -->
	</div><!-- 主页中间主体 end -->
	
	<div class="clear"></div>
	<div class="box" style="margin: 15px auto 0;">
		<div class="hd">
			<h3>友情链接</h3>
		</div>
		<div class="bd">
			<ul class="yqlj">
				<li><a href="http://www.php100.com" target="_blank">PHP100中文网</a></li>
				<li><a href="http://blog.phpha.com" target="_blank">天涯PHP</a></li>
				<li><a href="http://wenda.phpha.com" target="_blank">PHP问答帮助</a></li>
				<li><a href="http://www.phpcxz.com" target="_blank">PHP初学者网站</a></li>
				<li><a href="http://www.phpcms.cn" target="_blank">PHPCMS</a></li>
				<li><a href="http://www.phpchina.com" target="_blank">PHP中国</a></li>
				<li><a href="http://www.qiniu.com/" target="_blank">七牛云存储</a></li>
			</ul>
			<div class="clear"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
	
	// 轮换广告JS代码 start
	$(function() {
            var $wrap = $('#slider-wrap'),
                $imgL = $wrap.find('.slider-img-l'),
                $imgC = $wrap.find('.slider-img-c'),
                $imgCInner = $imgC.find('.slider-img-c-inner'),
                $imgR = $wrap.find('.slider-img-r'),
                $maskL = $wrap.find('.slider-img-mask-l'),
                $maskR = $wrap.find('.slider-img-mask-r');

            var img_w = 583,
                time = 4000,
                speed = 600,
                length = $imgCInner.find('img').length,
                before = length - 1,
                correct = 0,
                after = 1,
                direct = 'right',
                timer = null;

            var srcArr = [];

            $.each($imgCInner.find('img'), function(_key, _img) {
                srcArr.push($(_img).attr('src'));
            })

            $imgCInner.html($imgCInner.html() + $imgCInner.html());

            $imgC.scrollLeft(img_w * correct);

            $_imgL = $('<img>').attr('src', srcArr[before]).appendTo($imgL);
            $_imgR = $('<img>').attr('src', srcArr[after]).appendTo($imgR);

            $maskL.click(function() {
                direct = 'left';
                changeImg(correct - 1)
            })
            $maskR.click(function() {
                direct = 'right';
                changeImg(correct + 1)
            })


            function setTimer() {
                if (time) {
                    timer = setTimeout(function() {
                        changeImg(correct + 1)
                    }, time);
                }

            }

            setTimer()

            function transCorrect(_num) {
                if (_num >= length) {
                    _num = 0;
                } else if (_num < 0) {
                    _num = length - 1;
                }
                return _num;
            }

            function changeImg(_index) {
                clearTimeout(timer);
                correct = transCorrect(_index);
                before = transCorrect(correct - 1);
                after = transCorrect(correct + 1);
                showImg()
            }

            function showImg() {
                $_imgL.attr('src', srcArr[before]);
                $_imgR.attr('src', srcArr[after]);
                activeNav(correct);

                var _sLeft = 0;

                if (direct == 'right') {
                    if (correct == 0) {
                        _sLeft = img_w * (length)
                    } else if (correct == 1) {
                        $imgC.scrollLeft(0);
                        _sLeft = img_w * correct;
                    } else {
                        _sLeft = img_w * correct;
                    }
                } else if (direct == 'left') {
                    if (correct == length - 1) {
                        $imgC.scrollLeft(length * img_w);
                        _sLeft = img_w * (correct);
                    } else if (correct == 1) {
                        _sLeft = img_w * correct;
                    } else {
                        _sLeft = img_w * correct;
                    }
                }

                $imgC.animate({
                    'scrollLeft': _sLeft
                }, speed);
                setTimer();
            }

            showNav()

            function showNav() {
                // init
                var $ul = $('<ul></ul>').addClass('slider-nav'),
                    html = [];

                for (var i = 0; i < length; i++) {
                    html.push('<li><a href="javascript:void(0);"></a></li>');
                }

                $ul.html(html.join('')).appendTo($wrap).find('a');
                activeNav(correct);

                $.each($ul.find('a'), function(_index) {

                    var $this = $(this);

                    $this.click(function() {

                        activeNav(_index);

                        if (_index < correct) {
                            direct = 'left';
                            changeImg(_index)
                        } else if (_index > correct) {
                            direct = 'right';
                            changeImg(_index)
                        }
                    })

                })

            }

            function activeNav(_index) {
                $('.slider-nav a.active').removeClass('active');
                $('.slider-nav a').eq(_index).addClass('active');
            }
        })
		// 轮换广告JS代码 end
	
</script>

{{template "default/Public/Footer.tpl"}}