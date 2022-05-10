package main

import (
	"errors"
	"github.com/gin-gonic/gin"
	"github.com/jordan-wright/email"
	"gorm.io/gorm"
	"math/rand"
	"net/http"
	"net/mail"
	"net/smtp"
	"time"
)

// 产生随机字符串
const charset = "abcdefghijklmnopqrstuvwxyz" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

var seededRand *rand.Rand = rand.New(
	rand.NewSource(time.Now().UnixNano()))

func StringWithCharset(length int, charset string) string {
	b := make([]byte, length)
	for i := range b {
		b[i] = charset[seededRand.Intn(len(charset))]
	}
	return string(b)
}

func String(length int) string {
	return StringWithCharset(length, charset)
}

// EmailValid 验证
func EmailValid(email string) bool {
	_, err := mail.ParseAddress(email)
	return err == nil
}

func MyHeaderValidate(c *gin.Context) error {
	h := MyHeader{}
	if err := c.ShouldBindHeader(&h); err != nil {
		return err
	}

	if h.UserAgent != "HRJ" {
		return errors.New("invalid UA")
	}

	return nil
}

// Heartbeat 心跳机制 同时具备普通网络监测心跳包 以及 挤号检测心跳包两大功能
func Heartbeat(c *gin.Context) {
	if err := MyHeaderValidate(c); err != nil {
		c.AbortWithStatus(404)
		return
	}

	var params HeartbeatParams
	if err := c.ShouldBindJSON(&params); err != nil {
		// 不携带token && email 是普通网络监测心跳包
		c.JSON(200, gin.H{"success": true, "error": ""})
		return
	}

	// 如果携带token && account 则是检测挤号心跳包
	var userMessage UsersAuth
	var re *gorm.DB
	re = db.Table("users_auth").
		Where("email = ?", params.Email).
		Take(&userMessage)

	if re.Error != nil {
		c.JSON(200, gin.H{"success": false, "error": re.Error.Error()})
		return
	}

	// 检测token有效性
	if params.Token == userMessage.Token {
		c.JSON(200, gin.H{"success": true, "error": ""})
	} else {
		c.JSON(200, gin.H{"success": false, "error": "invalid token"})
		return
	}
}

func Login(c *gin.Context) {
	if err := MyHeaderValidate(c); err != nil {
		c.AbortWithStatus(404)
		return
	}

	// bind params
	var params LoginParams
	if err := c.ShouldBindJSON(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// find user
	var userMessage UsersAuth
	var re *gorm.DB
	re = db.Table("users_auth").
		Where("email = ? AND password = ?", params.Email, params.Password).
		Take(&userMessage)

	if re.Error != nil {
		c.JSON(200, gin.H{"success": false, "error": re.Error.Error()})
		return
	}

	// update token
	newToken := String(50)
	res := db.Table("users_auth").
		Where("email = ? AND password = ?", params.Email, params.Password).
		Update("token", newToken)

	if res.Error != nil {
		c.JSON(200, gin.H{"success": false, "error": res.Error.Error()})
		return
	}

	// return res
	userMessage.Password = "" // not need pw
	userMessage.Token = newToken
	c.JSON(200, gin.H{"success": true, "data": userMessage})
}

func Register(c *gin.Context) {
	if err := MyHeaderValidate(c); err != nil {
		c.AbortWithStatus(404)
		return
	}

	var params RegisterParams
	if err := c.ShouldBindJSON(&params); err != nil {
		c.JSON(200, gin.H{"success": false, "error": err.Error()})
		return
	}

	userAuth := UsersAuth{Email: params.Email, Password: params.Password}
	userMess := UsersMess{Email: params.Email, Nick: "nick"} // 默认填充 nick

	// 验证验证码
	if value, ok := email2code.Load(params.Email); !ok || params.Code != value {
		// 验证错误 error = -2
		c.JSON(200, gin.H{"success": false, "error": "-2"})
		return
	}

	// 查看是否被注册过
	var userAu UsersAuth
	result := db.Table("users_auth").Where("email = ?", params.Email).Limit(1).Find(&userAu)
	if err := result.Error; err != nil {
		c.JSON(200, gin.H{"success": false, "error": err.Error()})
		return
	}
	if result.RowsAffected != 0 { // 已注册 error = -1表示
		c.JSON(200, gin.H{"success": false, "error": "-1"})
		return
	}

	// 创建账号
	if err := db.Table("users_auth").Create(&userAuth).Error; err != nil {
		c.JSON(200, gin.H{"success": false, "error": err.Error()})
		return
	}

	if err := db.Table("users_mess").Create(&userMess).Error; err != nil {
		c.JSON(200, gin.H{"success": false, "error": err.Error()})
		return
	}

	c.JSON(200, gin.H{"success": true, "error": ""})
}

func ChangeUserMess(c *gin.Context) {
	if err := MyHeaderValidate(c); err != nil {
		c.AbortWithStatus(404)
		return
	}

	var mess UsersMess
	if err := c.ShouldBindJSON(&mess); err != nil {
		c.JSON(200, gin.H{"success": false, "error": err.Error()})
		return
	}

	// 验证token值是否合法
	// find user
	var userMessage UsersAuth
	var re *gorm.DB
	re = db.Table("users_auth").
		Where("email = ? AND token = ?", mess.Email, mess.Token).
		Take(&userMessage)
	if re.Error != nil {
		c.JSON(200, gin.H{"success": false, "error": "Auth fault"})
		return
	}

	// 更新信息表
	var res *gorm.DB
	res = db.Table("users_mess").Updates(mess)
	if res.Error != nil {
		c.JSON(200, gin.H{"success": false, "error": res.Error.Error()})
		return
	}
	if res.RowsAffected == 0 {
		c.JSON(200, gin.H{"success": false, "error": "Affected 0 rows!"})
	} else {
		c.JSON(200, gin.H{"success": true, "error": ""})
	}
}

func GetUserMess(c *gin.Context) {
	if err := MyHeaderValidate(c); err != nil {
		c.AbortWithStatus(404)
		return
	}

	var mess UsersMess
	if err := c.ShouldBindJSON(&mess); err != nil {
		c.JSON(200, gin.H{"success": false, "error": err.Error()})
		return
	}

	// 验证token值是否合法
	// find user
	var userAuth UsersAuth
	var re *gorm.DB
	re = db.Table("users_auth").
		Where("email = ? AND token = ?", mess.Email, mess.Token).
		Take(&userAuth)
	if re.Error != nil {
		c.JSON(200, gin.H{"success": false, "error": "Auth fault"})
		return
	}

	// 获取用户信息
	if err := db.Table("users_mess").Where("email = ?", mess.Email).Take(&mess).Error; err != nil {
		c.JSON(200, gin.H{"success": false, "error": "No record"})
		return
	}
	mess.Token = ""
	c.JSON(200, gin.H{"success": true, "data": mess})
}

func ResetPassWord(c *gin.Context) {
	if err := MyHeaderValidate(c); err != nil {
		c.AbortWithStatus(404)
		return
	}

	var params ResetPassWordParams
	if err := c.ShouldBindJSON(&params); err != nil {
		c.JSON(200, gin.H{"success": false, "error": err.Error()})
		return
	}

	// 验证旧密码
	var user UsersAuth
	var re *gorm.DB
	re = db.Table("users_auth").
		Where("email = ? AND password = ?", params.Email, params.Password).
		Take(&user)

	if re.Error != nil {
		c.JSON(200, gin.H{"success": false, "error": re.Error.Error()})
		return
	}

	// 更新密码和token
	user.Password = params.NewPassword
	user.Token = String(50)

	var res *gorm.DB
	res = db.Table("users_auth").Updates(user)
	if res.Error != nil {
		c.JSON(200, gin.H{"success": false, "error": res.Error.Error()})
		return
	}

	c.JSON(200, gin.H{"success": true, "token": user.Token, "error": ""})
}

func SendAuthCode(c *gin.Context) {
	if err := MyHeaderValidate(c); err != nil {
		c.AbortWithStatus(404)
		return
	}

	// 参数
	type paramsForCode struct {
		Email string `json:"email" binding:"required"`
	}
	var params paramsForCode
	if err := c.ShouldBindJSON(&params); err != nil {
		c.JSON(200, gin.H{"success": false, "error": err.Error()})
		return
	}

	// 邮箱验证
	if !EmailValid(params.Email) {
		c.JSON(200, gin.H{"success": false, "error": "Invalid email"})
		return
	}

	// 发送email 随机验证码
	code := String(6)
	e := email.NewEmail()
	//设置发送方的邮箱
	e.From = "hrj<a2509875617@163.com>"
	// 设置接收方的邮箱
	e.To = []string{params.Email}
	//设置主题
	e.Subject = "注册验证码"
	//设置文件发送的内容
	e.Text = []byte("您的注册验证码为： " + code)
	//设置服务器相关的配置
	// TODO 保护授权码 用配置注入
	err := e.Send("smtp.163.com:25", smtp.PlainAuth("", "a2509875617@163.com", "HTKBUHMYFGRKKRTF", "smtp.163.com"))
	if err != nil {
		c.JSON(200, gin.H{"success": false, "error": err})
		return
	}

	// 保存验证码
	email2code.Store(params.Email, code)
	//fmt.Println(email2code.Load(params.Email))

	c.JSON(200, gin.H{"success": true, "error": ""})
}
