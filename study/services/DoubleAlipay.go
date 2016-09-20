// 支付宝双支付接口。
// @author 寒冰。
// @date 2014年1月6日。

package services

import (
	"crypto/md5"
	"fmt"
	"github.com/astaxie/beego"
	"io"
	"net/url"
	"sort"
	"strings"
)

var AlipayPID string
var AlipayKEY string
var AlipayAccount string
var AlipayGateway string

func init() {
	AlipayPID = beego.AppConfig.String("AlipayPID")
	AlipayKEY = beego.AppConfig.String("AlipayKEY")
	AlipayAccount = beego.AppConfig.String("AlipayAccount")
	AlipayGateway = beego.AppConfig.String("AlipayGateway")
}

type Request struct {
	PaymentType      string // 收款类型。只支持1，商品购买。
	NotifyUrl        string // 付款后异步通知页面。
	ReturnUrl        string // 页面同步跳转通知页面URL。
	OutTradeNo       string // 商户网站唯一订单号。
	Subject          string // 商品名称。例：WEB开发云课堂VIP1充值
	Price            string // 价格。单位（元）
	Body             string // 商品描述。
	ShowUrl          string // 商品展示URL地址。
	Quantity         string // 商品数量。必填，建议默认为1，不改变值，把一次交易看成是一次下订单而非购买一件商品
	LogisticsFee     string // 物流运费。可为空
	LogisticsType    string // 物流类型。必填，三个值可选：EXPRESS（快递）、POST（平邮）、EMS（EMS）
	LogisticsPayment string // 物流支付方式。必填，两个值可选：SELLER_PAY（卖家承担运费）、BUYER_PAY（买家承担运费）
	ReceiveName      string // 收货人姓名。可空。
	ReceiveAddress   string // 收货人地址。可空。
	ReceiveZip       string // 收货人邮编。可空。
	ReceivePhone     string // 收货人电话号码。可空。
	ReceiveMobile    string // 收货人手机号码。可空。
}

type Response struct {
	BuyerEmail  string
	OutTradeNo  string
	TradeStatus string
	Subject     string
	TotalFee    float64
}

type kvpair struct {
	k, v string
}

type kvpairs []kvpair

func (t kvpairs) Less(i, j int) bool {
	return t[i].k < t[j].k
}

func (t kvpairs) Swap(i, j int) {
	t[i], t[j] = t[j], t[i]
}

func (t kvpairs) Len() int {
	return len(t)
}

func (t kvpairs) Sort() {
	sort.Sort(t)
}

func (t kvpairs) RemoveEmpty() (t2 kvpairs) {
	for _, kv := range t {
		if kv.v != "" {
			t2 = append(t2, kv)
		}
	}
	return
}

func (t kvpairs) Join() string {
	var strs []string
	for _, kv := range t {
		strs = append(strs, kv.k+"="+kv.v)
	}
	return strings.Join(strs, "&")
}

// 生成签名
func md5Sign(str, key string) string {
	h := md5.New()
	io.WriteString(h, str)
	io.WriteString(h, key)
	return fmt.Sprintf("%x", h.Sum(nil))
}

// 支付宝签名验证。
func AplipayVerifySign(u url.Values) (err error) {
	p := kvpairs{}
	sign := ""
	for k := range u {
		v := u.Get(k)
		switch k {
		case "sign":
			sign = v
			continue
		case "sign_type":
			continue
		}
		p = append(p, kvpair{k, v})
	}
	if sign == "" {
		err = fmt.Errorf("sign not found")
		return
	}
	p = p.RemoveEmpty()
	p.Sort()
	if md5Sign(p.Join(), AlipayKEY) != sign {
		err = fmt.Errorf("sign invalid")
		return
	}
	return
}

// 根据接口要求生成一个付款页面并返回页面HTML代码。
func (r *Request) NewPage() string {
	p := kvpairs{
		kvpair{`service`, `trade_create_by_buyer`},
		kvpair{`partner`, AlipayPID},
		kvpair{`payment_type`, r.PaymentType},
		kvpair{`notify_url`, r.NotifyUrl},
		kvpair{`return_url`, r.ReturnUrl},
		kvpair{`seller_email`, AlipayAccount},
		kvpair{`out_trade_no`, r.OutTradeNo},
		kvpair{`subject`, r.Subject},
		kvpair{`price`, r.Price},
		kvpair{`quantity`, r.Quantity},
		kvpair{`logistics_fee`, r.LogisticsFee},
		kvpair{`logistics_type`, r.LogisticsType},
		kvpair{`logistics_payment`, r.LogisticsPayment},
		kvpair{`body`, r.Body},
		kvpair{`show_url`, r.ShowUrl},
		kvpair{`receive_name`, r.ReceiveName},
		kvpair{`receive_address`, r.ReceiveAddress},
		kvpair{`receive_zip`, r.ReceiveZip},
		kvpair{`receive_phone`, r.ReceivePhone},
		kvpair{`receive_mobile`, r.ReceiveMobile},
		kvpair{`_input_charset`, `utf-8`},
	}
	p = p.RemoveEmpty()
	p.Sort()

	sign := md5Sign(p.Join(), AlipayKEY)
	p = append(p, kvpair{`sign`, sign})
	p = append(p, kvpair{`sign_type`, `MD5`})

	html := ""
	html += fmt.Sprintf(`<form id='alipaysubmit' target='_blank' name='alipaysubmit' action='%s_input_charset=utf-8' method='post'> `, AlipayGateway)
	for _, kv := range p {
		html += fmt.Sprintf(`<input type='hidden' name='%s' value='%s' />`, kv.k, kv.v)
	}
	html += `<input type="submit" class="sub" id="doAlipy" value="确认">`
	return html
}
