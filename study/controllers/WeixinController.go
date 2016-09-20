// 前台。
// -- 首页、新闻、关于、联系、留言
// @author 寒冰[qljs888@163.com]
// @date 2013年11月24日
/**
1)普通用户发送文本到公众账号时，向接口推送的信息内容格式：
<xml><ToUserName><![CDATA[gh_819c486aa658]]></ToUserName>
<FromUserName><![CDATA[ox76ruEWcb0Lci-aSU3-lgzGJDNM]]></FromUserName>
<CreateTime>1390372289</CreateTime>
<MsgType><![CDATA[text]]></MsgType>
<Content><![CDATA[test]]></Content>
<MsgId>5971603510529660569</MsgId>
</xml>

2)普通用户发送语音到公众账号时，向接口推送的信息内容格式：
<xml><ToUserName><![CDATA[gh_819c486aa658]]></ToUserName>
<FromUserName><![CDATA[ox76ruEWcb0Lci-aSU3-lgzGJDNM]]></FromUserName>
<CreateTime>1390372169</CreateTime>
<MsgType><![CDATA[voice]]></MsgType>
<MediaId><![CDATA[1Lw7HT-dBoWK9J0jJ3KPqXNRBITeficuge1ElYDnb1v339d-NBOMiosiykDWdLtb]]></MediaId>
<Format><![CDATA[amr]]></Format>
<MsgId>5971602995133585047</MsgId>
<Recognition><![CDATA[]]></Recognition>
</xml>

3)普通用户发送图片到公众账号时，向接口推送的信息内容格式：
<xml><ToUserName><![CDATA[gh_819c486aa658]]></ToUserName>
<FromUserName><![CDATA[ox76ruEWcb0Lci-aSU3-lgzGJDNM]]></FromUserName>
<CreateTime>1390372347</CreateTime>
<MsgType><![CDATA[image]]></MsgType>
<PicUrl><![CDATA[http://mmbiz.qpic.cn/mmbiz/ibV6WVMIN3jceN4uZanaTtIxVBbUvK5DDQa7ic5xXjy8pyfmSM4JpEDHhicXicultrJOwD3Olk4PuBRuHaX0Noianbw/0]]></PicUrl>
<MsgId>5971603759637763739</MsgId>
<MediaId><![CDATA[H1891QOmp_dzkrGciO0hUbQ44CWNMa-qEfoY704EJFFJY5qslVMotHgP8_mbW5UA]]></MediaId>
</xml>

4)用户取消关注公众账号时的事件格式内容：
<xml><ToUserName><![CDATA[gh_819c486aa658]]></ToUserName>
<FromUserName><![CDATA[ox76ruEWcb0Lci-aSU3-lgzGJDNM]]></FromUserName>
<CreateTime>1390372972</CreateTime>
<MsgType><![CDATA[event]]></MsgType>
<Event><![CDATA[unsubscribe]]></Event>
<EventKey><![CDATA[]]></EventKey>
</xml>

5)关注公众账号事件格式内容：
<xml><ToUserName><![CDATA[gh_819c486aa658]]></ToUserName>
<FromUserName><![CDATA[ox76ruEWcb0Lci-aSU3-lgzGJDNM]]></FromUserName>
<CreateTime>1390373164</CreateTime>
<MsgType><![CDATA[event]]></MsgType>
<Event><![CDATA[subscribe]]></Event>
<EventKey><![CDATA[]]></EventKey>
</xml>

*/

package controllers

import (
	//"crypto/md5"
	"fmt"
	//"github.com/astaxie/beego/orm"
	"io"

	//"log"
	"crypto/sha1"
	//"math"
	"sort"
	"strconv"
	//"study/models"
	"encoding/xml"
	"study/services"
	"time"
)

type WeixinController struct {
	CommonController
}

// 微信公众平台验证URL。
func (this *WeixinController) Api() {
	this.reveiveMessage()
}

// 微信开发者认证。
// -- 1、该操作只在认证的时候使用，其余时间不使用。
func (this *WeixinController) valiToken() {
	signature := this.GetString("signature") // 微信加密签名。
	timestamp := this.GetString("timestamp") // 时间戳。
	nonce := this.GetString("nonce")         // 随机数。
	echostr := this.GetString("echostr")     // 随机字符串。

	// 参数排序。
	var getParams sort.StringSlice = []string{WeixinToken, timestamp, nonce}
	getParams.Sort()
	// 拼接成字符串。
	var strParam string
	for _, v := range getParams {
		strParam += v
	}

	// sha1加密。
	h := sha1.New()
	io.WriteString(h, strParam)
	tmpStr := fmt.Sprintf("%x", h.Sum(nil))

	// 签名合法性对比。
	if tmpStr != signature {
		this.Ctx.WriteString("Captcha failed")
	} else {
		this.Ctx.WriteString(echostr)
	}
	this.StopRun()
}

// 接收普通消息。
func (this *WeixinController) reveiveMessage() {
	postXml := this.Ctx.Input.RequestBody
	xmlData := services.WxMessageText{}
	err := xml.Unmarshal(postXml, &xmlData)

	// 解析出现问题则返回空即可。
	if err != nil {
		this.Ctx.WriteString("")
		this.StopRun()
	} else {
		currTime := strconv.FormatInt(time.Now().Unix(), 10)
		//retXml := `<xml>
		//<ToUserName><![CDATA[` + xmlData.FromUserName + `]]></ToUserName>
		//<FromUserName><![CDATA[` + xmlData.ToUserName + `]]></FromUserName>
		//<CreateTime>` + currTime + `</CreateTime>
		//<MsgType><![CDATA[text]]></MsgType>
		//<Content><![CDATA[我们已经收到。谢谢！]]></Content>
		//</xml>`

		retXml := `<xml>
<ToUserName><![CDATA[` + xmlData.FromUserName + `]]></ToUserName>
<FromUserName><![CDATA[` + xmlData.ToUserName + `]]></FromUserName>
<CreateTime>` + currTime + `</CreateTime>
<MsgType><![CDATA[news]]></MsgType>
<ArticleCount>2</ArticleCount>
<Articles>
<item>
<Title><![CDATA[每天必看网第一期]]></Title> 
<Description><![CDATA[IT资讯第一期，隆重推出，敬请关注！]]></Description>
<PicUrl><![CDATA[http://www.meitianbikan.com/static/Upload/Covers/201401/1390296384049769411.png]]></PicUrl>
<Url><![CDATA[http://www.meitianbikan.com/Index/VideoView?courseid=19]]></Url>
</item>
<item>
<Title><![CDATA[每天必看网第二期]]></Title> 
<Description><![CDATA[IT资讯第二期，隆重推出，敬请关注！]]></Description>
<PicUrl><![CDATA[http://www.meitianbikan.com/static/Upload/Covers/201401/1390296384049769411.png]]></PicUrl>
<Url><![CDATA[http://www.meitianbikan.com/Index/VideoView?courseid=19]]></Url>
</item>
<item>
</Articles>
</xml> `
		this.Ctx.WriteString(retXml)
		this.StopRun()
	}

	this.StopRun()
}

// 发送被动响应消息。
// 通过获取用户发来的信息进行响应相应的图文信息。
func (this *WeixinController) sendPassiveMessage() {
	this.StopRun()
}

// 接收事件推送。
// -- 1、目前就只有两个事件：关注、取消关注。
// -- 2、只有关注的时候才处理。其他情况记录日志就OK了。
func (this *WeixinController) accpetEventPush() {
	postXml := this.Ctx.Input.RequestBody
	xmlData := services.WxEventUnsubscribe{}
	err := xml.Unmarshal(postXml, &xmlData)

	// 解析出现问题则返回空即可。
	if err != nil {
		this.Ctx.WriteString("")
		this.StopRun()
	} else {
		currTime := strconv.FormatInt(time.Now().Unix(), 10)

		if xmlData.Event != "subscribe" {
			this.Ctx.WriteString("")
			this.StopRun()
		}

		retXml := `<xml>
<ToUserName><![CDATA[` + xmlData.FromUserName + `]]></ToUserName>
<FromUserName><![CDATA[` + xmlData.ToUserName + `]]></FromUserName>
<CreateTime>` + currTime + `</CreateTime>
<MsgType><![CDATA[text]]></MsgType>
<Content><![CDATA[感谢您关注我们！请保持关注，了解最新的活动与IT资讯！]]></Content>
</xml>`
		this.Ctx.WriteString(retXml)
		this.StopRun()
	}
}
