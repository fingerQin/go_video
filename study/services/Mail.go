// 邮件插件。
// @author 寒冰
// @date 2014年1月1日
// -- 1、邮件必须设置多个模板，根据不同的功能调用不同的模板。如：注册、登录、系统错误、订阅、回复、推荐等。
// -- 2、模板通过放到配置文件中，以HTML形式提供，一次性读取配置。避免多次IO。
// -- 3、发送邮件的时候，定时处理。即按照每5分钟的形式批量发送一次。

package services

import (
	"errors"
	"github.com/astaxie/beego"
	"net/smtp"
	"strings"
)

// 定义邮件配置。
var fromMail string
var fromPwd string
var fromSmtp string
var AdminMail string

func init() {
	fromMail = beego.AppConfig.String("fromMail")
	fromPwd = beego.AppConfig.String("fromPwd")
	fromSmtp = beego.AppConfig.String("fromSmtp")
	AdminMail = beego.AppConfig.String("AdminMail")
}

// 发送错误提醒邮件。
// @param errMsg 错误信息。
// @param errLevel 错误等级。
func SendErrorMail(errMsg string, errLevel int) error {
	subject := "视频博客系统错误通知"
	body := "视频博客系统发生了错误，错误信息为：" + errMsg + "，请及时处理。如不严重，可以忽略本提醒。"
	return SendAdminMail(subject, body, "html")
}

/**
 * 发送邮件。
 * @param receive 接收人的邮件地址。
 * @param subject 邮件主题。
 * @param body 邮件内容。
 * @param mailtype 邮件类型：html、text
 * @return errors
 */
func SendMail(receive, subject, body, mailtype string) error {
	return sendMail(fromMail, fromPwd, fromSmtp, receive, subject, body, mailtype)
}

// 发送管理员邮件。
// -- 1、管理员邮件地址在配置文件中配置。
func SendAdminMail(subject, body, mailtype string) error {
	if len(AdminMail) > 0 {
		return sendMail(fromMail, fromPwd, fromSmtp, AdminMail, subject, body, mailtype)
	} else {
		err := errors.New("No configuration administrator email address")
		return err
	}
}

/**
 * 发送邮件。
 * @param string user 发送人邮箱地址。
 * @param string password 发送人邮箱密码。
 * @param string host 服务器地址，如：smtp.163.com
 * @param string to 邮件接收人,如：user1@qq.com;user2@qq.com
 * @param string subject 邮件主题。
 * @param string body 邮件内容。
 * @param string mailtype 邮件类型：html、text
 *
 * @return errors
 */
func sendMail(user, password, host, to, subject, body, mailtype string) error {
	hp := strings.Split(host, ":")
	auth := smtp.PlainAuth("", user, password, hp[0])
	var content_type string
	if mailtype == "html" {
		content_type = "Content-Type: text/" + mailtype + "; charset=UTF-8"
	} else {
		content_type = "Content-Type: text/plain" + "; charset=UTF-8"
	}

	msg := []byte("To: " + to + "\r\nFrom: " + user + "<" + user + ">\r\nSubject: " + subject + "\r\n" + content_type + "\r\n\r\n" + body)
	send_to := strings.Split(to, ";")
	err := smtp.SendMail(host, auth, user, send_to, msg)
	return err
}
