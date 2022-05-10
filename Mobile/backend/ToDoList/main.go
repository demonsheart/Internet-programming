package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
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

	_ = r.Run(":60035")
}
