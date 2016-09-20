// 用户中心。
// @author 寒冰。
// @date 2013年12月15日。

package controllers

import (
	"fmt"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
	"os"
	"path/filepath"
	"runtime"
	"strconv"
	"time"

	"crypto/md5"
	"io"
	"math"
	"net/url"
	"strings"
	"study/models"
	"study/services"
)

type UserController struct {
	CommonController
}

// 前置方法。
func (this *UserController) Prepare() {
	this.validLogin()
}

// 验证登录。
func (this *UserController) validLogin() {
	userdata := this.GetSession("userid")
	if userdata == nil {
		this.Tip("请先登录", 1, "/index/login")
	}
}

// 左侧公共信息获取。
func (this *UserController) leftInfo() (userinfo models.VUser) {
	userid := (this.GetSession("userid")).(int64)
	// 读取用户信息。后期可以放入缓存。
	o := orm.NewOrm()
	sql := "SELECT * FROM v_user WHERE userid = ? LIMIT 1"
	o.Raw(sql, userid).QueryRow(&userinfo)
	return userinfo
}

// 用户中心首页。
func (this *UserController) Index() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	// 取记录条数。
	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_course WHERE recommend = 1 "
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
	var Course []models.VCourse
	sql := "SELECT * FROM v_course WHERE recommend = 1 LIMIT ?, ? "
	o.Raw(sql, OPage.Offset, OPage.Count).QueryRows(&Course)

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
	this.TplNames = AppTheme + "/User/Index.tpl"
}

// 个人信息。
// -- 1、如果邮箱有修改，则要将邮箱激活状态重置为未激活状态0.
func (this *UserController) UserInfo() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	if this.Ctx.Input.Method() == "POST" {
		nickname := this.GetString("nickname") // 昵称。
		email := this.GetString("email")       // 邮箱。
		sex, _ := this.GetInt("sex")           // 性别。

		if len(nickname) > 30 {
			this.Tip("昵称长度不能超过10个字符", 1, "/user/userinfo")
		}

		if sex < 0 && sex > 2 {
			sex = 0
		}

		if len(email) > 0 {
			// 验证用户名格式。
			type EmailData struct {
				Email string
			}
			emaildata := EmailData{Email: email}
			valid := validation.Validation{}
			valid.Email(emaildata.Email, email)
			if valid.HasErrors() {
				services.AppLog.Info("UserController:UserInfo:10000:邮件格式不正确")
				this.Tip("邮箱格式不正确", 1, "/user/userinfo")
			}
		}

		// 更新数据库。
		o := orm.NewOrm()
		sql := "UPDATE v_user SET realname = ?, email = ?, sex = ? WHERE userid = ?"
		_, err := o.Raw(sql, nickname, email, sex, userinfo.Userid).Exec()
		if err != nil {
			services.AppLog.Critical("UserController:UserInfo:10001:用户信息更新失败")
			this.Tip("服务器繁忙，请稍候重试", 1, "/user/userinfo")
		}

		// 邮箱状态重置判断。
		if userinfo.Email != email {
			o.Raw("UPDATE v_user SET isactive = ? WHERE userid = ? LIMIT 1", 0, userinfo.Userid).Exec()
		}

		// 使COOKIE失效，避免浏览器COOKIE未失效而显示登录状态。
		this.Ctx.SetCookie("username", userinfo.Username, 0, "/")
		this.Ctx.SetCookie("realname", nickname, 0, "/")

		this.Tip("个人信息修改成功", 1, "/user/userinfo")
	}

	this.TplNames = AppTheme + "/User/UserInfo.tpl"
}

// 激活邮箱。
// -- 1、判断是否有邮箱。
// -- 2、判断是否激活。
// -- 3、发送激活邮件。
// -- 4、此邮件必须登录才能操作。
// -- 5、每次用户修改邮箱，要把激活字段更新为未激活。
func (this *UserController) SendActivateMail() {
	userinfo := this.leftInfo()
	if len(userinfo.Email) == 0 {
		this.Data["json"] = map[string]string{"status": "0", "message": "邮箱没有设置，请设置后再来激活"}
		this.ServeJson()
		this.StopRun()
	}
	if userinfo.Isactive == 1 {
		this.Data["json"] = map[string]string{"status": "0", "message": "邮箱已经激活了，请勿反复激活"}
		this.ServeJson()
		this.StopRun()
	}
	// 以下生成邮件激活信息并发送到邮箱。
	siteurl := this.Ctx.Input.Site()
	Nanoseconds := time.Now().UnixNano()
	uniqid := strconv.FormatInt(Nanoseconds, 10) + userinfo.Email + userinfo.Username + userinfo.Salt
	h := md5.New()
	io.WriteString(h, uniqid)
	uniqid = fmt.Sprintf("%x", h.Sum(nil))
	addtime := time.Now().Unix()

	// 往验证信息表插入。
	o := orm.NewOrm()
	_, err := o.Raw("INSERT INTO v_code (addtime, typeid, valitime, userid, codetext) VALUES(?, ?, ?, ?, ?)", addtime, 2, 3600, userinfo.Userid, uniqid).Exec()
	if err != nil {
		services.AppLog.Critical("UserController:SendActivateMail:10002:用户邮箱激活时生成验证码失败")
		this.Data["json"] = map[string]string{"status": "0", "message": "服务器繁忙，请稍息操作"}
		this.ServeJson()
		this.StopRun()
	}

	siteurl += "/Index/ProcessMailActivate?code=" + uniqid
	message := `《` + SiteName + `》邮箱激活，请在一小时内点击下面链接进行操作，<a href="` + siteurl + `">请点击</a> 或者将网址复制到浏览器：` + siteurl
	mailSubject := `《` + SiteName + `》邮箱激活邮件`
	go services.SendMail(userinfo.Email, mailSubject, message, "html")

	this.Data["json"] = map[string]string{"status": "1", "message": "密码找回邮件已经发送到邮件，请查收"}
	this.ServeJson()
	this.StopRun()
}

// 修改密码。
// -- 修改密码也要修改盐。
func (this *UserController) EditPwd() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	if this.Ctx.Input.Method() == "POST" {
		oldPwd := this.GetString("oldPwd") // 旧密码。
		newPwd := this.GetString("newPwd") // 新密码。
		verify := this.GetString("verify") // 确认密码。

		oldPwdLength := len(oldPwd)
		newPwdLength := len(newPwd)
		verifyLength := len(verify)

		if oldPwdLength == 0 {
			this.Tip("旧密码没有输入", 1, "/user/editpwd")
		}

		if newPwdLength == 0 {
			this.Tip("新密码没有输入", 1, "/user/editpwd")
		}

		if newPwdLength < 6 || newPwdLength > 20 {
			this.Tip("密码长度必须6到20之间", 1, "/user/editpwd")
		}

		if verifyLength == 0 {
			this.Tip("确认密码没有输入", 1, "/user/editpwd")
		}

		if newPwd != verify {
			this.Tip("新密码与确认密码不相同", 1, "/user/editpwd")
		}

		h := md5.New()
		io.WriteString(h, oldPwd)
		oldPwd = fmt.Sprintf("%x", h.Sum(nil)) + userinfo.Salt
		h = md5.New()
		io.WriteString(h, oldPwd)
		oldPwd = fmt.Sprintf("%x", h.Sum(nil))

		if oldPwd != userinfo.Password {
			this.Tip("旧密码错误", 1, "/user/editpwd")
		}

		salt := services.GetRandomString(6) // 盐。修改密码的同时，也要修改盐。
		h = md5.New()
		io.WriteString(h, newPwd)
		newPwd = fmt.Sprintf("%x", h.Sum(nil)) + salt
		h = md5.New()
		io.WriteString(h, newPwd)
		newPwd = fmt.Sprintf("%x", h.Sum(nil))

		o := orm.NewOrm()
		sql := "UPDATE v_user SET password = ?, salt = ? WHERE userid = ?"
		_, err := o.Raw(sql, newPwd, salt, userinfo.Userid).Exec()
		if err != nil {
			services.AppLog.Critical("UserController:EditPwd:10003:密码修改失败")
			this.Tip("服务器繁忙，请稍候修改密码", 1, "/user/editpwd")
		} else {
			this.Tip("密码修改成功", 1, "/user/editpwd")
		}
	}

	this.TplNames = AppTheme + "/User/EditPwd.tpl"
}

// 更新头像。
func (this *UserController) UpdateAvatar() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	if this.Ctx.Input.Method() == "POST" {
		if this.Ctx.Input.IsUpload() {
			file, FileHeader, err := this.GetFile("avatar")
			var allowImageExt []string = []string{".jpg", ".jpeg", ".gif", ".bmp", ".png"}
			fileExt := filepath.Ext(FileHeader.Filename) // 取扩展名。
			addtime := time.Now().Format("200601")       // 文件保存的文件夹名称。

			b := false
			fileExt = strings.ToLower(fileExt)
			for _, v := range allowImageExt {
				if fileExt == v {
					b = true
				}
			}
			if b == false {
				this.Tip("图片格式不正确", 1, "/user/updateavatar")
			}

			// 取得当前脚本路径
			_, filetName, _, _ := runtime.Caller(0)
			// 取当前项目所在目录。
			dirName := filepath.Dir(filepath.Dir(filetName))
			uploadPath := dirName + "/static/Upload/Avatars/" + addtime + "/"
			os.MkdirAll(uploadPath, 0777) // 循环创建目录
			newFilename := uploadPath + userinfo.Username + fileExt
			avatarPath := "/static/Upload/Avatars/" + addtime + "/" + userinfo.Username + fileExt

			// 保存文件
			if err != nil {
				this.Tip("头像上传失败", 1, "/user/updateavatar")
			}
			defer file.Close()
			f, err := os.OpenFile(newFilename, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)
			if err != nil {
				services.AppLog.Critical("UserController:UpdateAvatar:20000:头像上传失败")
				this.Tip("服务器繁忙，请稍候重试", 1, "/user/updateavatar")
			}
			defer f.Close()
			_, err = io.Copy(f, file) // 移动文件。

			// 更新数据库记录。
			o := orm.NewOrm()
			sql := "UPDATE v_user SET avatar = ? WHERE userid = ? LIMIT 1"
			_, err = o.Raw(sql, avatarPath, userinfo.Userid).Exec()
			if err != nil {
				this.Tip("服务器繁忙，请稍候重试", 1, "/user/updateavatar")
			}
			this.Tip("头像更新成功", 1, "/user/updateavatar")
		}
	}

	this.TplNames = AppTheme + "/User/UpdateAvatar.tpl"
}

// 我的课程。
func (this *UserController) MyCourse() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_user_course AS a LEFT JOIN v_course AS b ON(a.courseid=b.courseid) WHERE b.display = 1 AND a.userid = ? "
	o.Raw(countSql, userinfo.Userid).QueryRow(&CountData)
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
	sql := "SELECT b.* FROM v_user_course AS a LEFT JOIN v_course AS b ON(a.courseid=b.courseid) WHERE b.display = 1 AND a.userid = ? ORDER BY a.ucid DESC LIMIT ?, ? "
	num, err := o.Raw(sql, userinfo.Userid, OPage.Offset, OPage.Count).QueryRows(&Course)
	if num == 0 && err != nil {
		fmt.Println(err)
	}

	this.Data["Course"] = Course
	this.Data["Page"] = OPage
	this.TplNames = AppTheme + "/User/MyCourse.tpl"
}

// 我的笔记。
func (this *UserController) MyNote() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_note WHERE userid = ? "
	o.Raw(countSql, userinfo.Userid).QueryRow(&CountData)
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
		"FROM v_note AS a LEFT JOIN v_course AS b ON(a.relateid=b.courseid) WHERE a.userid = ? LIMIT ?, ? "
	num, err := o.Raw(sql, userinfo.Userid, OPage.Offset, OPage.Count).QueryRows(&NoteList)
	if num == 0 && err != nil {
		fmt.Println(err)
	}

	this.Data["NoteList"] = NoteList
	this.Data["Page"] = OPage
	this.TplNames = AppTheme + "/User/MyNote.tpl"
}

// 添加笔记。
// todolist:
// --1、未做笔记内容做过滤操作。
// --2、应该增加一个显示代码与图片的功能。即阉割版的富文本编辑器。
func (this *UserController) AddNote() {
	if this.Ctx.Input.Method() == "POST" {
		userinfo := this.leftInfo()
		this.Data["userinfo"] = userinfo

		typeid, _ := this.GetInt("typeid")     // 笔记类型
		relateid, _ := this.GetInt("relateid") // 关联ID
		content := this.GetString("content")   // 笔记内容

		if typeid == 0 && typeid > 4 {
			this.Data["json"] = map[string]string{"status": "1", "message": "参数异常"}
			this.ServeJson(true)
			this.StopRun()
		}

		if len(content) == 0 {
			this.Data["json"] = map[string]string{"status": "2", "message": "笔记内容没有填写"}
			this.ServeJson(true)
			this.StopRun()
		}

		if len(content) > 10000 {
			this.Data["json"] = map[string]string{"status": "3", "message": "笔记内容不能超过10000个字符"}
			this.ServeJson(true)
			this.StopRun()
		}

		o := orm.NewOrm()
		switch typeid {
		case 1: // 视频笔记。
			var video models.VVideo
			o.Raw("SELECT * FROM v_video WHERE videoid = ?", relateid).QueryRow(&video)
			if video.Videoid == 0 {
				this.Data["json"] = map[string]string{"status": "4", "message": "服务器繁忙，请稍候重试"}
				this.ServeJson(true)
				this.StopRun()
			}
		case 2: // 课程笔记。
			var course models.VCourse
			o.Raw("SELECT * FROM v_course WHERE dispaly = 1 AND courseid = ?", relateid).QueryRow(&course)
			if course.Courseid == 0 {
				this.Data["json"] = map[string]string{"status": "4", "message": "服务器繁忙，请稍候重试"}
				this.ServeJson(true)
				this.StopRun()
			}
		case 3: // 文档笔记。
			//var doc models.VDoc
			//o.Raw("SELECT * FROM v_doc WHERE docid = ?", relateid).QueryRow(&doc)
			//if doc.Docid == 0 {
			//	this.Data["json"] = map[string]string{"status": "4", "message": "服务器繁忙，请稍候重试"}
			//	this.ServeJson(true)
			//	this.StopRun()
			//}
		case 4: // 试题笔记。
			var question models.VQuestion
			o.Raw("SELECT * FROM v_question WHERE qid = ? AND display = 1", relateid).QueryRow(&question)
			if question.Qid == 0 {
				this.Data["json"] = map[string]string{"status": "4", "message": "服务器繁忙，请稍候重试"}
				this.ServeJson(true)
				this.StopRun()
			}
		}

		var NoteData models.VNote
		sql := "SELECT * FROM v_note WHERE userid = ? AND typeid = ? AND relateid = ?"
		o.Raw(sql, userinfo.Userid, typeid, relateid).QueryRow(&NoteData)
		if NoteData.Noteid != 0 {
			this.Data["json"] = map[string]string{"status": "5", "message": "已经存在此笔记，建议在此笔记中编辑。"}
			this.ServeJson(true)
			this.StopRun()
		}

		sql = "INSERT INTO v_note (noteid, typeid, relateid, userid, addtime, lasttime, content) VALUES (NULL, ?, ?, ?, ?, ?, ?)"
		addtime := time.Now().Format("2006-01-02 15:04:05")
		_, err := o.Raw(sql, typeid, relateid, userinfo.Userid, addtime, addtime, content).Exec()
		if err != nil {
			services.AppLog.Critical("UserController:AddNote:10004:笔记入库失败")
			this.Data["json"] = map[string]string{"status": "6", "message": "服务器繁忙，请稍候重试"}
			this.ServeJson(true)
			this.StopRun()
		} else {
			this.Data["json"] = map[string]string{"status": "0", "message": "添加笔记成功"}
			this.ServeJson(true)
			this.StopRun()
		}
	}
	this.StopRun()
}

// 我的好友。
func (this *UserController) MyFriend() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_friend WHERE userid = ? "
	o.Raw(countSql, userinfo.Userid).QueryRow(&CountData)
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
	var FriendList []services.FriendInfo
	sql := "SELECT a.friendid,b.userid,b.username,a.addtime,b.realname,b.sex,b.avatar,b.level " +
		"FROM v_friend AS a LEFT JOIN v_user AS b ON(a.fuserid=b.userid) WHERE a.userid = ? LIMIT ?, ? "
	num, err := o.Raw(sql, userinfo.Userid, OPage.Offset, OPage.Count).QueryRows(&FriendList)
	if num == 0 && err != nil {
		fmt.Println(err)
	}

	this.Data["FriendList"] = FriendList
	this.Data["Page"] = OPage
	this.TplNames = AppTheme + "/User/MyFriend.tpl"
}

// 添加好友。
func (this *UserController) AddFriend() {
	if this.Ctx.Input.Method() == "POST" {
		userinfo := this.leftInfo()
		this.Data["userinfo"] = userinfo

		friendid, _ := this.GetInt("friendid")
		if friendid <= 0 {
			this.Data["json"] = map[string]string{"status": "1", "message": "参数异常"}
			this.ServeJson(true)
			this.StopRun()
		}

		o := orm.NewOrm()
		var userdata models.VUser
		sql := "SELECT * FROM v_user WHERE userid = ?"
		o.Raw(sql, friendid).QueryRow(&userdata)
		if userdata.Userid == 0 {
			this.Data["json"] = map[string]string{"status": "2", "message": "用户不存在"}
			this.ServeJson(true)
			this.StopRun()
		}

		var Friend models.VFriend
		sql = "SELECT * FROM v_friend WHERE userid = ? AND fuserid = ?"
		o.Raw(sql, userinfo.Userid, friendid).QueryRow(&Friend)
		if Friend.Friendid != 0 {
			this.Data["json"] = map[string]string{"status": "3", "message": "已经存在此好友"}
			this.ServeJson(true)
			this.StopRun()
		}

		sql = "INSERT INTO v_friend VALUES(NULL, ?, ?, ?)"
		addtime := time.Now().Format("2006-01-02 15:04:05")
		_, err := o.Raw(sql, userinfo.Userid, friendid, addtime).Exec()
		if err != nil {
			this.Data["json"] = map[string]string{"status": "4", "message": "服务器繁忙，请稍候重试"}
			this.ServeJson(true)
			this.StopRun()
		} else {
			this.Data["json"] = map[string]string{"status": "0", "message": "添加好友成功"}
			this.ServeJson(true)
			this.StopRun()
		}
	}
	this.StopRun()
}

// 查看留言。
func (this *UserController) ViewComment() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_comment WHERE userid = ? AND typeid = ? "
	o.Raw(countSql, userinfo.Userid, 3).QueryRow(&CountData)
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
		"FROM v_comment AS a LEFT JOIN v_user AS b ON(a.touserid=b.userid) WHERE a.userid = ? AND a.typeid = ? LIMIT ?, ? "
	num, err := o.Raw(sql, userinfo.Userid, 3, OPage.Offset, OPage.Count).QueryRows(&CommentList)
	if num == 0 && err != nil {
		fmt.Println(err)
	}

	this.Data["CommentList"] = CommentList
	this.Data["Page"] = OPage
	this.TplNames = AppTheme + "/User/ViewComment.tpl"
}

// 给我的留言。
func (this *UserController) ViewMyComment() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_comment WHERE touserid = ? AND typeid = ? "
	o.Raw(countSql, userinfo.Userid, 3).QueryRow(&CountData)
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
	sql := "SELECT a.commentid,b.username,b.realname,b.avatar,b.sex,a.userid,a.relateid,b.level,a.addtime,a.content " +
		"FROM v_comment AS a LEFT JOIN v_user AS b ON(a.userid=b.userid) WHERE a.touserid = ? AND a.typeid = ? LIMIT ?, ? "
	num, err := o.Raw(sql, userinfo.Userid, 3, OPage.Offset, OPage.Count).QueryRows(&CommentList)
	if num == 0 && err != nil {
		fmt.Println(err)
	}

	this.Data["CommentList"] = CommentList
	this.Data["Page"] = OPage
	this.TplNames = AppTheme + "/User/ViewMyComment.tpl"
}

// 添加留言/评论。
// -- 留言直接过滤。
func (this *UserController) AddComment() {
	if this.Ctx.Input.Method() == "POST" {
		userinfo := this.leftInfo()
		this.Data["userinfo"] = userinfo

		typeid, _ := this.GetInt("typeid")     // 笔记类型
		relateid, _ := this.GetInt("relateid") // 关联ID
		content := this.GetString("content")   // 笔记内容
		touserid, _ := this.GetInt("touserid") // 被留言人的ID。
		fStar, _ := this.GetFloat("star")      // 评星。
		star := int(fStar)

		if typeid == 0 && typeid > 4 {
			this.Data["json"] = map[string]string{"status": "1", "message": "参数异常"}
			this.ServeJson(true)
			this.StopRun()
		}

		if len(content) == 0 {
			this.Data["json"] = map[string]string{"status": "2", "message": "内容不能为空"}
			this.ServeJson(true)
			this.StopRun()
		}

		if len(content) > 10000 {
			this.Data["json"] = map[string]string{"status": "3", "message": "笔记内容不能超过10000个字符"}
			this.ServeJson(true)
			this.StopRun()
		}

		if star <= 0 || star > 5 {
			star = 5
		}

		o := orm.NewOrm()
		switch typeid {
		case 1: // 视频评论。
			var video models.VVideo
			o.Raw("SELECT * FROM v_video WHERE videoid = ?", relateid).QueryRow(&video)
			if video.Videoid == 0 {
				this.Data["json"] = map[string]string{"status": "4", "message": "服务器繁忙，请稍候重试"}
				this.ServeJson(true)
				this.StopRun()
			}
			if CommentAlert {
				message := `《` + SiteName + `》的视频《` + video.Videoname + `》有了新评论`
				go services.SendMail(AdminMail, "网站新评论", message, "html")
			}
		case 2: // 课程评论。
			var course models.VCourse
			o.Raw("SELECT * FROM v_course WHERE display = 1 AND courseid = ?", relateid).QueryRow(&course)
			if course.Courseid == 0 {
				this.Data["json"] = map[string]string{"status": "4", "message": "服务器繁忙，请稍候重试"}
				this.ServeJson(true)
				this.StopRun()
			}
			// 更新课程评星与评论次数。
			o.Raw("UPDATE v_course SET star=star+?,appraise=appraise+1 WHERE courseid = ?", star, course.Courseid).Exec()

			if CommentAlert {
				message := `《` + SiteName + `》的课程《` + course.Coursename + `》有了新评论`
				go services.SendMail(AdminMail, "网站新评论", message, "html")
			}
		case 3: // 留言评论。
			var userdata models.VUser
			o.Raw("SELECT * FROM v_user WHERE userid = ?", touserid).QueryRow(&userdata)
			if userdata.Userid == 0 {
				this.Data["json"] = map[string]string{"status": "4", "message": "服务器繁忙，请稍候重试"}
				this.ServeJson(true)
				this.StopRun()
			}
			if CommentAlert {
				message := `《` + SiteName + `》有人给网站留言了`
				go services.SendMail(AdminMail, "网站新评论", message, "html")
			}
		case 4: // 反馈评论。
			// 当前反馈是否关闭。
			isFeedOpen := true
			if isFeedOpen == false {
				this.Data["json"] = map[string]string{"status": "4", "message": "反馈功能已经关闭，等待再次开放。"}
				this.ServeJson(true)
				this.StopRun()
			}
			if CommentAlert {
				message := `《` + SiteName + `》有人给网站反馈了`
				go services.SendMail(AdminMail, "网站新评论", message, "html")
			}
		case 5: // 文章评论。
			var news models.VNews
			o.Raw("SELECT * FROM v_news WHERE display = 1 AND newsid = ?", relateid).QueryRow(&news)
			if news.Newsid == 0 {
				this.Data["json"] = map[string]string{"status": "4", "message": "服务器繁忙，请稍候重试"}
				this.ServeJson(true)
				this.StopRun()
			}
			// 更新课程评星与评论次数。
			o.Raw("UPDATE v_news SET star=star+?,appraise=appraise+1 WHERE courseid = ?", star, news.Newsid).Exec()
			if CommentAlert {
				message := `《` + SiteName + `》的文章《` + news.Title + `》有了新评论`
				go services.SendMail(AdminMail, "网站新评论", message, "html")
			}
		}

		sql := "INSERT INTO v_comment (commentid, userid, touserid, relateid, typeid, addtime, content, star) VALUES(NULL, ?, ?, ?, ?, ?, ?, ?)"
		addtime := time.Now().Format("2006-01-02 15:04:05")
		_, err := o.Raw(sql, userinfo.Userid, touserid, relateid, typeid, addtime, content, star).Exec()
		if err != nil {
			fmt.Println(err)
			this.Data["json"] = map[string]string{"status": "6", "message": "服务器繁忙，请稍候重试"}
			this.ServeJson(true)
			this.StopRun()
		} else {
			this.Data["json"] = map[string]string{"status": "0", "message": "添加成功"}
			this.ServeJson(true)
			this.StopRun()
		}
	}
	this.StopRun()
}

// 我的收藏。
func (this *UserController) MyFavorites() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	userid := userinfo.Userid // 用户ID。

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_favorite AS a LEFT JOIN v_course AS b ON(a.courseid=b.courseid) WHERE b.display = 1 AND a.userid = ? "
	o.Raw(countSql, userid).QueryRow(&CountData)
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
	sql := "SELECT b.* FROM v_favorite AS a LEFT JOIN v_course AS b ON(a.courseid=b.courseid) WHERE b.display = 1 AND a.userid = ? LIMIT ?, ? "
	o.Raw(sql, userid, OPage.Offset, OPage.Count).QueryRows(&Course)

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
	this.TplNames = AppTheme + "/User/MyFavorites.tpl"
}

// 添加收藏。
func (this *UserController) AddFavorite() {
	if this.Ctx.Input.Method() == "POST" {
		userinfo := this.leftInfo()
		this.Data["userinfo"] = userinfo

		courseid, _ := this.GetInt("courseid")
		if courseid <= 0 {
			this.Data["json"] = map[string]string{"status": "1", "message": "参数异常"}
			this.ServeJson(true)
			this.StopRun()
		}

		o := orm.NewOrm()
		var course models.VCourse
		sql := "SELECT * FROM v_course WHERE display = 1 AND courseid = ?"
		o.Raw(sql, courseid).QueryRow(&course)
		if course.Courseid == 0 {
			this.Data["json"] = map[string]string{"status": "2", "message": "课程不存在"}
			this.ServeJson(true)
			this.StopRun()
		}

		var favorite models.VFavorite
		sql = "SELECT * FROM v_favorite WHERE courseid = ? AND userid = ?"
		o.Raw(sql, courseid, userinfo.Userid).QueryRow(&favorite)
		if favorite.Favoriteid != 0 {
			this.Data["json"] = map[string]string{"status": "3", "message": "已经存在此收藏"}
			this.ServeJson(true)
			this.StopRun()
		}

		sql = "INSERT INTO v_favorite VALUES(NULL, ?, ?, ?)"
		addtime := time.Now().Format("2006-01-02 15:04:05")
		_, err := o.Raw(sql, courseid, userinfo.Userid, addtime).Exec()
		if err != nil {
			this.Data["json"] = map[string]string{"status": "4", "message": "服务器繁忙，请稍候重试"}
			this.ServeJson(true)
			this.StopRun()
		} else {
			this.Data["json"] = map[string]string{"status": "0", "message": "收藏成功"}
			this.ServeJson(true)
			this.StopRun()
		}
	}
	this.StopRun()
}

// 用户充值记录页面。
func (this *UserController) UserAlipay() {
	// 左侧用户信息获取。
	userinfo := this.leftInfo()
	this.Data["userinfo"] = userinfo

	userid := userinfo.Userid // 用户ID。

	o := orm.NewOrm()
	var CountData models.SqlData
	countSql := "SELECT COUNT(1) AS count FROM v_order WHERE userid = ?"
	o.Raw(countSql, userid).QueryRow(&CountData)
	total := CountData.Count

	// 分页处理
	page, _ := this.GetInt("page") // 当前页。
	var OPage services.Page
	OPage.Request = this.Ctx.Request
	OPage.PageNumber = page
	OPage.Total = total
	OPage.PageSize = 10
	OPage.Page()

	// 取列表数。
	var orders []models.VOrder
	sql := "SELECT * FROM v_order WHERE userid = ? ORDER BY id DESC LIMIT ?, ? "
	o.Raw(sql, userid, OPage.Offset, OPage.Count).QueryRows(&orders)

	this.Data["orders"] = orders
	this.Data["Page"] = OPage
	this.TplNames = AppTheme + "/User/UserAlipay.tpl"
}

// 支付宝充值页面。
func (this *UserController) Alipay() {

	if this.Ctx.Input.Method() == "POST" {
		// 创建订单。
		userinfo := this.leftInfo()

		money, _ := this.GetInt("money")
		if money < 5 || money > 1000 {
			this.Tip("我们只接受5元到1000元之间的充值额度。感谢您的支持！", 2, "")
		}
		remark := this.GetString("remark")
		if len(remark) == 0 {
			remark = "WEB开发云课堂视频学习充值"
		}

		addtime := time.Now().Format("2006-01-02 15:04:05")

		// 生成订单号，规则：A + 当前纳秒。
		Nanoseconds := time.Now().UnixNano()
		orderno := "A" + strconv.FormatInt(Nanoseconds, 10)

		o := orm.NewOrm()
		insertSql := "INSERT INTO v_order (orderno, userid, username, money, status, paytype, addtime, remark)" +
			" VALUES(?, ?, ?, ?, ?, ?, ?, ?)"
		_, err := o.Raw(insertSql, orderno, userinfo.Userid, userinfo.Username, money, 0, 1, addtime, remark).Exec()
		if err != nil {
			services.AppLog.Critical("UserController:Alipay:10005:订单信息入库失败")
			this.Tip("服务器繁忙，请稍候重试。感谢您的支持。", 3, "")
		} else {
			// 通知系统管理员。
			message := `《` + SiteName + `》有人创建了充值订单，人民币金额为：` + strconv.FormatInt(money, 10) + `元，等待付款中，请知悉！`
			go services.SendMail(AdminMail, "充值订单创建成功通知", message, "html")

			this.Redirect("/user/alipayverify?orderno="+orderno, 302)
			return
		}
	} else {
		this.TplNames = AppTheme + "/User/Alipay.tpl"
	}
}

// 订单支付确认页面。
func (this *UserController) AlipayVerify() {
	orderno := this.GetString("orderno")
	if len(orderno) == 0 {
		services.AppLog.Critical("UserController:AlipayVerify:10006:订单号异常")
		this.Tip("订单号参数异常", 1, "/User/UserAlipay")
	}

	o := orm.NewOrm()
	var orderinfo models.VOrder
	o.Raw("SELECT * FROM v_order WHERE orderno = ?", orderno).QueryRow(&orderinfo)
	if orderinfo.Id == 0 {
		services.AppLog.Critical("UserController:AlipayVerify:10007:订单不存在")
		this.Tip("订单不存在，请勿更改参数", 1, "/User/UserAlipay")
	}

	userinfo := this.leftInfo()

	siteurl := this.Ctx.Input.Site()

	// 获取支付页面的HTML信息。
	var order services.Request
	order.PaymentType = "1"
	order.Subject = "WEB开发云课堂视频学习充值"
	order.OutTradeNo = orderinfo.Orderno
	order.Body = "WEB开发云课堂是专业的有偿技术分享型网站。简单快速有效的技术提升路线，一顿早餐钱就可以搞定。您还在等什么呢？"
	order.ShowUrl = siteurl + "/User/AlipayVerify?orderno=" + orderno
	order.LogisticsFee = "0.00"
	order.LogisticsType = "EXPRESS"
	order.LogisticsPayment = "SELLER_PAY"
	order.ReceiveName = userinfo.Realname
	order.ReceiveAddress = "广东省广州市"
	order.ReceiveZip = "10000"
	order.ReceivePhone = "010-1000000"
	order.ReceiveMobile = "13800000000"
	order.Price = strconv.FormatInt(orderinfo.Money, 10)
	order.NotifyUrl = siteurl + "/User/NotifyUrl"
	order.ReturnUrl = siteurl + "/User/ReturnUrl"
	order.Quantity = "1"
	html := order.NewPage()

	this.Data["orderHtml"] = html
	this.Data["order"] = orderinfo
	this.TplNames = AppTheme + "/User/AlipayVerify.tpl"
}

// 订单充值同步通知页面。
func (this *UserController) ReturnUrl() {

	userinfo := this.leftInfo()

	// 取URL Query
	query := this.Ctx.Input.Uri()
	values, err := url.ParseQuery(query)
	if err != nil {
		services.AppLog.Critical("UserController:ReturnUrl:10008:订单参数解析异常")
		this.Tip("非常抱歉，服务器异常。", 1, "/User/UserAlipay")
	}

	err = services.AplipayVerifySign(values)
	if err != nil {
		services.AppLog.Critical("UserController:ReturnUrl:10009:订单签名判断异常")
		this.Tip("服务器异常，请稍候再试", 1, "/User/UserAlipay")
	} else {
		this.Tip("URL验证码失败或已经过期", 1, "/User/UserAlipay")
	}

	out_trade_no := this.GetString("out_trade_no") // 订单号。
	trade_status := this.GetString("trade_status") // 交易状态。

	// 订单不存在。
	o := orm.NewOrm()
	var orderInfo models.VOrder
	o.Raw("SELECT * FROM v_order WHERE orderno = ?", out_trade_no).QueryRow(&orderInfo)
	if orderInfo.Id == 0 {
		services.AppLog.Critical("UserController:ReturnUrl:10010:订单不存在或已经失效")
		this.Tip("订单不存在或已经失效", 1, "/User/UserAlipay")
	}

	status := 0
	if trade_status == "WAIT_BUYER_PAY" {
		// 该判断表示买家已在支付宝交易管理中产生了交易记录，但没有付款
		status = 0 // 未支付
	} else if trade_status == "WAIT_SELLER_SEND_GOODS" {
		status = 1 // 等待发货
		// 该判断表示买家已在支付宝交易管理中产生了交易记录且付款成功，但卖家没有发货
	} else if trade_status == "WAIT_BUYER_CONFIRM_GOODS" {
		status = 2 // 未确认收货
		// 该判断表示卖家已经发了货，但买家还没有做确认收货的操作
	} else if trade_status == "TRADE_FINISHED" {
		status = 3 // 交易成功
		// 该判断表示买家已经确认收货，这笔交易完成
	}

	// 发送付款成功邮件通知系统管理员。
	if status == 3 {
		// 通知系统管理员。
		message := `《` + SiteName + `》的会员:` + userinfo.Username + `付款成功，人民币金额为：` + strconv.FormatInt(orderInfo.Money, 10) + `元`
		go services.SendMail(AdminMail, "购买成功通知", message, "html")
	}

	_, err = o.Raw("UPDATE v_order SET status = ? WHERE orderno = ?", status, out_trade_no).Exec()
	if err != nil {
		services.AppLog.Critical("UserController:ReturnUrl:10011:订单状态更新失败")
		this.Tip("服务器繁忙，请稍候再试", 1, "/User/UserAlipay")
	}

	o.Raw("SELECT * FROM v_order WHERE orderno = ?", out_trade_no).QueryRow(&orderInfo)
	if orderInfo.Id == 0 {
		services.AppLog.Critical("UserController:ReturnUrl:10012:订单不存在或已经失败")
		this.Tip("订单不存在或已经失效", 1, "/User/UserAlipay")
	}

	this.Data["orderInfo"] = orderInfo
	this.TplNames = AppTheme + "/User/ReturnUrl.tpl"
}

// 订单充值成功通知页面。
// -- 1、验证参数是否合法。
// -- 2、读取付款状态。
// -- 3、判断订单是否重复处理了。
func (this *UserController) NotifyUrl() {
	// 取URL Query
	query := this.Ctx.Input.Uri()
	values, err := url.ParseQuery(query)
	if err != nil {
		this.StopRun()
		// 打日志
	}

	err = services.AplipayVerifySign(values)
	if err != nil {
		this.StopRun()
		// 打日志。
	} else {
		this.Ctx.WriteString("fail")
		this.StopRun()
	}

	out_trade_no := this.GetString("out_trade_no") // 订单号。
	//	trade_no := this.GetString("trade_no")         // 支付宝交易号。
	trade_status := this.GetString("trade_status") // 交易状态。

	// 订单不存在。
	o := orm.NewOrm()
	var orderInfo models.VOrder
	o.Raw("SELECT * FROM v_order WHERE orderno = ?", out_trade_no).QueryRow(&orderInfo)
	if orderInfo.Id == 0 {
		this.Ctx.WriteString("fail")
		this.StopRun()
		// 打日志。
	}

	status := 0
	if trade_status == "WAIT_BUYER_PAY" {
		// 该判断表示买家已在支付宝交易管理中产生了交易记录，但没有付款
		status = 0 // 未支付
		this.Ctx.WriteString("success")
	} else if trade_status == "WAIT_SELLER_SEND_GOODS" {
		status = 1 // 等待发货
		// 该判断表示买家已在支付宝交易管理中产生了交易记录且付款成功，但卖家没有发货
		this.Ctx.WriteString("success")
	} else if trade_status == "WAIT_BUYER_CONFIRM_GOODS" {
		status = 2 // 未确认收货
		// 该判断表示卖家已经发了货，但买家还没有做确认收货的操作
		this.Ctx.WriteString("success")
	} else if trade_status == "TRADE_FINISHED" {
		status = 3 // 交易成功
		// 该判断表示买家已经确认收货，这笔交易完成
		this.Ctx.WriteString("success")
	} else {
		this.Ctx.WriteString("success")
	}

	_, err = o.Raw("UPDATE v_order SET status = ? WHERE orderno = ?", status, out_trade_no).Exec()
	if err != nil {
		// 服务器出现问题。
		// 打日志。
		this.Ctx.WriteString("fail")
	}

	this.StopRun()
}

// 获取当前登录用户信息。
func (this *UserController) GetUserinfo() {
	userinfo := this.leftInfo()
	this.Data["json"] = userinfo
	this.ServeJson(true)
	this.StopRun()
}

// 课程购买处理。
func (this *UserController) CourseBuy() {

	userinfo := this.leftInfo()

	if this.Ctx.Input.Method() == "POST" {
		courseid, _ := this.GetInt("courseid") // 课程ID。
		if courseid <= 0 {
			this.Tip("参数异常", 1, "/")
		}

		o := orm.NewOrm()
		var course models.VCourse
		o.Raw("SELECT * FROM v_course WHERE display = ? AND courseid = ? LIMIT 1", 1, courseid).QueryRow(&course)
		if course.Courseid == 0 {
			this.Tip("课程不存在或已经被管理员删除", 2, "/")
		}

		var UserCourse models.VUserCourse
		o.Raw("SELECT * FROM v_user_course WHERE userid = ? AND courseid = ? LIMIT 1", userinfo.Userid, courseid).QueryRow(&UserCourse)
		if UserCourse.Ucid > 0 {
			this.Tip("您已经购买了该课程，请勿重复操作", 2, "")
		}

		if userinfo.Cash < int64(course.Price) {
			this.Tip("您的余额不足，请充值后再购买", 2, "/User/Alipay")
		}

		addtime := time.Now().Format("2006-01-02 15:04:05")
		res, err := o.Raw("INSERT INTO v_user_course (userid, courseid, addtime) VALUES(?, ?, ?)", userinfo.Userid, courseid, addtime).Exec()
		if err != nil {
			this.Tip("服务器繁忙，请稍候重试", 2, "")
		}

		lastInsertID, _ := res.LastInsertId()
		if lastInsertID > 0 {
			// 将购买的课程添加的用户课程表中。
			o.Raw("UPDATE v_user SET cash = cash - ? WHERE userid = ? LIMIT 1", course.Price, userinfo.Userid).Exec()
			courseUrl := "/Index/VideoView?courseid=" + strconv.FormatInt(courseid, 10)
			// 课程购买次数+1
			o.Raw("UPDATE v_course SET buytimes=buytimes+1 WHERE courseid = ? LIMIT 1", courseid).Exec()
			this.Tip("恭喜您,购买成功!", 3, courseUrl)
		} else {
			this.Tip("服务器繁忙，请稍候重试", 2, "")
		}
	}
}
