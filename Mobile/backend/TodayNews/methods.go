package main

import (
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"math/rand"
	"net/http"
	"time"
)

// 产生随机数
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
		// 不携带token && account 是普通网络监测心跳包
		c.JSON(200, gin.H{"success": true, "error": ""})
		return
	}

	// 如果携带token && account 则是检测挤号心跳包
	var userMessage Users
	var re *gorm.DB
	re = db.Model(Users{}).
		Where("account = ?", params.Account).
		First(&userMessage)

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
	var userMessage Users
	var re *gorm.DB
	re = db.Model(Users{}).
		Where("account = ? AND password = ?", params.Account, params.Password).
		First(&userMessage)

	if re.Error != nil {
		c.JSON(200, gin.H{"success": false, "error": re.Error.Error()})
		return
	}

	// update token
	newToken := String(50)
	res := db.Model(Users{}).
		Where("account = ? AND password = ?", params.Account, params.Password).
		Update("token", newToken)

	if res.Error != nil {
		c.JSON(200, gin.H{"success": false, "error": res.Error.Error()})
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

	var cus Users
	if err := c.ShouldBindJSON(&cus); err != nil {
		c.JSON(200, gin.H{"success": false, "error": err.Error()})
		return
	}
	if err := db.Create(&cus).Error; err != nil {
		c.JSON(200, gin.H{"success": false, "error": err.Error()})
		return
	}
	c.JSON(200, gin.H{"success": true, "error": ""})
}
