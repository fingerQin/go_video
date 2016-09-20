// 管理员模式。
// -- 1、添加视频。
// -- 2、添加试卷。
// -- 3、添加试题。
// -- 4、添加单元。
// -- 5、添加科目。
// -- 6、添加年级。
// @author 寒冰[qljs888@163.com]
// @date 2013年11月24日

package controllers

import (
	"encoding/json"
	"fmt"
	"github.com/astaxie/beego/orm"
	"math"
	"strconv"
	"study/models"
	"study/services"
	"time"
)

type SystemController struct {
	CommonController
}

// 前置方法。
func (this *SystemController) Prepare() {
	this.validLogin()
}

// 验证登录。
func (this *SystemController) validLogin() {
	userdata := this.GetSession("userid")
	if userdata == nil {
		this.Tip("请先登录", 1, "/index/login")
	}

	// 左侧用户信息获取。
	userinfo := this.leftInfo()

	// 判断当前用户是否为超级管理员。
	if userinfo.Username != Originator {
		this.Tip("权限不够", 1, "/user/index")
	}

	this.Data["userinfo"] = userinfo
}

// 左侧公共信息获取。
func (this *SystemController) leftInfo() (userinfo models.VUser) {
	userid := (this.GetSession("userid")).(int64)
	// 读取用户信息。后期可以放入缓存。
	o := orm.NewOrm()
	sql := "SELECT * FROM v_user WHERE userid = ?"
	o.Raw(sql, userid).QueryRow(&userinfo)
	return userinfo
}

// 系统设置。
func (this *SystemController) Index() {

	o := orm.NewOrm()

	if this.Ctx.Input.Method() == "POST" {

		// 首页。
		indexad1_url := this.GetString("indexad1_url")
		indexad1_imgurl := ""
		if this.Ctx.Input.IsUpload() {
			_, indexad1_imgurl = services.UploadFile(this.Ctx.Request, "indexad1_imgurl", "poster", "indexSwitch1")
		}
		if len(indexad1_imgurl) == 0 {
			// 如果未上传图片，则读取老图片地址。
			indexad1_imgurl = this.GetString("old_indexad1_imgurl")
		}

		indexad2_url := this.GetString("indexad2_url")
		indexad2_imgurl := ""
		if this.Ctx.Input.IsUpload() {
			_, indexad2_imgurl = services.UploadFile(this.Ctx.Request, "indexad2_imgurl", "poster", "indexSwitch2")
		}
		if len(indexad2_imgurl) == 0 {
			indexad2_imgurl = this.GetString("old_indexad2_imgurl")
		}

		indexad3_url := this.GetString("indexad3_url")
		indexad3_imgurl := ""
		if this.Ctx.Input.IsUpload() {
			_, indexad3_imgurl = services.UploadFile(this.Ctx.Request, "indexad3_imgurl", "poster", "indexSwitch3")
		}
		if len(indexad3_imgurl) == 0 {
			indexad3_imgurl = this.GetString("old_indexad3_imgurl")
		}

		indexad4_url := this.GetString("indexad4_url")
		indexad4_imgurl := ""
		if this.Ctx.Input.IsUpload() {
			_, indexad4_imgurl = services.UploadFile(this.Ctx.Request, "indexad4_imgurl", "poster", "indexSwitch4")
		}
		if len(indexad4_imgurl) == 0 {
			indexad4_imgurl = this.GetString("old_indexad4_imgurl")
		}

		indexad5_url := this.GetString("indexad5_url")
		indexad5_imgurl := ""
		if this.Ctx.Input.IsUpload() {
			_, indexad5_imgurl = services.UploadFile(this.Ctx.Request, "indexad5_imgurl", "poster", "indexSwitch5")
		}
		if len(indexad5_imgurl) == 0 {
			indexad5_imgurl = this.GetString("old_indexad5_imgurl")
		}

		// 视频开始广告。
		video_url := this.GetString("video_url")
		video_imgurl := ""
		if this.Ctx.Input.IsUpload() {
			_, video_imgurl = services.UploadFile(this.Ctx.Request, "video_imgurl", "poster", "videoPlayStartImage")
		}
		if len(video_imgurl) == 0 {
			video_imgurl = this.GetString("old_video_imgurl")
		}

		// 赞助商广告。
		sponsor_url := this.GetString("sponsor_url")
		sponsor_imgurl := ""
		if this.Ctx.Input.IsUpload() {
			_, sponsor_imgurl = services.UploadFile(this.Ctx.Request, "sponsor_imgurl", "poster", "sponsorImage")
		}
		if len(sponsor_imgurl) == 0 {
			sponsor_imgurl = this.GetString("old_sponsor_imgurl")
		}

		// 合作推荐广告。
		hezuo_url := this.GetString("hezuo_url")
		hezuo_imgurl := ""
		if this.Ctx.Input.IsUpload() {
			_, hezuo_imgurl = services.UploadFile(this.Ctx.Request, "hezuo_imgurl", "poster", "hezuoImage")
		}
		if len(hezuo_imgurl) == 0 {
			hezuo_imgurl = this.GetString("old_hezuo_imgurl")
		}

		var indexAds []services.IndexAd
		indexad1 := services.IndexAd{indexad1_url, indexad1_imgurl, ""}
		indexad2 := services.IndexAd{indexad2_url, indexad2_imgurl, ""}
		indexad3 := services.IndexAd{indexad3_url, indexad3_imgurl, ""}
		indexad4 := services.IndexAd{indexad4_url, indexad4_imgurl, ""}
		indexad5 := services.IndexAd{indexad5_url, indexad5_imgurl, ""}
		indexAds = append(indexAds, indexad1)
		indexAds = append(indexAds, indexad2)
		indexAds = append(indexAds, indexad3)
		indexAds = append(indexAds, indexad4)
		indexAds = append(indexAds, indexad5)
		b, err := json.Marshal(indexAds)

		// 首页广告JSON。
		indexAdsJson := ""
		if err != nil {
			indexAdsJson = ""
		}
		indexAdsJson = string(b)
		o.Raw("UPDATE v_config SET cval = ? WHERE ckey = ?", indexAdsJson, "index_ad").Exec()

		// 视频播放开始时的广告JSON。
		vad := services.IndexAd{video_url, video_imgurl, ""}
		b, err = json.Marshal(vad)
		vadJson := ""
		if err != nil {
			vadJson = ""
		}
		vadJson = string(b)
		o.Raw("UPDATE v_config SET cval = ? WHERE ckey = ?", vadJson, "video_start_ad").Exec()

		// 赞助广告更新。
		sponsorAd := services.IndexAd{sponsor_url, sponsor_imgurl, ""}
		b, err = json.Marshal(sponsorAd)
		sponsorJson := ""
		if err != nil {
			sponsorJson = ""
		}
		sponsorJson = string(b)
		o.Raw("UPDATE v_config SET cval = ? WHERE ckey = ?", sponsorJson, "sponsor_ad").Exec()

		// 合作广告更新。
		hezuoAd := services.IndexAd{hezuo_url, hezuo_imgurl, ""}
		b, err = json.Marshal(hezuoAd)
		hezouJson := ""
		if err != nil {
			hezouJson = ""
		}
		hezouJson = string(b)
		o.Raw("UPDATE v_config SET cval = ? WHERE ckey = ?", hezouJson, "cooperation_ad").Exec()
	}

	var configs []models.VConfig
	o.Raw("SELECT * FROM v_config").QueryRows(&configs)

	var indexAds []services.IndexAd // 首页轮换广告读取。
	var videoAd services.IndexAd    // 视频播放器开始播放的广告。
	var sponsorAd services.IndexAd  // 赞助商广告。
	var hezuoAd services.IndexAd    // 合作商广告。

	for _, v := range configs {
		if v.Ckey == "index_ad" {
			if len(v.Cval) > 0 {
				json.Unmarshal([]byte(v.Cval), &indexAds)
			}
		} else if v.Ckey == "video_start_ad" {
			if len(v.Cval) > 0 {
				json.Unmarshal([]byte(v.Cval), &videoAd)
			}
		} else if v.Ckey == "sponsor_ad" {
			if len(v.Cval) > 0 {
				json.Unmarshal([]byte(v.Cval), &sponsorAd)
			}
		} else if v.Ckey == "cooperation_ad" {
			if len(v.Cval) > 0 {
				json.Unmarshal([]byte(v.Cval), &hezuoAd)
			}
		}
	}

	// 首页广告拆分。
	IndexOneAdUrl := indexAds[0].LinkUrl
	IndexTwoAdUrl := indexAds[1].LinkUrl
	IndexThreeAdUrl := indexAds[2].LinkUrl
	IndexFourAdUrl := indexAds[3].LinkUrl
	IndexFiveAdUrl := indexAds[4].LinkUrl

	IndexOneAdImgUrl := indexAds[0].ImgUrl
	IndextwoAdImgUrl := indexAds[1].ImgUrl
	IndexThreeAdImgUrl := indexAds[2].ImgUrl
	IndexFourAdImgUrl := indexAds[3].ImgUrl
	IndexFiveAdImgUrl := indexAds[4].ImgUrl

	this.Data["IndexOneAdUrl"] = IndexOneAdUrl
	this.Data["IndexTwoAdUrl"] = IndexTwoAdUrl
	this.Data["IndexThreeAdUrl"] = IndexThreeAdUrl
	this.Data["IndexFourAdUrl"] = IndexFourAdUrl
	this.Data["IndexFiveAdUrl"] = IndexFiveAdUrl
	this.Data["IndexOneAdImgUrl"] = IndexOneAdImgUrl
	this.Data["IndexTwoAdImgUrl"] = IndextwoAdImgUrl
	this.Data["IndexThreeAdImgUrl"] = IndexThreeAdImgUrl
	this.Data["IndexFourAdImgUrl"] = IndexFourAdImgUrl
	this.Data["IndexFiveAdImgUrl"] = IndexFiveAdImgUrl
	this.Data["videoAd"] = videoAd
	this.Data["sponsorAd"] = sponsorAd
	this.Data["hezuoAd"] = hezuoAd

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/Index.tpl"
}

// 课程列表。
func (this *SystemController) CourseList() {

	// 搜索参数。
	coursename := this.GetString("coursename")
	teacher := this.GetString("teacher")
	this.Data["coursename"] = coursename
	this.Data["teacher"] = teacher

	where := " 1 "
	if len(coursename) > 0 {
		where += " AND coursename LIKE ? "
		coursename = "%" + coursename + "%"
	} else {
		where += " AND ? "
		coursename = "1"
	}

	if len(teacher) > 0 {
		where += " AND teacher = ? "
	} else {
		where += " AND ? "
		teacher = "1"
	}

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_course WHERE " + where
	o.Raw(countSql, coursename, teacher).QueryRow(&CountData)
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
	var Course []models.VCourse
	sql := "SELECT * FROM v_course WHERE " + where + " ORDER BY courseid DESC LIMIT ?, ? "
	o.Raw(sql, coursename, teacher, OPage.Offset, OPage.Count).QueryRows(&Course)

	// 计算星级。
	for k, v := range Course {
		if v.Star == 0 {
			v.Star = 0
		} else {
			v.Star = int(math.Ceil(float64(int64(v.Star) / v.Appraise)))
		}
		Course[k] = v
	}

	this.Data["Course"] = Course
	this.Data["Page"] = OPage

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/CourseList.tpl"
}

// 添加课程。
func (this *SystemController) AddCourse() {
	if this.Ctx.Input.Method() == "POST" {
		display, _ := this.GetInt("display")       // 显示状态。
		recommend, _ := this.GetInt("recommend")   // 是否推荐。
		coursename := this.GetString("coursename") // 课程名称。
		intro := this.GetString("intro")           // 课程介绍。
		remark := this.GetString("remark")         // 课程备注。
		teacher := this.GetString("teacher")       // 讲师/讲座人。
		price, _ := this.GetInt("price")           // 价格。
		coursetag := this.GetString("coursetag")   // 课程标签。

		// 课程图片。
		courseimg := ""
		if this.Ctx.Input.IsUpload() {
			_, courseimg = services.UploadFile(this.Ctx.Request, "courseimg", "cover", "")
		}

		if len(coursename) == 0 || len(coursename) > 255 {
			this.Tip("课程名称长度必须1到255个字符之间", 2, "/system/courselist")
		}
		if recommend < 0 || recommend > 1 {
			recommend = 0
		}
		if len(intro) == 0 && len(intro) > 1000 {
			this.Tip("课程介绍长度必须1到1000个字符之间", 2, "/system/courselist")
		}
		if len(teacher) == 0 && len(teacher) > 10 {
			this.Tip("讲师长度必须1到10个字符之间", 2, "/system/courselist")
		}

		if price < 0 {
			price = 0
		}

		o := orm.NewOrm()
		sql := "INSERT INTO v_course (recommend, display, coursename, courseimg, intro, remark, addtime, teacher, lessontimes, price, coursetag)" +
			" VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		addtime := time.Now().Format("2006-01-02 15:04:05")
		res, err := o.Raw(sql, recommend, display, coursename, courseimg, intro, remark, addtime, teacher, 0, price, coursetag).Exec()
		if err != nil {
			this.Tip("服务器繁忙，请稍候重试", 2, "/system/courselist")
		}
		courseid, _ := res.LastInsertId()

		// 设置课程视频。
		this.setCourseVideo(courseid)

		this.Tip("课程添加成功", 1, "/system/courselist")
	}

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/AddCourse.tpl"
}

// 课程编辑。
func (this *SystemController) EditCourse() {
	o := orm.NewOrm()

	if this.Ctx.Input.Method() == "POST" {
		courseid, _ := this.GetInt("courseid")
		display, _ := this.GetInt("display")         // 显示状态。
		recommend, _ := this.GetInt("recommend")     // 是否推荐。
		coursename := this.GetString("coursename")   // 课程名称。
		intro := this.GetString("intro")             // 课程介绍。
		remark := this.GetString("remark")           // 课程备注。
		teacher := this.GetString("teacher")         // 讲师/讲座人。
		lessontimes, _ := this.GetInt("lessontimes") // 课程数/视频数。
		price, _ := this.GetInt("price")             // 价格。
		coursetag := this.GetString("coursetag")     // 课程标签。

		if courseid <= 0 {
			this.Tip("课程ID有误", 3, "/system/courselist")
		}
		if len(coursename) == 0 || len(coursename) > 255 {
			this.Tip("课程名称长度必须1到255个字符之间", 3, "/system/courselist")
		}
		if recommend < 0 || recommend > 1 {
			recommend = 0
		}
		if len(intro) == 0 && len(intro) > 1000 {
			this.Tip("课程介绍长度必须1到1000个字符之间", 3, "/system/courselist")
		}
		if len(teacher) == 0 && len(teacher) > 10 {
			this.Tip("讲师长度必须1到10个字符之间", 3, "/system/courselist")
		}
		if lessontimes < 0 {
			lessontimes = 0
		}

		// 课程图片。
		courseimg := ""
		if this.Ctx.Input.IsUpload() {
			courseImageFilename := "course_" + strconv.FormatInt(courseid, 10)
			_, courseimg = services.UploadFile(this.Ctx.Request, "courseimg", "cover", courseImageFilename)
		}

		var course models.VCourse
		o.Raw("SELECT * FROM v_course WHERE courseid = ?", courseid).QueryRow(&course)
		if course.Courseid == 0 {
			this.Tip("课程不存在或已经被管理员删除", 3, "/system/courselist")
		}

		if len(courseimg) == 0 {
			courseimg = course.Courseimg
		}

		sql := "UPDATE v_course SET recommend = ?, display = ?, coursename = ?, courseimg = ?, intro = ?, remark = ?, teacher = ?, lessontimes = ?, price = ?, coursetag = ?" +
			" WHERE courseid = ?"
		_, err := o.Raw(sql, recommend, display, coursename, courseimg, intro, remark, teacher, 0, price, coursetag, courseid).Exec()
		if err != nil {
			fmt.Println(err)
			this.Tip("服务器繁忙，请稍候重试", 3, "/system/courselist")
		}

		// 设置课程视频。
		this.setCourseVideo(courseid)

		this.Tip("课程修改成功", 1, "")
	} else {
		courseid, _ := this.GetInt("courseid") // 课程ID。
		if courseid == 0 {
			this.Tip("课程ID有误", 1, "")
		}

		// 取课程信息。
		var course models.VCourse
		sql := "SELECT * FROM v_course WHERE courseid = ?"
		o.Raw(sql, courseid).QueryRow(&course)
		if course.Courseid == 0 {
			this.Tip("课程不存在或已经被管理员删除", 1, "")
		}

		// 读取课程视频列表信息。
		var videolist []services.VideoInfo
		sql = "SELECT videoid,courseid,videoname,duration,videourl,videoaddtime FROM v_video WHERE courseid = ? ORDER BY videoid ASC"
		o.Raw(sql, courseid).QueryRows(&videolist)

		this.Data["course"] = course
		this.Data["videolist"] = videolist

		// SEO
		this.Data["SiteTitle"] = SiteTitle
		this.Data["SiteDesc"] = SiteDesc
		this.Data["SiteKeys"] = SiteKeys
		this.TplNames = AppTheme + "/System/EditCourse.tpl"
	}
}

// 设置课程视频。
// -- 1、视频的设置是通过清空原有的再添加。
// -- 2、视频的添加顺序就是展示的顺序。
// -- 3、仅供课程的添加与更新时使用。
// @return void
func (this *SystemController) setCourseVideo(courseid int64) {
	videoNames := this.GetStrings("videonames[]")       // 视频名称数组。
	videoUrls := this.GetStrings("videourls[]")         // 视频名称URL数组。
	durations := this.GetStrings("durations[]")         // 视频时长数组。
	addtime := time.Now().Format("2006-01-02 15:04:05") // 当前日期时间。

	lessontimes := 0 // 课程数。
	o := orm.NewOrm()
	// [1]清掉课程原有的数据。
	o.Raw("DELETE FROM v_video WHERE courseid = ?", courseid).Exec()
	// [2]添加视频。
	for k, v := range videoNames {
		videoname := v           // 视频名称。
		videourl := videoUrls[k] // 视频URL。
		duration := durations[k] // 视频时长。
		lessontimes += 1
		sql := "INSERT INTO v_video(courseid, videoname, videourl, duration, videoaddtime) VALUES(?, ?, ?, ?, ?)"
		o.Raw(sql, courseid, videoname, videourl, duration, addtime).Exec()
	}

	// 更新课程数。
	o.Raw("UPDATE v_course SET lessontimes = ? WHERE courseid = ?", lessontimes, courseid).Exec()
}

// 删除课程。
// -- 1、直接隐藏。
func (this *SystemController) DeleteCourse() {
	courseid, _ := this.GetInt("courseid") // 课程ID。
	if courseid == 0 {
		this.Tip("服务器繁忙，请稍候重试", 3, "")
	}

	o := orm.NewOrm()
	sql := "DELETE FROM v_course WHERE courseid = ? LIMIT 1"
	_, err := o.Raw(sql, courseid).Exec()
	if err != nil {
		this.Tip("服务器繁忙，请稍候重试", 3, "")
	}
	this.Tip("课程删除成功", 1, "")
}

// 笔记列表。
func (this *SystemController) NoteList() {
	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_note "
	o.Raw(countSql).QueryRow(&CountData)
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
	var NoteList []services.CourseNote
	sql := "SELECT b.courseid,b.coursename,b.courseimg,a.noteid,a.typeid,a.relateid,a.userid,a.addtime,a.lasttime,a.content " +
		"FROM v_note AS a LEFT JOIN v_course AS b ON(a.relateid=b.courseid) LIMIT ?, ? "
	num, err := o.Raw(sql, OPage.Offset, OPage.Count).QueryRows(&NoteList)
	if num == 0 && err != nil {
		fmt.Println(err)
	}

	this.Data["NoteList"] = NoteList
	this.Data["Page"] = OPage

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/NoteList.tpl"
}

// 删除笔记。
func (this *SystemController) DeleteNote() {
	noteid, _ := this.GetInt("noteid") // 笔记ID。
	if noteid <= 0 {
		this.Tip("参数有误", 1, "/system/notelist")
	}
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM v_note WHERE noteid = ?", noteid).Exec()
	if err != nil {
		this.Tip("服务器繁忙，请稍候重试", 1, "/system/notelist")
	}
	this.Tip("删除成功", 1, "/system/notelist")
}

// 评论列表
func (this *SystemController) CommentList() {
	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_comment "
	o.Raw(countSql).QueryRow(&CountData)
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
	// 与课程留言共同使用一个CommentInfo结构体。
	var CommentList []services.CommentInfo
	sql := "SELECT a.commentid,b.username,b.realname,b.avatar,b.sex,a.userid,a.relateid,b.level,a.addtime,a.content,a.star " +
		"FROM v_comment AS a LEFT JOIN v_user AS b ON(a.userid=b.userid) LIMIT ?, ? "
	num, err := o.Raw(sql, OPage.Offset, OPage.Count).QueryRows(&CommentList)
	if num == 0 && err != nil {
		fmt.Println(err)
	}

	this.Data["CommentList"] = CommentList
	this.Data["Page"] = OPage

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/CommentList.tpl"
}

// 删除评论。
func (this *SystemController) DeleteComment() {
	commentid, _ := this.GetInt("commentid") // 笔记ID。
	if commentid <= 0 {
		this.Tip("参数有误", 3, "/system/commentlist")
	}

	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM v_comment WHERE commentid = ?", commentid).Exec()
	if err != nil {
		this.Tip("服务器繁忙，请稍候重试", 3, "/system/commentlist")
	}
	this.Tip("删除成功", 1, "/system/commentlist")
}

// 试题列表。
func (this *SystemController) QuestionList() {

	qtype := this.GetString("qtype")     // 试题类型。
	qtitle := this.GetString("qtitle")   // 试题题目。
	addtime := this.GetString("addtime") // 日期。
	this.Data["qtype"] = qtype
	this.Data["qtitle"] = qtitle
	this.Data["addtime"] = addtime

	// 组装where条件
	var where string = " 1 "
	if len(qtype) > 0 {
		where += " AND qtype = ? "
	} else {
		where += " AND ? "
		qtype = "1"
	}

	if len(addtime) > 0 {
		where += " AND left(addtime, 10) = ? "
	} else {
		where += " AND ? "
		addtime = "1"
	}

	if len(qtitle) > 0 {
		where += " AND qtitle LIKE ? "
		qtitle = "%" + qtitle + "%"
	} else {
		where += " AND ? "
		qtitle = "1"
	}

	// 计算记录条数。
	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_question WHERE " + where
	o.Raw(countSql, qtype, addtime, qtitle).QueryRow(&CountData)
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
	var Question []models.VQuestion
	sql := "SELECT * FROM v_question WHERE " + where + " LIMIT ?, ?"
	o.Raw(sql, qtype, addtime, qtitle, OPage.Offset, OPage.Count).QueryRows(&Question)

	this.Data["Question"] = Question
	this.Data["Page"] = OPage
	this.Data["QuestionType"] = QuestionType

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/QuestionList.tpl"
}

// 添加试题。
func (this *SystemController) AddQuestion() {
	if this.Ctx.Input.Method() == "POST" {
		qtitle := this.GetString("qtitle")       // 试题标题。
		qsubtitle := this.GetString("qsubtitle") // 试题子标题。
		qtype := this.GetString("qtype")         // 试题类型。
		display := this.GetString("display")     // 试题显示。
		qoption := this.GetString("qoption")     // 试题选项。
		qanswer := this.GetString("qanswer")     // 试题答案。

		if len(qtitle) == 0 {
			this.Tip("试题标题必须填写", 3, "/system/questionlist")
		}

		if len(qtitle) > 255 {
			this.Tip("试题标题超过了255个字符", 3, "/system/questionlist")
		}

		if len(qtype) == 0 {
			this.Tip("试题类型没有选择", 3, "/system/questionlist")
		}

		if len(display) == 0 {
			this.Tip("试题显示状态未选择", 3, "/system/questionlist")
		}

		if len(qanswer) == 0 {
			this.Tip("试题正确答案没有填写", 3, "/system/questionlist")
		}

		sql := "INSERT INTO v_question (qid, qtitle, qsubtitle, qtype, display, addtime, qoption, qanswer) VALUES(NULL, ?, ?, ?, ?, ?, ?, ?)"
		o := orm.NewOrm()
		addtime := time.Now().Format("2006-01-02 15:04:05")
		_, err := o.Raw(sql, qtitle, qsubtitle, qtype, display, addtime, qoption, qanswer).Exec()
		if err != nil {
			this.Tip("服务器异常", 3, "/system/questionlist")
		}
		this.Tip("添加成功", 1, "/system/questionlist")
	}

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/AddQuestion.tpl"
}

// 编辑试题。
func (this *SystemController) EditQuestion() {

	if this.Ctx.Input.Method() == "POST" {
		qid, _ := this.GetInt("qid")             // 试题ID。
		qtitle := this.GetString("qtitle")       // 试题标题。
		qsubtitle := this.GetString("qsubtitle") // 试题子标题。
		qtype := this.GetString("qtype")         // 试题类型。
		display := this.GetString("display")     // 试题显示。
		qoption := this.GetString("qoption")     // 试题选项。
		qanswer := this.GetString("qanswer")     // 试题答案。

		if qid == 0 {
			//this.Data["json"] = map[string]string{"status": "7", "message": "参数异常"}
			//this.ServeJson(true)
			this.Tip("参数异常", 3, "/system/questionlist")
		}

		if len(qtitle) == 0 {
			this.Tip("试题标题必须填写", 3, "")
		}

		if len(qtitle) > 255 {
			this.Tip("试题标题超过了255个字符", 3, "")
		}

		if len(qtype) == 0 {
			this.Tip("试题类型没有选择", 3, "")
		}

		if len(display) == 0 {
			this.Tip("试题显示状态未选择", 3, "")
		}

		if len(qanswer) == 0 {
			this.Tip("试题正确答案没有填写", 3, "")
		}

		sql := "UPDATE v_question SET qtitle = ?, qsubtitle = ?, qtype = ?, display = ?, qoption = ?, qanswer = ? WHERE qid = ?"
		o := orm.NewOrm()
		_, err := o.Raw(sql, qtitle, qsubtitle, qtype, display, qoption, qanswer, qid).Exec()
		if err != nil {
			this.Tip("服务器繁忙，请稍候刷新页面重试", 3, "")
		}
		this.Tip("编辑成功", 1, "")
	}

	qid, _ := strconv.ParseInt(this.Input().Get("qid"), 10, 0) // 试卷ID。
	o := orm.NewOrm()
	var Question models.VQuestion
	err := o.Raw("SELECT * FROM v_question WHERE qid = ?", qid).QueryRow(&Question)
	if err != nil {
		this.Tip("试卷不存在，或已经被管理员删除", 3, "/system/questionlist")
	}
	this.Data["Question"] = Question

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/EditQuestion.tpl"
}

// 试题删除。
func (this *SystemController) DeleteQuestion() {
	qid, _ := this.GetInt("qid")
	if qid == 0 {
		this.Tip("参数异常", 3, "/system/questionlist")
	}

	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM v_question WHERE qid = ?", qid).Exec()
	if err != nil {
		this.Tip("服务器繁忙，请稍候刷新页面重试", 3, "")
	}
	this.Tip("删除成功", 1, "")
}

// 试卷列表。
func (this *SystemController) PaperList() {

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/PaperList.tpl"
}

// 添加试卷。
func (this *SystemController) AddPaper() {

	if this.Ctx.Input.Method() == "POST" {
		ptitle := this.GetString("ptitle") // 试题标题。
		pintro := this.GetString("pintro") // 试题介绍。

		if len(ptitle) == 0 {
			this.Tip("试卷名称没有填写", 3, "")
		}

		if len(ptitle) > 255 {
			this.Tip("试卷名称超过了255个字符", 3, "")
		}

		if len(pintro) == 0 {
			this.Tip("试卷介绍没有填写", 3, "")
		}

		sql := "INSERT INTO v_paper (pid, ptitle, pintro, addtime) VALUES(NULL, ?, ?, ?)"
		o := orm.NewOrm()
		addtime := time.Now().Format("2006-01-02 15:04:05")
		_, err := o.Raw(sql, ptitle, pintro, addtime).Exec()
		if err != nil {
			this.Tip("服务器异常", 3, "/system/questionlist")
		}
		this.Tip("添加成功", 3, "/system/questionlist")
	}

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/AddPaper.tpl"
}

// 编辑试卷。
func (this *SystemController) EditPaper() {

	if this.Ctx.Input.Method() == "POST" {
		pid, _ := this.GetInt("pid")       // 试卷ID。
		ptitle := this.GetString("ptitle") // 试题标题。
		pintro := this.GetString("pintro") // 试题子标题。

		if pid == 0 {
			this.Tip("试卷ID异常", 3, "/system/paperlist")
		}

		if len(ptitle) == 0 {
			this.Tip("试卷名称没有填写", 3, "")
		}

		if len(ptitle) > 255 {
			this.Tip("试卷名称超过了255个字符", 3, "")
		}

		if len(pintro) == 0 {
			this.Tip("试卷介绍没有填写", 3, "")
		}

		sql := "UPDATE v_paper SET ptitle = ?, pintro = ? WHERE pid = ?"
		o := orm.NewOrm()
		_, err := o.Raw(sql, ptitle, pintro, pid).Exec()
		if err != nil {
			this.Tip("服务器异常", 3, "")
		}
		this.Tip("更新成功", 1, "")
	}

	pid, _ := strconv.ParseInt(this.Input().Get("pid"), 10, 0) // 试卷ID。
	o := orm.NewOrm()
	var Paper models.VPaper
	err := o.Raw("SELECT * FROM v_paper WHERE pid = ?", pid).QueryRow(&Paper)
	if err != nil {
		this.Tip("试卷不存在或已经被管理员删除", 3, "")
	}
	this.Data["Paper"] = Paper

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/EditPaper.tpl"
}

// 试卷删除。
func (this *SystemController) DeletePaper() {
	pid, _ := this.GetInt("pid")
	if pid == 0 {
		this.Tip("参数异常", 3, "/system/paperlist")
	}

	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM v_paper WHERE pid = ?", pid).Exec()
	if err != nil {
		this.Tip("服务器异常", 3, "")
	}
	this.Tip("删除成功", 3, "")
}

// 视频列表。
func (this *SystemController) VideoList() {

	// 搜索参数。
	videoname := this.GetString("videoname")
	videoaddtime := this.GetString("videoaddtime")
	this.Data["videoname"] = videoname
	this.Data["videoaddtime"] = videoaddtime

	where := " 1 "
	if len(videoname) > 0 {
		where += " AND videoname LIKE ? "
		videoname = "%" + videoname + "%"
	} else {
		where += " AND ? "
		videoname = "1"
	}

	if len(videoaddtime) > 0 {
		where += " AND left(videoaddtime, 10) = ? "
	} else {
		where += " AND ? "
		videoaddtime = "1"
	}

	// 计算记录条数。
	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_video WHERE " + where
	o.Raw(countSql, videoname, videoaddtime).QueryRow(&CountData)
	total := CountData.Count

	// 分页处理
	page, _ := this.GetInt("page") // 当前页。
	var OPage services.Page
	OPage.Request = this.Ctx.Request
	OPage.PageNumber = page
	OPage.Total = total
	OPage.PageSize = 10
	OPage.Page()

	// 取列表数据。
	var videolist []models.VVideo
	sql := "SELECT * FROM v_video WHERE " + where + " LIMIT ?, ?"
	o.Raw(sql, videoname, videoaddtime, OPage.Offset, OPage.Count).QueryRows(&videolist)

	this.Data["videolist"] = videolist
	this.Data["Page"] = OPage

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/VideoList.tpl"
}

// 添加视频。
func (this *SystemController) AddVideo() {

	if this.Ctx.Input.Method() == "POST" {
		videoname := this.GetString("videoname")   // 视频名称。
		videotag := this.GetString("videotag")     // 视频标签。
		videointro := this.GetString("videointro") // 视频介绍。
		videourl := this.GetString("videourl")     // 视频URL地址

		o := orm.NewOrm()
		addtime := time.Now().Format("2006-01-02 15:04:05")
		sql := "INSERT INTO v_video (videoid, videoname, videotag, videourl, videointro, videoaddtime) VALUES(NULL, ?, ?, ?, ?, ?)"
		_, err := o.Raw(sql, videoname, videotag, videourl, videointro, addtime).Exec()
		if err != nil {
			this.Tip("服务器异常", 3, "")
		}
		this.Tip("添加成功", 1, "")
	}
	this.StopRun()
}

// 编辑视频。
func (this *SystemController) EditVideo() {

	if this.Ctx.Input.Method() == "POST" {
		videoid := this.GetString("videoid")       // 视频ID。
		videoname := this.GetString("videoname")   // 视频名称。
		videotag := this.GetString("videotag")     // 视频标签。
		videointro := this.GetString("videointro") // 视频介绍。
		videourl := this.GetString("videourl")     // 视频URL地址

		o := orm.NewOrm()
		sql := "UPDATE v_video SET videoname=?,videotag=?,videourl=?,videointro=? WHERE videoid=?"
		_, err := o.Raw(sql, videoname, videotag, videourl, videointro, videoid).Exec()
		if err != nil {
			this.Tip("服务器异常", 3, "")
		}
		this.Tip("更新成功", 1, "")
	}
}

// 删除视频。
// -- 1、删除视频记录同时更新与视频相关的记录为已经删除的状态。
func (this *SystemController) DeleteVideo() {
	videoid, _ := this.GetInt("videoid")
	if videoid <= 0 {
		this.Tip("参数有误", 3, "/system/videolist")
	}
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM v_video WHERE videoid = ?", videoid).Exec()
	if err != nil {
		this.Tip("服务器异常", 1, "")
	} else {
		o.Raw("UPDATE v_relate_video SET display = 0 WHERE videoid = ?", videoid).Exec()
		this.Tip("删除成功", 1, "")
	}
}

// 分类列表。
func (this *SystemController) Category() {
	// 搜索参数。
	catname := this.GetString("catname")
	this.Data["catname"] = catname

	where := " 1 "
	if len(catname) > 0 {
		where += " AND catname LIKE ? "
		catname = "%" + catname + "%"
	} else {
		where += " AND ? "
		catname = "1"
	}

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_news WHERE " + where
	o.Raw(countSql, catname).QueryRow(&CountData)
	total := CountData.Count

	// 分页处理
	page, _ := this.GetInt("page") // 当前页。
	var OPage services.Page
	OPage.Request = this.Ctx.Request
	OPage.PageNumber = page
	OPage.Total = total
	OPage.PageSize = 1000
	OPage.Page()

	// 取列表数。
	var category []models.VCategory
	sql := "SELECT * FROM v_category WHERE " + where + " ORDER BY listorder ASC LIMIT ?, ? "
	o.Raw(sql, catname, OPage.Offset, OPage.Count).QueryRows(&category)

	this.Data["category"] = category
	this.Data["Page"] = OPage

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/Category.tpl"
}

// 添加分类。
func (this *SystemController) AddCategory() {
	if this.Ctx.Input.Method() == "POST" {
		catname := this.GetString("catname")
		parentid, _ := this.GetInt("parentid")
		listorder, _ := this.GetInt("listorder")

		if len(catname) == 0 {
			this.Tip("分类名称必须输入", 3, "")
		}

		o := orm.NewOrm()
		sql := "INSERT INTO v_category (catid, catname, parentid, listorder) VALUES(null, ?, ?, ?)"
		_, err := o.Raw(sql, catname, parentid, listorder).Exec()
		if err != nil {
			this.Tip("服务器繁忙，请稍候重试", 3, "")
		}
		this.Tip("添加成功", 1, "/system/category")
	}
}

// 编辑分类。
func (this *SystemController) EditCategory() {
	if this.Ctx.Input.Method() == "POST" {
		catid, _ := this.GetInt("catid")
		catname := this.GetString("catname")
		parentid, _ := this.GetInt("parentid")
		listorder, _ := this.GetInt("listorder")

		if catid == 0 {
			this.Tip("参数有误", 3, "/system/category")
		}

		if len(catname) == 0 {
			this.Tip("分类名称必须输入", 3, "")
		}

		o := orm.NewOrm()
		sql := "UPDATE v_category SET catname = ?, parentid = ?, listorder = ? WHERE catid = ?"
		_, err := o.Raw(sql, catname, parentid, listorder, catid).Exec()
		if err != nil {
			this.Tip("服务器繁忙，请稍候重试", 3, "")
		}
		this.Tip("更新成功", 1, "")
	}
}

// 删除分类。
func (this *SystemController) DeleteCategory() {
	catid, _ := this.GetInt("catid")
	if catid == 0 {
		this.Tip("参数有误", 3, "/system/category")
	}
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM v_category WHERE catid = ?", catid).Exec()
	if err != nil {
		this.Tip("服务器繁忙，请稍候再试", 3, "")
	}
	this.Tip("删除成功", 1, "")
}

// 收藏列表。
func (this *SystemController) Favorite() {
	this.TplNames = AppTheme + "/System/Favorite.tpl"
}

// 收藏删除。
func (this *SystemController) DeleteFavorite() {
	favoriteid, _ := this.GetInt("favoriteid")
	if favoriteid <= 0 {
		this.Tip("服务器繁忙，请稍候重试", 3, "/system/favorite")
	}
	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM v_favorite WHERE favoriteid = ? LIMIT 1", favoriteid).Exec()
	if err != nil {
		this.Tip("服务器繁忙，请稍候重试", 3, "")
	}
	this.Tip("删除成功", 1, "")
}

// 用户列表。
func (this *SystemController) UserList() {
	// 搜索参数。
	userid := this.GetString("userid")
	username := this.GetString("username")
	realname := this.GetString("realname")
	this.Data["userid"] = userid
	this.Data["username"] = username
	this.Data["realname"] = realname

	where := " 1 "
	if len(userid) > 0 {
		where += " AND userid = ? "
	} else {
		where += " AND ? "
		userid = "1"
	}

	if len(username) > 0 {
		where += " AND username = ? "
	} else {
		where += " AND ? "
		username = "1"
	}

	if len(realname) > 0 {
		where += " AND realname = ? "
	} else {
		where += " AND ? "
		realname = "1"
	}

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_user WHERE " + where
	o.Raw(countSql, userid, username, realname).QueryRow(&CountData)
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
	var userlist []models.VUser
	sql := "SELECT * FROM v_user WHERE " + where + " ORDER BY userid DESC LIMIT ?, ? "
	o.Raw(sql, userid, username, realname, OPage.Offset, OPage.Count).QueryRows(&userlist)

	this.Data["userlist"] = userlist
	this.Data["Page"] = OPage

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/UserList.tpl"
}

// 用户删除。
func (this *SystemController) DeleteUser() {
	userid, _ := this.GetInt("userid")
	if userid <= 0 {
		this.Tip("参数有误", 3, "/system/userlist")
	}
	o := orm.NewOrm()
	var usr models.VUser
	o.Raw("SELECT * FROM v_user WHERE userid = ? LIMIT 1", userid).QueryRow(&usr)
	if usr.Username == Originator {
		this.Tip("超级管理员不能删除", 1, "")
	} else {
		_, err := o.Raw("DELETE FROM v_user WHERE userid = ? LIMIT 1", userid).Exec()
		if err != nil {
			this.Tip("服务器异常，请稍候重试", 3, "")
		}
		this.Tip("删除成功", 1, "")
	}
}

// 文章列表。
func (this *SystemController) NewsList() {
	// 搜索参数。
	title := this.GetString("title")
	catid := this.GetString("catid")
	author := this.GetString("author")
	iscomment := this.GetString("iscomment")
	isnotice := this.GetString("isnotice")
	hits := this.GetString("hits")
	source := this.GetString("source")
	this.Data["title"] = title
	this.Data["catid"] = catid
	this.Data["author"] = author
	this.Data["iscomment"] = iscomment
	this.Data["isnotice"] = isnotice
	this.Data["hits"] = hits
	this.Data["source"] = source

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

	if len(author) > 0 {
		where += " AND author = ? "
	} else {
		where += " AND ? "
		author = "1"
	}

	if len(iscomment) > 0 {
		where += " AND iscomment = ? "
	} else {
		where += " AND ? "
		iscomment = "1"
	}

	if len(isnotice) > 0 {
		where += " AND isnotice = ? "
	} else {
		where += " AND ? "
		isnotice = "1"
	}

	if len(hits) > 0 {
		where += " AND hits > ? "
	} else {
		where += " AND ? "
		hits = "1"
	}

	if len(source) > 0 {
		where += " AND source = ? "
	} else {
		where += " AND ? "
		source = "1"
	}

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_news WHERE " + where
	o.Raw(countSql, title, catid, author, iscomment, isnotice, hits, source).QueryRow(&CountData)
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
	sql := "SELECT a.newsid,a.catid,a.title,b.userid,b.username,b.realname,a.author,a.lasttime,a.addtime,a.iscomment,a.isnotice,a.hits,a.display,a.source,a.intro,a.content,a.star,a.appraise " +
		"FROM v_news AS a LEFT JOIN v_user AS b ON(a.userid=b.userid) WHERE " + where + " ORDER BY newsid DESC LIMIT ?, ? "
	o.Raw(sql, title, catid, author, iscomment, isnotice, hits, source, OPage.Offset, OPage.Count).QueryRows(&newslist)

	this.Data["newslist"] = newslist
	this.Data["Page"] = OPage

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/NewsList.tpl"
}

// 添加文章。
func (this *SystemController) AddNews() {
	if this.Ctx.Input.Method() == "POST" {
		title := this.GetString("title")         // 标题。
		author := this.GetString("author")       // 作者。
		catid, _ := this.GetInt("catid")         // 分类ID。
		iscomment, _ := this.GetInt("iscomment") // 是否允许评论。
		isnotice, _ := this.GetInt("isnotice")   // 是否为公告。
		source := this.GetString("source")       // 来源。
		intro := this.GetString("intro")         // 文章介绍或摘要。
		content := this.GetString("content")     // 文章内容。
		display, _ := this.GetInt("display")     // 显示状态。

		if len(title) == 0 {
			this.Tip("文章标题不能为空", 3, "/system/addnews")
		}

		if len(title) > 255 {
			this.Tip("文章标题不能超过255个字符，建议选择合适长度的标题", 3, "/system/addnews")
		}

		if iscomment < 0 || iscomment > 1 {
			iscomment = 0
		}

		if isnotice < 0 || isnotice > 1 {
			isnotice = 0
		}

		if display < 0 || display > 1 {
			display = 0
		}

		if len(content) == 0 {
			this.Tip("文章内容不能为空", 3, "/system/addnews")
		}

		o := orm.NewOrm()
		sql := "INSERT INTO v_news(title, userid, catid, author, lasttime, addtime, iscomment, isnotice, source, intro, content, display)" +
			" VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
		addtime := time.Now().Format("2006-01-02 15:04:05")
		userid := (this.GetSession("userid")).(int64)
		_, err := o.Raw(sql, title, userid, catid, author, addtime, addtime, iscomment, isnotice, source, intro, content, display).Exec()
		if err != nil {
			fmt.Println(err)
			this.Tip("服务器繁忙，请稍候重试", 3, "/system/newslist")
		}
		this.Tip("文章添加成功", 1, "")
	}

	catid, _ := this.GetInt("catid")
	parentid := 0
	o := orm.NewOrm()
	if catid > 0 {
		var catinfo models.VCategory
		o.Raw("SELECT * FROM v_category WHERE catid = ?", catid).QueryRow(&catinfo)
		if catinfo.Parentid != 0 {
			parentid = catinfo.Parentid
		}
	}
	// 读取父分类列表。
	var catlist []models.VCategory
	o.Raw("SELECT * FROM v_category WHERE parentid = 0 ORDER BY listorder ASC").QueryRows(&catlist)

	this.Data["catlist"] = catlist
	this.Data["parentid"] = parentid
	this.Data["catid"] = catid

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/AddNews.tpl"
}

// 获取子分类。
func (this *SystemController) AjaxCategory() {
	parentid, _ := this.GetInt("parentid")
	o := orm.NewOrm()
	var catlist []models.VCategory
	o.Raw("SELECT * FROM v_category WHERE parentid = ?", parentid).QueryRows(&catlist)
	this.Data["json"] = catlist
	this.ServeJson(true)
	this.StopRun()
}

// 编辑文章。
func (this *SystemController) EditNews() {
	if this.Ctx.Input.Method() == "POST" {
		newsid, _ := this.GetInt("newsid")       // 文章ID。
		title := this.GetString("title")         // 标题。
		author := this.GetString("author")       // 作者。
		catid, _ := this.GetInt("catid")         // 分类ID。
		iscomment, _ := this.GetInt("iscomment") // 是否允许评论。
		isnotice, _ := this.GetInt("isnotice")   // 是否为公告。
		source := this.GetString("source")       // 来源。
		intro := this.GetString("intro")         // 文章介绍或摘要。
		content := this.GetString("content")     // 文章内容。
		display, _ := this.GetInt("display")     // 显示状态。

		if newsid <= 0 {
			this.Tip("参数异常", 3, "/system/newslist")
		}

		if len(title) == 0 {
			this.Tip("文章标题不能为空", 3, "/system/newslist")
		}

		if len(title) > 255 {
			this.Tip("文章标题不能超过255个字符，建议选择合适长度的标题", 3, "/system/newslist")
		}

		if iscomment < 0 || iscomment > 1 {
			iscomment = 0
		}

		if isnotice < 0 || isnotice > 1 {
			isnotice = 0
		}

		if display < 0 || display > 1 {
			display = 0
		}

		if len(content) == 0 {
			this.Tip("文章内容不能为空", 3, "/system/newslist")
		}

		o := orm.NewOrm()
		sql := "UPDATE v_news SET title = ?, catid = ?, author = ?, lasttime = ?, iscomment = ?, isnotice = ?, source = ?, intro = ?, content = ?, display = ? WHERE newsid = ?"
		lasttime := time.Now().Format("2006-01-02 15:04:05")
		_, err := o.Raw(sql, title, catid, author, lasttime, iscomment, isnotice, source, intro, content, display, newsid).Exec()
		if err != nil {
			this.Tip("服务器繁忙，请稍候重试", 3, "/system/newslist")
		}
		this.Tip("文章编辑成功", 1, "/system/newslist")
	}

	newsid, _ := this.GetInt("newsid")
	if newsid <= 0 {
		this.Tip("参数有误", 3, "/system/newslist")
	}
	o := orm.NewOrm()
	var newsinfo services.NewsInfo
	sql := "SELECT a.newsid,a.catid,a.title,b.userid,b.username,b.realname,a.author,a.lasttime,a.addtime,a.iscomment,a.isnotice,a.hits,a.display,a.source,a.intro,a.content,a.star,a.appraise " +
		"FROM v_news AS a LEFT JOIN v_user AS b ON(a.userid=b.userid) WHERE a.newsid = ? LIMIT 1 "
	o.Raw(sql, newsid).QueryRow(&newsinfo)

	// 读取父分类列表。
	var catlist []models.VCategory
	o.Raw("SELECT * FROM v_category WHERE parentid = 0 ORDER BY listorder ASC").QueryRows(&catlist)

	// 读取父分类。
	catid := newsinfo.Catid
	var catinfo models.VCategory
	o.Raw("SELECT * FROM v_category WHERE catid = ?", catid).QueryRow(&catinfo)
	parentid := catinfo.Parentid

	this.Data["catid"] = catid
	this.Data["parentid"] = parentid
	this.Data["catlist"] = catlist
	this.Data["newsinfo"] = newsinfo

	// SEO
	this.Data["SiteTitle"] = SiteTitle
	this.Data["SiteDesc"] = SiteDesc
	this.Data["SiteKeys"] = SiteKeys
	this.TplNames = AppTheme + "/System/EditNews.tpl"
}

// 文章删除。
func (this *SystemController) DeleteNews() {
	newsid, _ := this.GetInt("newsid")
	if newsid <= 0 {
		this.Tip("参数异常", 3, "/system/newslist")
	}

	o := orm.NewOrm()
	_, err := o.Raw("DELETE FROM v_news WHERE newsid = ?", newsid).Exec()
	if err != nil {
		this.Tip("服务器繁忙，请稍候重试", 3, "")
	}
	this.Tip("删除成功", 1, "")
}

// kindeditor 图片上传处理工具。
// -- 1、注意，kindeditor的返回格式遵循了严格的数据类型。如：error必须是整型。
func (this *SystemController) UploadSystemImage() {

	// 图片上传成功时的JOSN对应结构体
	type UploadMessageSuccess struct {
		Error int    `json:"error"`
		Url   string `json:"url"`
	}

	// 图片上传失败时的JOSN对应结构体
	type UploadMessageFail struct {
		Error   int    `json:"error"`
		Message string `json:"message"`
	}

	if this.Ctx.Input.IsUpload() {
		errCode, newsImage := services.UploadFile(this.Ctx.Request, "imgFile", "news", "")
		if errCode > 0 {
			this.Data["json"] = UploadMessageFail{Error: 1, Message: "图片上传失败"}
			this.ServeJson()
			this.StopRun()
		} else {
			website := this.Ctx.Input.Site()
			imageUrl := website + newsImage
			this.Data["json"] = UploadMessageSuccess{Error: 0, Url: imageUrl}
			this.ServeJson()
		}
	}
	this.StopRun()
}

// kindeditor图片浏览功能。
func (this *SystemController) KindEditorFileManager() {
	// 待实现。
}
