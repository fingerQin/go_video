// QQ登录API。
// @author 寒冰。
// @date 2013年12月27日。

package services

import (
	"encoding/json"
	"errors"
	"github.com/astaxie/beego"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"
)

var appid string = ""
var appkey string = ""
var openid string = ""

// QQ接口get_user_info返回的JSON对象格式。
type QQUserInfo struct {
	Ret                int
	Msg                string
	Nickname           string
	Figureurl          string
	Figureurl_1        string
	Figureurl_2        string
	Figureurl_qq_1     string
	Figureurl_qq_2     string
	Gender             string
	Is_yellow_vip      string
	Vip                string
	Yellow_vip_level   string
	Level              string
	Is_yellow_year_vip string
}

func init() {
	appid = beego.AppConfig.String("qq_appid")
	appkey = beego.AppConfig.String("qq_appkey")
}

type QQapi struct {
	Callback    string
	AccessToken string
}

// 获取登录时跳转的授权URL地址。
func (this *QQapi) RedirectToLogin() string {
	//跳转到QQ登录页的接口地址, 不要更改!!
	redirect := "https://graph.qq.com/oauth2.0/authorize?response_type=code&client_id=" + appid + "&scope=&"
	urlParams := url.Values{}
	urlParams.Set("redirect_uri", this.Callback)
	urlEncodeParams := urlParams.Encode()
	redirect += urlEncodeParams
	return redirect
}

// 获取登录的openid
// see:http://wiki.open.qq.com/wiki/website/%E4%BD%BF%E7%94%A8Authorization_Code%E8%8E%B7%E5%8F%96Access_Token
// see:http://wiki.open.qq.com/wiki/website/%E8%8E%B7%E5%8F%96%E7%94%A8%E6%88%B7OpenID_OAuth2.0
func (this *QQapi) GetOpenid(code string) (string, error) {
	apiurl := "https://graph.qq.com/oauth2.0/token?grant_type=authorization_code&client_id=" + appid + "&client_secret=" + appkey + "&code=" + code + "&"
	urlParams := url.Values{}
	urlParams.Set("redirect_uri", this.Callback)
	urlEncodeParams := urlParams.Encode()
	apiurl += urlEncodeParams

	resp, err := http.Get(apiurl)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}
	returnData := string(body)
	// 将access_token从返回的数据中提取出来。
	u, _ := url.ParseQuery(returnData)
	this.AccessToken = u.Get("access_token")
	if len(this.AccessToken) == 0 {
		err := errors.New("not access_token")
		return "", err
	}

	// 取当前登录的QQ用户的openid
	openidUrl := "https://graph.qq.com/oauth2.0/me?access_token=" + this.AccessToken
	resp, err = http.Get(openidUrl)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	body, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}
	openidData := string(body)
	// 由于返回的数据不是普通的URLQuqery，也不是JSON格式。所以，只能手工处理。
	openidData = strings.Replace(openidData, "callback( ", "", -1)
	openidData = strings.Replace(openidData, " );", "", -1)
	// 启用JSON解析。
	type Server struct {
		Client_id string
		Openid    string
	}
	var s Server
	err = json.Unmarshal([]byte(openidData), &s)
	if err != nil {
		return "", err
	}
	return s.Openid, nil
}

// 返回用户信息。
// @param openid 此参数是GetOpenid()方法获得，并在获取成功时放入SESSION中保存起来的。
func (this *QQapi) GetUserInfo(openid string) (QQUserInfo, error) {
	var s QQUserInfo

	openidUrl := "https://graph.qq.com/user/get_user_info?access_token=" + this.AccessToken + "&oauth_consumer_key=" + appid + "&openid=" + openid
	resp, err := http.Get(openidUrl)

	if err != nil {
		return s, err
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return s, err
	}
	data := string(body)

	json.Unmarshal([]byte(data), &s)
	return s, nil
}
