// 应用所有缓存操作在这里操作。
// -- 1、分类的存取<缓存>
// -- 2、文章浏览次数存取
// -- 3、课程浏览次数存取
// -- 4、文章详情信息缓存
// -- 5、视频详情信息缓存

package services

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/cache"
)

// 定义变量保存缓存配置
var AppCachePath string
var AppFileSuffix string
var AppDirectoryLevel string
var AppEmbedExpiry string

// 定义一个变量保存缓存对象
var AppCache cache.Cache

func init() {
	// 初始化系统应用缓存配置
	AppCachePath = beego.AppConfig.String("AppCachePath")
	AppFileSuffix = beego.AppConfig.String("AppFileSuffix")
	AppDirectoryLevel = beego.AppConfig.String("AppDirectoryLevel")
	AppEmbedExpiry = beego.AppConfig.String("AppEmbedExpiry")

	ConfigDsn := `{"CachePath":"` + AppCachePath + `","FileSuffix":"` + AppFileSuffix + `","DirectoryLevel":` + AppDirectoryLevel + `,"EmbedExpiry":` + AppEmbedExpiry + `}`
	AppCache, _ = cache.NewCache("file", ConfigDsn)
}
