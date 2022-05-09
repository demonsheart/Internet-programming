package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
	"github.com/jordan-wright/email"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"net/smtp"
	"sync"
)

var db *gorm.DB
var err error
var email2code sync.Map // 保存临时验证码键值对

func main() {

	username := "go"
	password := "52Swift66@"
	host := "127.0.0.1"
	port := 3306
	Dbname := "todolist"
	timeout := "10s"

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&parseTime=True&loc=Local&timeout=%s", username, password, host, port, Dbname, timeout)
	db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		fmt.Println(err)
	}

	r := gin.Default()
	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		//注册 LocalTime 类型的自定义校验规则
		v.RegisterCustomTypeFunc(ValidateJSONDateType, LocalTime{})
	}

	// methods
	r.POST("/login", Login)                   // 登录
	r.POST("/sentAuthCode", SendAuthCode)     // 获取验证码
	r.POST("/register", Register)             // 注册
	r.POST("/changeUserMess", ChangeUserMess) // 修改信息
	r.POST("/getUserMess", GetUserMess)       // 获取信息
	//r.POST("/resetPassWord", ResetPassWord)   // 重置密码
	r.POST("/heartbeat", Heartbeat) // 心跳机制
	//r.GET("/sendTest", SendEmailTest)

	_ = r.Run(":60035")
}

func SendEmailTest(c *gin.Context) {
	if err := MyHeaderValidate(c); err != nil {
		c.AbortWithStatus(404)
		return
	}

	e := email.NewEmail()
	//设置发送方的邮箱
	e.From = "hrj<a2509875617@163.com>"
	// 设置接收方的邮箱
	e.To = []string{"2509875617@qq.com"}
	//设置主题
	e.Subject = "测试邮箱"
	//设置文件发送的内容
	e.Text = []byte("回复术士重启人生")
	//设置服务器相关的配置
	err := e.Send("smtp.163.com:25", smtp.PlainAuth("", "a2509875617@163.com", "HTKBUHMYFGRKKRTF", "smtp.163.com"))
	if err != nil {
		c.JSON(200, gin.H{"success": false, "error": err})
		return
	}
	c.JSON(200, gin.H{"success": true, "error": ""})
}
