// 个人自媒体系统。
// @author 寒冰
// @date 2013年11月9日

package main

import (
	"github.com/astaxie/beego"
	"study/controllers"
)

func main() {
	beego.Router("/", &controllers.IndexController{}, "*:Index")

	// 视频教学系统
	beego.AutoRouter(&controllers.SystemController{})
	beego.AutoRouter(&controllers.IndexController{})
	beego.AutoRouter(&controllers.UserController{})
	beego.AutoRouter(&controllers.WeixinController{})

	beego.Run()
}
