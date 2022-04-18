package main

import (
	"database/sql/driver"
	"reflect"
	"time"
)

// https://segmentfault.com/a/1190000022264001

const TimeFormat = "2006-01-02 15:04:05"

type LocalTime time.Time

func (t *LocalTime) UnmarshalJSON(data []byte) (err error) {
	// 空值不进行解析
	if len(data) == 2 {
		*t = LocalTime(time.Time{})
		return
	}

	// 指定解析的格式
	loc, _ := time.LoadLocation("Asia/Shanghai")
	now, err := time.ParseInLocation(`"`+TimeFormat+`"`, string(data), loc)
	*t = LocalTime(now)
	return
}

func (t LocalTime) MarshalJSON() ([]byte, error) {
	b := make([]byte, 0, len(TimeFormat)+2)
	b = append(b, '"')
	b = time.Time(t).AppendFormat(b, TimeFormat)
	b = append(b, '"')
	return b, nil
}

func (t LocalTime) Value() (driver.Value, error) {
	// 0001-01-01 00:00:00 属于空值，遇到空值解析成 null 即可
	if t.String() == "0001-01-01 00:00:00" {
		return nil, nil
	}
	return []byte(time.Time(t).Format(TimeFormat)), nil
}

func (t *LocalTime) Scan(v interface{}) error {
	// mysql 内部日期的格式可能是 2006-01-02 15:04:05 +0800 CST 格式，所以检出的时候还需要进行一次格式化
	tTime, _ := time.Parse("2006-01-02 15:04:05 +0800 CST", v.(time.Time).String())
	*t = LocalTime(tTime)
	return nil
}

// 用于 fmt.Println 和后续验证场景
func (t LocalTime) String() string {
	return time.Time(t).Format(TimeFormat)
}

func ValidateJSONDateType(field reflect.Value) interface{} {
	if field.Type() == reflect.TypeOf(LocalTime{}) {
		timeStr := field.Interface().(LocalTime).String()
		// 0001-01-01 00:00:00 是 go 中 time.Time 类型的空值
		// 这里返回 Nil 则会被 validator 判定为空值，而无法通过 `binding:"required"` 规则
		if timeStr == "0001-01-01 00:00:00" {
			return nil
		}
		return timeStr
	}
	return nil
}

// MyHeader 个人验证
type MyHeader struct {
	UserAgent string `header:"User-Agent"`
}

// Users 表
type Users struct {
	// old key need to define as pointer type so that we can know if is set by nil.
	OldKeyValue *string `gorm:"-" json:"old_key_value,omitempty"`
	ID          string  `gorm:"column:id;primaryKey;unique" json:"-"`
	Account     string  `gorm:"column:account" json:"account" binding:"required"`
	Password    string  `gorm:"column:password" json:"password" binding:"required"`
	Token       string  `gorm:"column:token" json:"token"`
}

type LoginParams struct {
	Account  string `json:"account" binding:"required"`
	Password string `json:"password" binding:"required"`
}

// HeartbeatParams 一般而言 token应携带了登录的账号密码信息 但这里没实现 故也需要一个account确定用户
type HeartbeatParams struct {
	Account string `json:"account" binding:"required"`
	Token   string `json:"token" binding:"required"`
}
