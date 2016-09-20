// 公共Controller。
// @author 寒冰。
// @date 2013年12月14日。

package controllers

import (
	"errors"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/validation"
)

var Originator string  // 读取创建人配置，此人拥有系统最高权限。
var SiteName string    // 网站名称。如：每天必看网。
var AdminMail string   // 系统管理员邮箱。接收系统错误提示。
var CommentAlert bool  // 评论提醒功能开关。通过读取配置转换为布尔类型。
var WeixinToken string // 微信公众平台Token

// SEO
var SiteTitle string // 网站标题。
var SiteDesc string  // 网站介绍。
var SiteKeys string  // 网站关键字。

// 主题。
var AppTheme string

// 做一些系统初始化的工作，以及配置验证码工作。
func init() {
	Originator = beego.AppConfig.String("originator")
	AppTheme = beego.AppConfig.String("AppTheme")
	SiteName = beego.AppConfig.String("SiteName")
	AdminMail = beego.AppConfig.String("AdminMail")
	WeixinToken = beego.AppConfig.String("WeixinToken")

	// SEO
	SiteTitle = beego.AppConfig.String("SiteTitle")
	SiteDesc = beego.AppConfig.String("SiteDesc")
	SiteKeys = beego.AppConfig.String("SiteKeys")

	// 评论提醒开关。
	CommentAlertConfig := beego.AppConfig.String("CommentAlert")
	if CommentAlertConfig != "1" {
		CommentAlert = false
	} else {
		CommentAlert = true
	}

	if len(SiteName) == 0 {
		err := errors.New("SiteName without configuration")
		panic(err)
	}

	if len(AdminMail) == 0 {
		err := errors.New("AdminMail configuration errors")
		panic(err)
	}

	// 验证邮箱格式。
	type EmailData struct {
		Email string
	}
	emailinfo := EmailData{Email: AdminMail}
	valid := validation.Validation{}
	valid.Email(emailinfo.Email, AdminMail)
	if valid.HasErrors() {
		err := errors.New("AdminMail configuration format is illegal")
		panic(err)
	}
}

// 题目类型
var QuestionType = map[int]string{1: "单选", 2: "多选", 3: "判断", 4: "填空", 5: "解答", 6: "作文"}

type CommonController struct {
	beego.Controller
}

// 提示页面。
// @param Message 提示信息。
// @param Second 提示信息跳转前等待秒数。
// @param Url 跳转的URL。
func (this *CommonController) Tip(Message string, Second int, Url string) {

	// 如果Url为空，则跳转到上一页。
	if Url == "" {
		Url = this.Ctx.Input.Refer()
	}

	// 当为Ajax操作的时候，一律返回一个Map。Map中必须携带status
	if this.Ctx.Input.IsAjax() {
		this.Data["json"] = map[string]string{"status": "403", "message": "请登录"}
		this.ServeJson(true)
		this.StopRun()
	} else {
		this.Data["Message"] = Message
		this.Data["Second"] = Second
		this.Data["Url"] = Url
		this.TplNames = AppTheme + "/Public/tip.tpl"
		this.Render()
		this.StopRun()
	}
}
