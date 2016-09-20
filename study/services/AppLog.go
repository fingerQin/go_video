// 系统应用日志管理。
// @author 寒冰
// @date 2014年1月2日。

package services

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
)

var AppLog *logs.BeeLogger

func init() {
	AppLogType := beego.AppConfig.String("AppLogType")
	AppLogDsn := beego.AppConfig.String("AppLogDsn")

	AppLog = logs.NewLogger(10000)
	AppLog.SetLogger(AppLogType, AppLogDsn)
}
