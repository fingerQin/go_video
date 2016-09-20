// 分页处理。
// @author 寒冰
// @date 2013年12月7日

package services

import (
	//"fmt"
	"math"
	"net/http"
	"net/url"
	"strconv"
)

type Page struct {
	Request    *http.Request
	PageNumber int64            // 当前页
	Total      int64            // 总记录数
	TotalPage  int64            // 总页数
	PageSize   int64            // 每页数量
	Offset     int64            // SQL LIMIT offset
	Count      int64            // SQL LIMIT count
	PrevUrl    string           // 上一页页码
	NextUrl    string           // 下一页页码
	Urls       map[int64]string // 1.2.3.4.5
}

func init() {

}

// 执行此方法得到其他值
func (this *Page) Page() {
	this.Urls = make(map[int64]string) // 必须初始化之后才能使用

	if this.PageNumber <= 0 {
		this.PageNumber = 1
	}

	if this.PageSize == 0 {
		this.PageSize = 10
	}

	// 计算有多少页
	this.TotalPage = int64(math.Ceil(float64(this.Total) / float64(this.PageSize)))
	if this.PageNumber >= this.TotalPage {
		this.PageNumber = this.TotalPage
	}

	this.Offset = (this.PageNumber - 1) * this.PageSize
	this.Count = this.PageSize

	if this.PageNumber == 1 {
		this.PrevUrl = this.PageLink(1)
	} else if this.PageNumber > 1 {
		this.PrevUrl = this.PageLink(this.PageNumber - 1)
	}

	if this.PageNumber >= 1 && this.PageNumber < this.TotalPage {
		this.NextUrl = this.PageLink(this.PageNumber + 1)
	} else if this.PageNumber == this.TotalPage {
		this.NextUrl = this.PageLink(this.TotalPage)
	} else {
		this.NextUrl = this.PageLink(1)
	}

	// 1.2.3.4.5...
	setpages := 5 // 显示的分页个数
	offset := math.Ceil((float64(setpages) / 2) - 1)
	from := this.PageNumber - int64(offset)
	to := this.PageNumber + int64(offset)
	//more := 0
	morePage := int64(setpages + 1)
	if morePage >= this.TotalPage {
		from = 2
		to = this.TotalPage - 1
	} else {
		if from <= 1 {
			to = morePage - 1
			from = 2
		} else if to >= this.TotalPage {
			from = this.TotalPage - (morePage - 2)
			to = this.TotalPage - 1
		}
		//more = 1
	}
	for i := from; i <= to; i++ {
		if i != this.PageNumber {
			//this.Urls = append(this.Urls, this.PageLink(int64(i)))
			this.Urls[i] = this.PageLink(int64(i))
		} else {
			//this.Urls = append(this.Urls, this.PageLink(1))
			this.Urls[i] = this.PageLink(i)
		}
	}
}

// 获取分页链接
func (p *Page) PageLink(page int64) string {
	link, _ := url.ParseRequestURI(p.Request.RequestURI)
	values := link.Query()
	if page == 1 {
		values.Del("page")
	} else {
		strPage := strconv.FormatInt(page, 10)
		values.Set("page", strPage)
	}
	link.RawQuery = values.Encode()
	return link.String()
}
