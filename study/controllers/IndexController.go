// 前台。
// -- 首页、新闻、关于、联系、留言
// @author 寒冰[qljs888@163.com]
// @date 2013年11月24日

package controllers

import (
	"crypto/md5"
	"encoding/gob"
	"encoding/json"
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
	. "github.com/qiniu/api/conf"
	"github.com/qiniu/api/rs"
	"io"

	//"log"
	"math"
	"strconv"
	"study/models"
	"study/services"
	"time"
)

// 七牛云存储空间域名
var QN_DOMAIN string = ""

func init() {
	// 七牛云存储
	ACCESS_KEY = beego.AppConfig.String("ACCESS_KEY")
	SECRET_KEY = beego.AppConfig.String("SECRET_KEY")
	QN_DOMAIN = beego.AppConfig.String("QN_DOMAIN")
}

type IndexController struct {
	CommonController
}

// 首页。
func (this *IndexController) Index() {

	type Person struct {
		Id   int
		Name string
	}
	gob.Register(Person{})
	if services.AppCache.IsExist("obj") {
		element := services.AppCache.Get("obj")
		if value, ok := element.(Person); ok {
			fmt.Println(value)
		}
	} else {
		pp := Person{1, "admin"}
		err := services.AppCache.Put("obj", pp, 3600)
		fmt.Println(err)
	}

	// 最新课程。
	o := orm.NewOrm()
	var newCourse []models.VCourse
	sql := "SELECT * FROM v_course WHERE display = 1 ORDER BY courseid DESC LIMIT 6"
	o.Raw(sql).QueryRows(&newCourse)

	// 推荐课程。
	var recommendCourse []models.VCourse
	sql = "SELECT * FROM v_course WHERE recommend = 1 AND display = 1 ORDER BY courseid DESC LIMIT 3"
	o.Raw(sql).QueryRows(&recommendCourse)

	// 最热课程。
	var hotCourse []models.VCourse
	sql = "SELECT * FROM v_course WHERE display = 1 ORDER BY hits DESC LIMIT 6"
	o.Raw(sql).QueryRows(&hotCourse)

	// 最新文章。
	var bestnewslist []models.VNews
	sql = "SELECT * FROM v_news ORDER BY newsid DESC LIMIT 9"
	o.Raw(sql).QueryRows(&bestnewslist)

	// 最热文章。
	var hotnewslist []models.VNews
	sql = "SELECT * FROM v_news ORDER BY hits DESC LIMIT 9 "
	o.Raw(sql).QueryRows(&hotnewslist)

	// 读取轮换广告。
	var adConfig models.VConfig
	o.Raw("SELECT * FROM v_config WHERE ckey = ?", "index_ad").QueryRow(&adConfig)
	var indexAds []services.IndexAd
	json.Unmarshal([]byte(adConfig.Cval), &indexAds)

	// 读取赞助广告。
	var sponsorConfig models.VConfig
	o.Raw("SELECT * FROM v_config WHERE ckey = ?", "sponsor_ad").QueryRow(&sponsorConfig)
	var sponsorAd services.IndexAd
	json.Unmarshal([]byte(sponsorConfig.Cval), &sponsorAd)

	// 读取合作广告。
	var hezuoConfig models.VConfig
	o.Raw("SELECT * FROM v_config WHERE ckey = ?", "cooperation_ad").QueryRow(&hezuoConfig)
	var hezuoAd services.IndexAd
	json.Unmarshal([]byte(hezuoConfig.Cval), &hezuoAd)

	this.Data["indexAds"] = indexAds
	this.Data["hotnewslist"] = hotnewslist
	this.Data["bestnewslist"] = bestnewslist
	this.Data["recommendCourse"] = recommendCourse
	this.Data["hotCourse"] = hotCourse
	this.Data["newCourse"] = newCourse
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.Data["sponsorAd"] = sponsorAd
	this.Data["hezuoAd"] = hezuoAd
	this.TplNames = AppTheme + "/Public/Index.tpl"
}

// 新闻。
func (this *IndexController) News() {
	// 搜索参数。
	title := this.GetString("title")
	catid := this.GetString("catid")
	this.Data["title"] = title
	this.Data["catid"] = catid

	where := " 1 "
	if len(title) > 0 {
		where += " AND title LIKE ? "
		title = "%" + title + "%"
	} else {
		where += " AND ? "
		title = "1"
	}

	if len(catid) > 0 {
		where += " AND catid = ? "
	} else {
		where += " AND ? "
		catid = "1"
	}

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_news WHERE " + where
	o.Raw(countSql, title, catid).QueryRow(&CountData)
	total := CountData.Count

	// 分页处理
	page, _ := this.GetInt("page") // 当前页。
	var OPage services.Page
	OPage.Request = this.Ctx.Request
	OPage.PageNumber = page
	OPage.Total = total
	OPage.PageSize = 5
	OPage.Page()

	// 取列表数。
	var newslist []services.NewsInfo
	sql := "SELECT a.newsid,a.catid,a.title,b.userid,b.username,b.realname,a.author,a.lasttime,a.addtime,a.iscomment,a.isnotice,a.hits,a.display,a.source,a.intro,a.content,a.star,a.appraise" +
		" FROM v_news AS a LEFT JOIN v_user AS b ON(a.userid=b.userid) WHERE " + where + " ORDER BY newsid DESC LIMIT ?, ? "
	o.Raw(sql, title, catid, OPage.Offset, OPage.Count).QueryRows(&newslist)

	// 读取分类。
	var category []models.VCategory
	sql = "SELECT * FROM v_category WHERE parentid != 0 ORDER BY catid ASC, listorder ASC"
	o.Raw(sql).QueryRows(&category)

	// 最新文章。
	var bestnewslist []models.VNews
	sql = "SELECT * FROM v_news ORDER BY newsid DESC LIMIT 9"
	o.Raw(sql).QueryRows(&bestnewslist)

	// 最热文章。
	var hotnewslist []models.VNews
	sql = "SELECT * FROM v_news ORDER BY hits DESC LIMIT 9 "
	o.Raw(sql).QueryRows(&hotnewslist)

	// 读取合作广告。
	var hezuoConfig models.VConfig
	o.Raw("SELECT * FROM v_config WHERE ckey = ?", "cooperation_ad").QueryRow(&hezuoConfig)
	var hezuoAd services.IndexAd
	json.Unmarshal([]byte(hezuoConfig.Cval), &hezuoAd)

	this.Data["hotnewslist"] = hotnewslist
	this.Data["bestnewslist"] = bestnewslist
	this.Data["category"] = category
	this.Data["newslist"] = newslist
	this.Data["Page"] = OPage

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.Data["hezuoAd"] = hezuoAd
	this.TplNames = AppTheme + "/Public/News.tpl"
}

// 新闻详情。
func (this *IndexController) Show() {
	newsid, _ := this.GetInt("newsid")
	if newsid <= 0 {
		this.Tip("文章不存在或已经被删除", 1, "/system/index")
	}
	o := orm.NewOrm()
	var news services.NewsInfo
	sql := "SELECT a.newsid,a.catid,a.title,b.userid,b.username,b.realname,a.author,a.lasttime,a.addtime,a.iscomment,a.isnotice,a.hits,a.display,a.source,a.intro,a.content,a.star,a.appraise " +
		"FROM v_news AS a LEFT JOIN v_user AS b ON(a.userid=b.userid) WHERE a.newsid = ? "
	o.Raw(sql, newsid).QueryRow(&news)
	if news.Newsid == 0 {
		this.Tip("文章不存在或已经被删除", 1, "/system/news")
	}

	// 更新阅读次数。
	o.Raw("UPDATE v_news SET hits=hits+1 WHERE newsid = ? LIMIT 1", newsid).Exec()

	// 取评论内容。
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_comment WHERE typeid = ? AND relateid = ? "
	o.Raw(countSql, 5, newsid).QueryRow(&CountData)
	total := CountData.Count

	// 分页初始化。
	var OPage services.Page
	// 分页处理
	page, _ := this.GetInt("page") // 当前页。
	OPage.Request = this.Ctx.Request
	OPage.PageNumber = page
	OPage.Total = total
	OPage.PageSize = 15
	OPage.Page()

	// 与课程留言共同使用一个CommentInfo结构体。
	var commlist []services.CommentInfo
	// 取列表数。
	sql = "SELECT a.commentid,b.username,b.realname,b.avatar,b.sex,a.userid,a.relateid,b.level,a.addtime,a.content,a.Star " +
		"FROM v_comment AS a LEFT JOIN v_user AS b ON(a.userid=b.userid) WHERE typeid = ? AND relateid = ? ORDER BY a.commentid DESC LIMIT ?, ? "
	o.Raw(sql, 5, newsid, OPage.Offset, OPage.Count).QueryRows(&commlist)

	// 最新文章。
	var bestnewslist []models.VNews
	sql = "SELECT * FROM v_news ORDER BY newsid DESC LIMIT 9"
	o.Raw(sql).QueryRows(&bestnewslist)

	// 最热文章。
	var hotnewslist []models.VNews
	sql = "SELECT * FROM v_news ORDER BY hits DESC LIMIT 9 "
	o.Raw(sql).QueryRows(&hotnewslist)

	this.Data["hotnewslist"] = hotnewslist
	this.Data["bestnewslist"] = bestnewslist
	this.Data["commlist"] = commlist
	this.Data["Page"] = OPage
	this.Data["news"] = news

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/Public/Show.tpl"
}

// 关于。
func (this *IndexController) About() {
	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/Public/About.tpl"
}

// 联系。
func (this *IndexController) Contact() {
	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/Public/Contact.tpl"
}

// 广告合作。
func (this *IndexController) Cooperation() {
	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/Public/Cooperation.tpl"
}

// 留言。
func (this *IndexController) Feedback() {
	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/Public/Feedback.tpl"
}

// 视频播放页面。
// -- 1、判断是否登录。否则不予以看视频。
func (this *IndexController) VideoPlay() {
	userdata := this.GetSession("userid")
	if userdata == nil {
		this.Tip("请先登录", 1, "/index/login")
	}
	userid := userdata.(int64)

	videoid, _ := this.GetInt("videoid")
	courseid, _ := this.GetInt("courseid")
	if videoid <= 0 {
		this.Tip("视频id有误", 3, "/")
	}
	if courseid <= 0 {
		this.Tip("课程id有误", 3, "/")
	}

	o := orm.NewOrm()

	// 判断用户是否购买此课程。
	var userCourse models.VUserCourse
	o.Raw("SELECT * FROM v_user_course WHERE courseid = ? AND userid = ? LIMIT 1", courseid, userid).QueryRow(&userCourse)
	if userCourse.Ucid == 0 {
		this.Tip("您未购买该课程，请购买!", 3, "")
	}

	// 读取要播放的视频信息。
	var video models.VVideo
	sql := "SELECT * FROM v_video WHERE videoid = ? AND courseid = ? LIMIT 1"
	o.Raw(sql, videoid, courseid).QueryRow(&video)
	if video.Videoid == 0 {
		this.Tip("视频不存在或已经被管理员删除", 3, "/index/videolist")
	}

	// 读取课程信息。
	var course models.VCourse
	sql = "SELECT * FROM v_course WHERE courseid = ? AND display = ? LIMIT 1"
	o.Raw(sql, courseid, 1).QueryRow(&course)
	if course.Courseid == 0 {
		this.Tip("课程不存在或已经被管理员删除", 3, "/index/videolist")
	}

	// 计算星级。
	if course.Star == 0 {
		course.Star = 0
	} else {
		course.Star = int(math.Ceil(float64(int64(course.Star) / course.Appraise)))
	}

	// 读取课程视频列表信息。
	var videolist []services.VideoInfo
	sql = "SELECT videoid,courseid,videoname,duration,videourl,videoaddtime FROM v_video WHERE courseid = ? ORDER BY videoid ASC"
	o.Raw(sql, courseid).QueryRows(&videolist)

	// 获取存在放在七牛云存储的文件地址
	//deadline := uint32(video.Duration * 5)
	deadline := uint32(3) // 设置3秒过期，这样用户就无法复制链接直接下载视频了。
	videourl := ""
	if len(video.Videourl) > 0 {
		videourl = this.downloadUrl(QN_DOMAIN, video.Videourl, deadline)
	}

	// 获取视频播放广告。
	// 读取轮换广告。
	var adConfig models.VConfig
	o.Raw("SELECT * FROM v_config WHERE ckey = ?", "video_start_ad").QueryRow(&adConfig)
	var VideoAd services.IndexAd
	json.Unmarshal([]byte(adConfig.Cval), &VideoAd)

	this.Data["videourl"] = videourl
	this.Data["video"] = video
	this.Data["course"] = course
	this.Data["VideoList"] = videolist
	this.Data["VideoAd"] = VideoAd

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/Public/VideoPlay.tpl"
}

// 生成七牛资源下载链接
func (this *IndexController) downloadUrl(domain string, key string, deadline uint32) string {
	baseUrl := rs.MakeBaseUrl(domain, key)
	policy := rs.GetPolicy{Expires: deadline}
	return policy.MakeRequest(baseUrl, nil)
}

// 视频课程详情页面。
func (this *IndexController) VideoView() {
	// 课程详情与评论模板页面判断。
	iscomment := this.GetString("comment")

	courseid, _ := this.GetInt("courseid") // 课程ID。

	// 与课程留言共同使用一个CommentInfo结构体。
	var commlist []services.CommentInfo

	// 分页初始化。
	var OPage services.Page

	o := orm.NewOrm()
	// 如果是评论页面就取评论内容。
	if iscomment == "is" {
		var CountData models.SqlData
		countSql := "SELECT COUNT(1) AS count FROM v_comment WHERE typeid = ? AND relateid = ? LIMIT 1"
		o.Raw(countSql, 2, courseid).QueryRow(&CountData)
		total := CountData.Count

		// 分页处理
		page, _ := this.GetInt("page") // 当前页。
		OPage.Request = this.Ctx.Request
		OPage.PageNumber = page
		OPage.Total = total
		OPage.PageSize = 15
		OPage.Page()

		// 取列表数。
		sql := "SELECT a.commentid,b.username,b.realname,b.avatar,b.sex,a.userid,a.relateid,b.level,a.addtime,a.content,a.Star " +
			"FROM v_comment AS a LEFT JOIN v_user AS b ON(a.userid=b.userid) WHERE typeid = ? AND relateid = ? ORDER BY a.commentid DESC LIMIT ?, ? "
		o.Raw(sql, 2, courseid, OPage.Offset, OPage.Count).QueryRows(&commlist)
	}

	var course models.VCourse
	sql := "SELECT * FROM v_course WHERE display = 1 AND courseid = ?"
	err := o.Raw(sql, courseid).QueryRow(&course)
	if err != nil {
		this.Tip("服务器繁忙，请稍候重试", 3, "/index/videolist")
	}
	if course.Courseid == 0 {
		this.Tip("课程不存在或已经被管理员删除", 3, "/index/videolist")
	}
	// 计算星级。
	if course.Star == 0 {
		course.Star = 0
	} else {
		course.Star = int(math.Ceil(float64(int64(course.Star) / course.Appraise)))
	}

	// 读取课程视频列表信息。
	var videolist []services.VideoInfo
	sql = "SELECT videoid,courseid,videoname,duration,videourl,videoaddtime FROM v_video WHERE courseid = ? ORDER BY videoid ASC"
	o.Raw(sql, courseid).QueryRows(&videolist)

	// 推荐课程。
	var recommendCourse []models.VCourse
	sql = "SELECT * FROM v_course WHERE recommend = 1 AND display = 1 ORDER BY courseid DESC LIMIT 3"
	o.Raw(sql).QueryRows(&recommendCourse)

	// 更新访问次数。
	o.Raw("UPDATE v_course SET hits = hits+1 WHERE courseid = ? LIMIT 1", courseid).Exec()

	// 取课程评论列表。固定5条。
	// 联合查询情况下字段的顺序必须与struct的字段顺序一一对应。
	// 用户中心留言也用到了此结构。
	var CommentList []services.CommentInfo
	sql = "SELECT a.commentid,b.username,b.realname,b.avatar,b.sex,a.userid,a.relateid,b.level,a.addtime,a.content,a.Star " +
		"FROM v_comment AS a LEFT JOIN v_user AS b ON(b.userid=a.userid) WHERE a.relateid = ? AND a.typeid = ? ORDER BY a.commentid DESC LIMIT 5"
	o.Raw(sql, course.Courseid, 2).QueryRows(&CommentList)

	// 最新文章。
	var bestnewslist []models.VNews
	sql = "SELECT * FROM v_news ORDER BY newsid DESC LIMIT 9"
	o.Raw(sql).QueryRows(&bestnewslist)

	// 最热文章。
	var hotnewslist []models.VNews
	sql = "SELECT * FROM v_news ORDER BY hits DESC LIMIT 9 "
	o.Raw(sql).QueryRows(&hotnewslist)

	// 读取赞助广告。
	var sponsorConfig models.VConfig
	o.Raw("SELECT * FROM v_config WHERE ckey = ?", "sponsor_ad").QueryRow(&sponsorConfig)
	var sponsorAd services.IndexAd
	json.Unmarshal([]byte(sponsorConfig.Cval), &sponsorAd)

	// 是否购买课程。
	userdata := this.GetSession("userid")
	isBuy := false
	if userdata != nil {
		userid := userdata.(int64)
		var UserCourse models.VUserCourse
		o.Raw("SELECT * FROM v_user_course WHERE userid = ? AND courseid = ? LIMIT 1", userid, courseid).QueryRow(&UserCourse)
		if UserCourse.Ucid > 0 {
			isBuy = true
		}
	}

	this.Data["hotnewslist"] = hotnewslist
	this.Data["bestnewslist"] = bestnewslist
	this.Data["CommentList"] = CommentList
	this.Data["course"] = course
	this.Data["recommendCourse"] = recommendCourse
	this.Data["VideoList"] = videolist
	this.Data["iscomment"] = iscomment
	this.Data["commlist"] = commlist
	this.Data["Page"] = OPage

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.Data["sponsorAd"] = sponsorAd
	this.Data["isBuy"] = isBuy
	this.TplNames = AppTheme + "/Public/VideoView.tpl"
}

// 课程视频列表。
func (this *IndexController) VideoList() {
	page, _ := this.GetInt("page")       // 当前页。
	keyword := this.GetString("keyword") // 查询关键词。
	listorder := this.GetString("sort")  // 排序：hot:最热、new：最新
	tag := this.GetString("tag")         // 标签。

	// where 条件。
	where := " display = 1 "
	if len(keyword) > 0 {
		where += " AND coursename LIKE ? "
		keyword = "%" + keyword + "%"
	} else {
		where += " AND ? "
		keyword = "1"
	}

	if len(tag) > 0 {
		where += " AND coursetag LIKE ? "
		keyword = "%" + tag + "%"
	} else {
		where += " AND ? "
		tag = "1"
	}

	// 课程排序。
	orderby := ""
	if listorder == "hot" {
		orderby += " ORDER BY hits DESC "
	} else {
		orderby += " ORDER BY addtime DESC "
	}

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_course WHERE " + where + orderby
	o.Raw(countSql, keyword, tag).QueryRow(&CountData)
	total := CountData.Count

	// 分页处理
	var OPage services.Page
	OPage.Request = this.Ctx.Request
	OPage.PageNumber = page
	OPage.Total = total
	OPage.PageSize = 5
	OPage.Page()

	// 取列表数。
	var Course []models.VCourse
	sql := "SELECT * FROM v_course WHERE " + where + orderby + " LIMIT ?, ?"
	o.Raw(sql, keyword, tag, OPage.Offset, OPage.Count).QueryRows(&Course)

	// 计算星级。
	for k, v := range Course {
		if v.Star == 0 {
			v.Star = 0
		} else {
			v.Star = int(math.Ceil(float64(int64(v.Star) / v.Appraise)))
		}
		Course[k] = v
	}

	// 最新文章。
	var newslist []models.VNews
	sql = "SELECT * FROM v_news ORDER BY newsid DESC LIMIT 9"
	o.Raw(sql).QueryRows(&newslist)

	// 最热文章。
	var hotnewslist []models.VNews
	sql = "SELECT * FROM v_news ORDER BY hits DESC LIMIT 9 "
	o.Raw(sql).QueryRows(&hotnewslist)

	// 热门标签。
	var tags []services.HotTag
	sql = "SELECT coursetag FROM v_course WHERE coursetag != '' GROUP BY coursetag"
	o.Raw(sql).QueryRows(&tags)

	this.Data["tags"] = tags
	this.Data["hotnewslist"] = hotnewslist
	this.Data["newslist"] = newslist
	this.Data["Course"] = Course
	this.Data["Page"] = OPage
	this.Data["listorder"] = listorder

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/Public/VideoList.tpl"
}

// 验证码。
func (this *IndexController) AuthCode() {
	authcode := services.Pic(this.Ctx.ResponseWriter, this.Ctx.Request)
	this.SetSession("authcode", authcode)
	this.StopRun()
}

// Ajax表单验证。
func (this *IndexController) AjaxCheck() {
	name := this.GetString("name")
	switch name {
	case "authcode": // 验证码。
		authcode := this.GetString("authcode")
		sessAuthcode := this.GetSession("authcode")
		sessionAuthcode := ""
		if sessAuthcode != nil {
			sessionAuthcode = sessAuthcode.(string)
		}

		if len(authcode) == 0 {
			this.Data["json"] = "0" // 验证码不能为空。
			this.ServeJson()
			this.StopRun()
		}
		if authcode == sessionAuthcode {
			this.Data["json"] = "1" // 验证码正确。
			this.ServeJson()
			this.StopRun()
		} else {
			this.Data["json"] = "0" // 验证码不正确。
			this.ServeJson()
			this.StopRun()
		}
	case "username": // 用户名。
		username := this.GetString("username")
		usernameLen := len(username)
		if usernameLen == 0 {
			this.Data["json"] = "1" // 用户不能为空。
			this.ServeJson()
			this.StopRun()
		}
		// 验证用户名格式。
		type UserData struct {
			Username string
		}
		userinfo := UserData{Username: username}
		valid := validation.Validation{}
		valid.AlphaNumeric(userinfo.Username, username)
		if valid.HasErrors() {
			this.Data["json"] = "2" // 用户名格式不正确。
			this.ServeJson()
			this.StopRun()
		}

		if usernameLen < 6 || usernameLen > 20 {
			this.Data["json"] = "3" // 用户必须6到20个字符间。
			this.ServeJson()
			this.StopRun()
		}

		// 检查是否已经存在此用户。
		o := orm.NewOrm()
		var user models.VUser
		o.Raw("SELECT * FROM v_user WHERE username = ?", username).QueryRow(&user)
		if user.Userid > 0 {
			this.Data["json"] = "4" // 用户已经存在。
			this.ServeJson()
			this.StopRun()
		}
		this.Data["json"] = "5" // 用户正确。
		this.ServeJson()
		this.StopRun()
	case "email": // 邮箱格式验证。
		email := this.GetString("email")
		emailLen := len(email)
		if emailLen == 0 {
			this.Data["json"] = "1" // 邮箱不能为空。
			this.ServeJson()
			this.StopRun()
		}
		// 验证邮箱格式。
		type EmailData struct {
			Email string
		}
		emailinfo := EmailData{Email: email}
		valid := validation.Validation{}
		valid.Email(emailinfo.Email, email)
		if valid.HasErrors() {
			this.Data["json"] = "2" // 邮箱格式不正确。
			this.ServeJson()
			this.StopRun()
		}

		if emailLen < 6 || emailLen > 60 {
			this.Data["json"] = "3" // 邮箱长度似乎有些异常。
			this.ServeJson()
			this.StopRun()
		}

		// 检查是否已经存在邮箱。
		o := orm.NewOrm()
		var user models.VUser
		o.Raw("SELECT * FROM v_user WHERE email = ?", email).QueryRow(&user)
		if user.Userid > 0 {
			this.Data["json"] = "4" // 邮箱已经存在。
			this.ServeJson()
			this.StopRun()
		}
		this.Data["json"] = "5" // 邮箱格式正确。
		this.ServeJson()
		this.StopRun()
	}
}

// 注册页面。
func (this *IndexController) Register() {

	if this.Ctx.Input.Method() == "POST" {
		username := this.GetString("username")   // 账号。
		password := this.GetString("password")   // 密码。
		repeatpwd := this.GetString("repeatpwd") // 确认密码。
		authcode := this.GetString("authcode")   // 验证码。
		email := this.GetString("email")         // 邮箱地址。

		authcodeLen := len(authcode)
		usernameLen := len(username)
		passwordLen := len(password)
		emailLen := len(email)

		sessAuthcode := this.GetSession("authcode")
		sessionAuthcode := ""
		if sessAuthcode != nil {
			sessionAuthcode = sessAuthcode.(string)
		}
		if authcodeLen == 0 {
			this.Tip("验证码没有填写", 1, "/index/register")
		}
		if authcode != sessionAuthcode {
			this.Tip("验证码不正确", 1, "/index/register")
		} else {
			// 为了避免注册机重复利用此验证码，必须进行清除。
			this.DelSession("authcode")
		}

		if usernameLen == 0 {
			this.Tip("用户不能为空", 1, "/index/register")
		}
		if usernameLen < 6 || usernameLen > 20 {
			this.Tip("用户必须6到20个字符", 1, "/index/register")
		}

		// 验证用户名格式。
		type UserData struct {
			Username string
		}
		userinfo := UserData{Username: username}
		valid := validation.Validation{}
		valid.AlphaNumeric(userinfo.Username, username)
		if valid.HasErrors() {
			this.Tip("用户名格式不正确", 1, "/index/register")
		}

		if passwordLen == 0 {
			this.Tip("密码不能为空", 1, "/index/register")
		}
		if passwordLen < 6 || passwordLen > 20 {
			this.Tip("密码必须6到20个字符", 1, "/index/register")
		}
		if repeatpwd != password {
			this.Tip("确认密码不正确", 1, "/index/register")
		}

		// 检查是否已经存在此用户。
		o := orm.NewOrm()
		var user models.VUser
		o.Raw("SELECT * FROM v_user WHERE username = ? LIMIT 1", username).QueryRow(&user)

		if user.Userid > 0 {
			this.Tip("用户名已经存在，请更换其他用户名试试！", 1, "/index/register")
		}

		if emailLen == 0 {
			this.Tip("邮箱不能为空", 1, "/index/register")
		}
		// 验证邮箱格式。
		type EmailData struct {
			Email string
		}
		emailinfo := EmailData{Email: email}
		valid = validation.Validation{}
		valid.Email(emailinfo.Email, email)
		if valid.HasErrors() {
			this.Tip("邮箱格式不正确", 1, "/index/register")
		}

		if emailLen < 6 || emailLen > 60 {
			this.Tip("邮箱长度6到60个字符，您超出了", 1, "/index/register")
		}

		// 检查是否已经存在邮箱。
		o.Raw("SELECT * FROM v_user WHERE email = ?", email).QueryRow(&user)
		if user.Userid > 0 {
			this.Tip("该邮箱地址已经注册了", 1, "/index/register")
		}

		salt := services.GetRandomString(6) // 盐。
		h := md5.New()
		io.WriteString(h, password)
		password = fmt.Sprintf("%x", h.Sum(nil)) + salt
		h = md5.New()
		io.WriteString(h, password)
		password = fmt.Sprintf("%x", h.Sum(nil))

		regtime := time.Now().Format("2006-01-02 15:04:05")
		result, err := o.Raw("INSERT INTO v_user (username, password, salt, realname, regtime, email) VALUES(?, ?, ?, ?, ?, ?)", username, password, salt, username, regtime, email).Exec()
		if err != nil {
			this.Tip("服务器繁忙，请稍候再试！", 1, "/index/register")
		}

		// 读取Userid
		lastUserid, _ := result.LastInsertId() // 用户ID。
		// 设置登录状态。
		this.setLoginStatus(lastUserid, username, username)

		this.Tip("恭喜您！注册成功！", 1, "/user/index")
	}

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/Public/Register.tpl"
}

// 登录页面
func (this *IndexController) Login() {
	if this.Ctx.Input.Method() == "POST" {
		username := this.GetString("username")
		password := this.GetString("password")
		authcode := this.GetString("authcode")

		usernameLength := len(username)
		passwordLength := len(password)

		sessAuthcode := this.GetSession("authcode")
		sessionAuthcode := ""
		if sessAuthcode != nil {
			sessionAuthcode = sessAuthcode.(string)
		}
		if len(authcode) == 0 {
			this.Tip("验证码没有填写", 1, "/index/login")
		}
		if authcode != sessionAuthcode {
			this.Tip("验证码不正确", 1, "/index/login")
		} else {
			// 为了避免注册机重复利用此验证码，必须进行清除。
			this.DelSession("authcode")
		}

		if usernameLength == 0 {
			this.Tip("用户不能为空", 1, "/index/login")
		}
		if usernameLength < 6 {
			this.Tip("用户名长度小于6个字符", 1, "/index/login")
		}
		if usernameLength > 20 {
			this.Tip("用户长度大于20个字符", 1, "/index/login")
		}
		if passwordLength == 0 {
			this.Tip("密码不能为空", 1, "/index/login")
		}
		if passwordLength < 6 {
			this.Tip("密码长度小于6个字符", 1, "/index/login")
		}
		if passwordLength > 20 {
			this.Tip("密码长度不能大于20个字符", 1, "/index/login")
		}

		o := orm.NewOrm()
		var user models.VUser
		err := o.Raw("SELECT * FROM v_user WHERE username = ?", username).QueryRow(&user)
		if err != nil {
			this.Tip("账号或密码不正确", 1, "/index/login")
		}

		h := md5.New()
		io.WriteString(h, password)
		password = fmt.Sprintf("%x", h.Sum(nil)) + user.Salt
		h = md5.New()
		io.WriteString(h, password)
		password = fmt.Sprintf("%x", h.Sum(nil))

		if user.Password != password {
			this.Tip("账号或密码不正确", 1, "/index/login")
		}

		// 设置登录状态。
		this.setLoginStatus(user.Userid, user.Username, user.Realname)

		// 更新登录次数。
		o.Raw("UPDATE v_user SET login_count = login_count + 1 WHERE id = ?", user.Userid).Exec()
		// 增加登录次数
		loginip := this.Ctx.Input.IP()
		logintime := time.Now().Format("2006-01-02 15:04:05")
		o.Raw("INSERT INTO v_login_history (id, userid, loginip, login_time) VALUES (null, ?, ?, ?)", user.Userid, loginip, logintime).Exec()

		// 异步发送通知邮件。
		body := "账号：" + user.Username + "，登录成功...."
		go services.SendMail(AdminMail, "登录通知", body, "text")

		this.Tip("登录成功", 1, "/user/index")
	}

	// 判断是否已经登录，如果已经登录则直接跳转到用户中心首页。
	userdata := this.GetSession("userid")
	if userdata != nil {
		this.Tip("已经登录", 1, "/user/index")
	}

	// 使COOKIE失效，避免浏览器COOKIE未失效而显示登录状态。
	this.Ctx.SetCookie("username", "", -1, "/")
	this.Ctx.SetCookie("realname", "", -1, "/")

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/Public/Login.tpl"
}

// 忘记密码。
func (this *IndexController) ForgetPassword() {
	if this.Ctx.Input.Method() == "POST" {
		email := this.GetString("email")
		authcode := this.GetString("authcode")
		emailLen := len(email)

		if len(email) == 0 {
			this.Tip("请填写账号对应的邮箱地址", 3, "")
		}

		// 验证邮箱格式。
		type EmailData struct {
			Email string
		}
		emailinfo := EmailData{Email: email}
		valid := validation.Validation{}
		valid.Email(emailinfo.Email, email)
		if valid.HasErrors() {
			this.Tip("邮箱格式填写有误", 3, "")
		}

		if emailLen < 6 || emailLen > 60 {
			this.Tip("邮箱长度异常，请检查", 3, "")
		}

		sessAuthcode := this.GetSession("authcode")
		sessionAuthcode := ""
		if sessAuthcode != nil {
			sessionAuthcode = sessAuthcode.(string)
		}
		if len(authcode) == 0 {
			this.Tip("验证码没有填写", 3, "")
		}
		if authcode != sessionAuthcode {
			this.Tip("验证码不正确", 3, "")
		} else {
			// 为了避免注册机重复利用此验证码，必须进行清除。
			this.DelSession("authcode")
		}

		o := orm.NewOrm()
		var Data models.VUser
		o.Raw("SELECT * FROM v_user WHERE email = ?", email).QueryRow(&Data)
		if Data.Userid == 0 {
			this.Tip("该邮箱未在本站注册", 3, "")
		}

		siteurl := this.Ctx.Input.Site()
		Nanoseconds := time.Now().UnixNano()
		uniqid := strconv.FormatInt(Nanoseconds, 10) + Data.Email + Data.Username + Data.Salt
		h := md5.New()
		io.WriteString(h, uniqid)
		uniqid = fmt.Sprintf("%x", h.Sum(nil))
		addtime := time.Now().Unix()

		// 往验证信息表插入。
		_, err := o.Raw("INSERT INTO v_code (addtime, typeid, valitime, userid, codetext) VALUES(?, ?, ?, ?, ?)", addtime, 1, 3600, Data.Userid, uniqid).Exec()
		if err != nil {
			this.Tip("服务器繁忙，请稍息操作", 3, "")
		}

		siteurl += "/Index/GenerateNewPassword?code=" + uniqid
		message := `《` + SiteName + `》密码找回，请在一小时内点击下面链接进行操作，<a href="` + siteurl + `">请点击</a> 或者将网址复制到浏览器：` + siteurl
		go services.SendMail(Data.Email, "密码找回", message, "html")

		this.Tip("密码找回邮件已经发送到邮件，请查收!", 3, "")
	}

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/Public/ForgetPassword.tpl"
}

// QQ账号登录系统。
func (this *IndexController) QQLogin() {
	code := this.GetString("code")

	siteurl := this.Ctx.Input.Site()
	var qqapi services.QQapi
	qqapi.Callback = siteurl + "/index/qqlogin"
	if len(code) == 0 {
		redirect := qqapi.RedirectToLogin()
		redirectScript := `<script type="text/javascript">window.location.href="` + redirect + `"</script>`
		this.Ctx.WriteString(redirectScript)
		this.StopRun()
	} else {
		// 注册到系统。
		openid, err := qqapi.GetOpenid(code)
		if err != nil {
			services.AppLog.Critical("QQ getOpenid() function operator error")
			this.Tip("QQ服务器繁忙，请稍候重试", 1, "")
		}

		// 将openid放入SESSION。
		this.SetSession("qqOpenid", openid)

		// 取登录的QQ用户信息。
		qqUserinfo, err := qqapi.GetUserInfo(openid)
		if err != nil {
			services.AppLog.Critical("QQ GetUserInfo() function operator error")
			this.Tip("服务器繁忙，请稍候重试", 1, "")
		}

		// 判断是否已经存在此QQ用户了。
		o := orm.NewOrm()
		var userinfo models.VUser
		o.Raw("SELECT * FROM v_user WHERE `from` = ? AND connectid = ? LIMIT 1", "qq", openid).QueryRow(&userinfo)

		if userinfo.Userid == 0 { // 不存在用户。
			// 生成一个随机密码。
			// openid + salt
			salt := services.GetRandomString(6) // 盐。
			h := md5.New()
			io.WriteString(h, openid)
			password := fmt.Sprintf("%x", h.Sum(nil)) + salt
			h = md5.New()
			io.WriteString(h, password)
			password = fmt.Sprintf("%x", h.Sum(nil))

			// 添加一个用户。
			regtime := time.Now().Format("2006-01-02 15:04:05")
			realname := qqUserinfo.Nickname // 昵称。
			username := "QQ" + strconv.FormatInt(time.Now().UnixNano(), 10)
			email := username + "@qq.com"
			avatar := qqUserinfo.Figureurl_qq_1
			sex := 1
			if qqUserinfo.Gender == "女" {
				sex = 2
			}
			insertSql := "INSERT INTO v_user (username, password, salt, realname, regtime, email, avatar, sex, `from`, connectid) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
			result, err := o.Raw(insertSql, username, password, salt, realname, regtime, email, avatar, sex, "qq", openid).Exec()

			if err != nil {
				services.AppLog.Critical("QQ login and register to error")
				this.Tip("服务器繁忙，请稍息重试", 1, "")
			}

			// 读取Userid
			lastUserid, _ := result.LastInsertId() // 用户ID。

			// 设置登录状态。
			this.setLoginStatus(lastUserid, username, realname)

			this.Tip("登录成功", 1, "/")

		} else { // 已经登录的情况。

			// 设置登录状态。
			this.setLoginStatus(userinfo.Userid, userinfo.Username, userinfo.Realname)

			// 更新登录次数。
			o.Raw("UPDATE v_user SET login_count = login_count + 1 WHERE id = ?", userinfo.Userid).Exec()
			// 增加登录次数
			loginip := this.Ctx.Input.IP()
			logintime := time.Now().Format("2006-01-02 15:04:05")
			o.Raw("INSERT INTO v_login_history (id, userid, loginip, login_time) VALUES (null, ?, ?, ?)", userinfo.Userid, loginip, logintime).Exec()

			// 异步发送通知邮件。
			body := "账号：" + userinfo.Username + "，登录成功...."
			go services.SendMail(AdminMail, "登录通知", body, "text")

			this.Tip("登录成功", 1, "/")
		}
	}
}

// 设置登录状态。
// -- 1、登录状态设置，方便其他途径登录成功时调用。
func (this *IndexController) setLoginStatus(userid int64, username string, realname string) {
	// 设置SESSION
	this.SetSession("userid", userid)
	this.SetSession("username", username)
	// 设置COOKIE
	this.Ctx.SetCookie("username", username, 0, "/")
	this.Ctx.SetCookie("realname", realname, 0, "/")
}

// 退出登录
// -- 1、退出成功跳转到登录页面
func (this *IndexController) Logout() {
	// 清掉SESSION。
	this.DelSession("userid")
	this.DelSession("username")
	// 使COOKIE失效。
	this.Ctx.SetCookie("username", "", -1, "/")
	this.Ctx.SetCookie("realname", "", -1, "/")
	this.Tip("退出成功", 1, "/Index/Login")
}

// 密码找回成功页面。
// 即用户通过点击网站发送到邮件里面的链接跳转到此页面。
// 然后，为用户自动生成一个密码。再将此密码发送到用户邮箱。
func (this *IndexController) GenerateNewPassword() {
	code := this.GetString("code")
	if len(code) == 0 {
		this.Tip("密码找回激活码有误", 3, "/index/index")
	}

	o := orm.NewOrm()
	var codeInfo models.VCode
	o.Raw("SELECT * FROM v_code WHERE codetext = ? AND typeid = ? LIMIT 1", code, 1).QueryRow(&codeInfo)
	if codeInfo.Codeid == 0 {
		this.Tip("密码找回激活码有误", 3, "/index/index")
	}

	// 判断密码找回验证码是否过期。
	currTime := time.Now().Unix()                    // 当前时间戳。
	valitime := codeInfo.Addtime + codeInfo.Valitime // 验证码失效时间。
	if currTime > valitime {
		this.Tip("密码找回链接已经过期，请重新获取", 3, "/index/forgetpassword")
	}

	// 判断是否已经使用。使用之后，就必须失效。
	if codeInfo.Isuse == 1 {
		this.Tip("密码找回链接已经过期，请重新获取", 3, "/index/forgetpassword")
	}

	var UserInfo models.VUser
	o.Raw("SELECT * FROM v_user WHERE userid = ? LIMIT 1", codeInfo.Userid).QueryRow(&UserInfo)
	if UserInfo.Userid == 0 {
		this.Tip("用户被禁用或已经被管理员删除", 3, "/index/index")
	}

	// 随机生成一个密码。
	randomPassword := services.GetRandomString(12)
	h := md5.New()
	io.WriteString(h, randomPassword)
	password := fmt.Sprintf("%x", h.Sum(nil)) + UserInfo.Salt
	h = md5.New()
	io.WriteString(h, password)
	password = fmt.Sprintf("%x", h.Sum(nil))

	_, err := o.Raw("UPDATE v_user SET password = ? WHERE userid = ? LIMIT 1", password, UserInfo.Userid).Exec()
	if err != nil {
		this.Tip("服务器繁忙，请稍候重试", 3, "/index/index")
	}

	// 将使用状态变更一下。
	o.Raw("UPDATE v_code SET isuse = ? WHERE codeid = ? LIMIT 1", 1, codeInfo.Codeid).Exec()

	message := `《` + SiteName + `》密码找回成功，您的账号为：` + UserInfo.Username + `,新密码为：` + randomPassword + `，请尽快通过此密码登录并修改密码。`
	mailSubject := `《` + SiteName + `》密码找回成功通知`
	go services.SendMail(UserInfo.Email, mailSubject, message, "html")

	tips := `密码找回成功，新密码为：` + randomPassword
	this.Tip(tips, 30, "/index/login")
}

// 邮箱激活处理页面。
// -- 1、发送激活信息的方法在UserController中。
// -- 2、激活的链接有时间有效限制。使用成功之后立马失效。
func (this *IndexController) ProcessMailActivate() {
	code := this.GetString("code")
	if len(code) == 0 {
		services.AppLog.Critical("Email to active of error")
		this.Tip("邮箱激活码有误", 3, "/index/index")
	}

	o := orm.NewOrm()
	var codeInfo models.VCode
	o.Raw("SELECT * FROM v_code WHERE codetext = ? AND typeid = ? LIMIT 1", code, 2).QueryRow(&codeInfo)
	if codeInfo.Codeid == 0 {
		services.AppLog.Critical("Email to active of code not exists")
		this.Tip("邮箱激活码有误", 3, "/index/index")
	}

	// 判断密码找回验证码是否过期。
	currTime := time.Now().Unix()                    // 当前时间戳。
	valitime := codeInfo.Addtime + codeInfo.Valitime // 验证码失效时间。
	if currTime > valitime {
		this.Tip("邮箱激活链接已经过期，请重新获取", 3, "/user/userinfo")
	}

	// 判断是否已经使用。使用之后，就必须失效。
	if codeInfo.Isuse == 1 {
		this.Tip("邮箱激活链接已经过期，请重新获取", 3, "/index/forgetpassword")
	}

	var UserInfo models.VUser
	o.Raw("SELECT * FROM v_user WHERE userid = ? LIMIT 1", codeInfo.Userid).QueryRow(&UserInfo)
	if UserInfo.Userid == 0 {
		this.Tip("用户被禁用或已经被管理员删除", 3, "/index/index")
	}

	// 邮箱激活标识更新。
	_, err := o.Raw("UPDATE v_user SET isactive = ? WHERE userid = ? LIMIT 1", 1, UserInfo.Userid).Exec()
	if err != nil {
		services.AppLog.Critical("user to email active failed")
		this.Tip("服务器繁忙，请稍候重试", 3, "/index/index")
	}

	// 将使用状态变更一下。
	o.Raw("UPDATE v_code SET isuse = ? WHERE codeid = ? LIMIT 1", 1, codeInfo.Codeid).Exec()

	message := `《` + SiteName + `》邮箱成功，邮箱是找回用户密码的唯一途径。感谢您的使用，谢谢！`
	mailSubject := `《` + SiteName + `》邮件激活成功通知`
	go services.SendMail(UserInfo.Email, mailSubject, message, "html")

	this.Tip("邮箱激活成功", 3, "/index/login")
}
