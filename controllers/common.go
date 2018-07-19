package controllers

import (
	"github.com/astaxie/beego"
	"beego_web1.1/models"
	"strings"
	"strconv"
	"beego_web1.1/libs"
	"fmt"
	"encoding/json"
)

const (
	MSG_OK  = 0
	MSG_ERR = -1
)

type BaseController struct {
	beego.Controller
	controllerName string
	actionName     string
	user           *models.User
	userId         int
	userName       string
	pageSize       int
	permission     []string
	ptest          map[string]int
}

func (this *BaseController) Prepare() {
	this.pageSize = 20
	controllerName, actionName := this.GetControllerAndAction()
	this.controllerName = strings.ToLower(controllerName[0 : len(controllerName)-10])
	this.actionName = strings.ToLower(actionName)
	this.auth()

	this.Data["version"] = beego.AppConfig.String("version")
	this.Data["siteName"] = beego.AppConfig.String("site.name")
	this.Data["curRoute"] = this.controllerName + "." + this.actionName

	pState := false

	for _,val := range this.permission {
		//fmt.Println(val,this.controllerName + "." + this.actionName)
		if val == this.controllerName + "." + this.actionName {
			pState = true
		}
	}

	if this.ptest[this.controllerName + "." + this.actionName] < 1 {
		this.ajaxMsg("权限错误",MSG_ERR)
	}

	if !pState {
		//this.ajaxMsg("权限错误",MSG_ERR)
		fmt.Println("NNNNNNNNNNNN-------------------------NNNNNNNNNNNNNNN")
	}

	this.Data["curController"] = this.controllerName
	this.Data["curAction"] = this.actionName
	this.Data["loginUserId"] = this.userId
	this.Data["loginUserName"] = this.userName
	this.Data["menuTag"] = this.controllerName
	//this.Data["urlfor"]  = "IndexController.Prepare"
}

//登录状态验证
func (this *BaseController) auth() {
	arr := strings.Split(this.Ctx.GetCookie("auth"), "|")
	if len(arr) == 2 {
		idstr, password := arr[0], arr[1]
		userId, _ := strconv.Atoi(idstr)
		if userId > 0 {
			user, err := models.UserGetById(userId)
			if err == nil && password == libs.Md5([]byte(this.getClientIp()+"|"+user.Password+user.Salt)) {
				this.userId = user.Id
				this.userName = user.UserName
				byt := []byte(user.Permission)
				json.Unmarshal(byt,&this.permission)

				bytt := []byte(user.Ptest)
				json.Unmarshal(bytt,&this.ptest)
				this.user = user
			}
		}
	}
	if this.userId == 0 && (this.controllerName != "index" || (this.controllerName == "index" && this.actionName != "logout" && this.actionName != "login")) {
		this.redirect(beego.URLFor("IndexController.Login"))
	}
}

//渲染模版
func (this *BaseController) display(tpl ...string) {
	var tplname string
	if len(tpl) > 0 {
		tplname = tpl[0] + ".html"
	} else {
		tplname = this.controllerName + "/" + this.actionName + ".html"
	}
	this.Layout = "public/layout.html"
	this.TplName = tplname
}

// 重定向
func (this *BaseController) redirect(url string) {
	this.Redirect(url, 302)
	this.StopRun()
}

// 是否POST提交
func (this *BaseController) isPost() bool {
	return this.Ctx.Request.Method == "POST"
}

// 显示错误信息
func (this *BaseController) showMsg(args ...string) {
	this.Data["message"] = args[0]
	redirect := this.Ctx.Request.Referer()
	if len(args) > 1 {
		redirect = args[1]
	}

	this.Data["redirect"] = redirect
	this.Data["pageTitle"] = "系统提示"
	this.display("error/message")
	this.Render()
	this.StopRun()
}

// 输出json
func (this *BaseController) jsonResult(out interface{}) {
	this.Data["json"] = out
	this.ServeJSON()
	this.StopRun()
}

func (this *BaseController) ajaxMsg(msg interface{}, msgno int) {
	out := make(map[string]interface{})
	out["status"] = msgno
	out["msg"] = msg

	this.jsonResult(out)
}

//获取用户IP地址
func (this *BaseController) getClientIp() string {
	s := strings.Split(this.Ctx.Request.RemoteAddr, ":")
	return s[0]
}
