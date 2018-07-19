package controllers

import (
	"beego_web1.1/models"
	"strings"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/utils"
	"time"
	"strconv"
	"beego_web1.1/libs"
	"fmt"
	"encoding/json"
)

type IndexController struct {
	BaseController
}

// 首页
func (this *IndexController) Index() {
	this.Data["pageTitle"] = "系统概况"
	this.Data["okJob"] = "test.go"
	this.display()
}

//个人信息
func (this *IndexController) Profile() {
	beego.ReadFromRequest(&this.Controller)
	user, _ := models.UserGetById(this.userId)

	if this.isPost() {
		fmt.Println(this.GetString("email"))
		user.Email = this.GetString("email")
		user.Update()
		password1 := this.GetString("password1")
		password2 := this.GetString("password2")
		permission := this.GetStrings("permission")

		pJ ,_ := json.Marshal(permission)

		if password1 != "" {
			if(len(password1) < 6) {
				this.ajaxMsg("密码长度必须大于6",MSG_ERR)
			} else if password1 != password2 {
				this.ajaxMsg("两次输入密码不一致",MSG_ERR)
			} else {
				user.Salt = string(utils.RandomCreateBytes(10))
				user.Password = libs.Md5([]byte(password1 + user.Salt))
				if len(permission) > 0 {
					//权限部分
					user.Permission = string(pJ)
				}
				user.Update()
			}
		} else {
			if len(permission) > 0 {
				//权限部分
				user.Permission = string(pJ)
				pt :=  map[string]int{}
				for _,v := range permission {
					pt[v] = 1
				}
				fmt.Println(pt)
				pJt ,_ := json.Marshal(pt)
				user.Ptest = string(pJt)
				user.Update()
			}
		}


		this.ajaxMsg("", MSG_OK)

	}

	this.Data["pageTitle"] = "资料修改"
	this.Data["user"] = user
	this.Data["password"] = user
	this.Data["permission"],_ = beego.AppConfig.GetSection("permission")
	this.display()
}

// 登录
func (this *IndexController) Login() {

	fmt.Println(this.userId,this.isPost(),"+++++++++++++++++++")

	if this.userId > 0 {
		this.redirect("/")
	}
	beego.ReadFromRequest(&this.Controller)

	if this.isPost() {

		username := strings.TrimSpace(this.GetString("username"))
		password := strings.TrimSpace(this.GetString("password"))
		remember := this.GetString("remember")

		if username != "" && password != "" {
			user, err := models.UserGetByName(username)
			fmt.Println(user,err)
			flash := beego.NewFlash()
			errorMsg := ""
			if err != nil || user.Password != libs.Md5([]byte(password+user.Salt)) {
				errorMsg = "帐号或密码错误"
			} else if user.Status == -1 {
				errorMsg = "该帐号已禁用"
			} else {
				user.LastIp = this.getClientIp()
				user.LastLogin = time.Now().Unix()
				models.UserUpdate(user)

				authkey := libs.Md5([]byte(this.getClientIp() + "|" + user.Password + user.Salt))
				if remember == "yes" {
					this.Ctx.SetCookie("auth", strconv.Itoa(user.Id)+"|"+authkey, 7*86400)
				} else {
					this.Ctx.SetCookie("auth", strconv.Itoa(user.Id)+"|"+authkey,86400)
				}
				this.redirect(beego.URLFor("IndexController.Profile"))
			}
			user.LastIp = this.getClientIp()
			user.LastLogin = time.Now().Unix()
			models.UserUpdate(user)

			authkey := libs.Md5([]byte(this.getClientIp() + "|" + user.Password + user.Salt))
			if remember == "yes" {
				this.Ctx.SetCookie("auth", strconv.Itoa(user.Id)+"|"+authkey, 7*86400)
			} else {
				this.Ctx.SetCookie("auth", strconv.Itoa(user.Id)+"|"+authkey,86400)
			}
			this.redirect(beego.URLFor("IndexController.Profile"))
			flash.Error(errorMsg)
			flash.Store(&this.Controller)
			this.redirect(beego.URLFor("IndexController.Login"))
		}
	}
	this.TplName = "public/login.html"
}

// 退出登录
func (this *IndexController) Logout() {
	this.Ctx.SetCookie("auth", "")
	this.redirect(beego.URLFor("IndexController.Login"))
}

// 获取系统时间
func (this *IndexController) GetTime() {
	out := make(map[string]interface{})
	out["time"] = time.Now().UnixNano() / int64(time.Millisecond)
	this.jsonResult(out)
}


