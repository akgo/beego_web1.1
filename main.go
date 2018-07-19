package main

import (
	_ "beego_web1.1/routers"
	"github.com/astaxie/beego"
	"beego_web1.1/jobs"
)

func init() {
	jobs.InitJobs()
}

func main() {
	//beego.SetLevel(beego.LevelInformational)
	beego.Run()
}

