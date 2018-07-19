package routers

import (
	"beego_web1.1/controllers"
	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/", &controllers.IndexController{}, "*:Index")
	beego.Router("/login", &controllers.IndexController{}, "*:Login")
	beego.Router("/logout", &controllers.IndexController{}, "*:Logout")
	beego.Router("/profile", &controllers.IndexController{}, "*:Profile")
	beego.Router("/gettime", &controllers.IndexController{}, "*:GetTime")
	beego.AutoRouter(&controllers.TaskController{})
	beego.AutoRouter(&controllers.GroupController{})
}
