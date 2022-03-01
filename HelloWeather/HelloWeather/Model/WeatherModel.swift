//
//  WeatherModel.swift
//  HelloWeather
//
//  Created by herongjin on 2022/3/1.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    var status: String
    var count: String
    var info: String
    var infocode: String
    var lives: [Life]
}

// MARK: - Life
struct Life: Codable {
    var province: String
    var city: String
    var adcode: String
    var weather: String
    var temperature: String
    var winddirection: String
    var windpower: String
    var humidity: String
    var reporttime: String
    
    var conditionName: String {
        return weatherMap[weather] ?? ""
    }
}

// 字段到图片的映射 https://lbs.amap.com/api/webservice/guide/tools/weather-code#t0
// 这里只列举了部分广东常见天气 待完善
let weatherMap: [String : String] = [
    "晴": "sun.max",
    "少云": "cloud",
    "晴间多云": "cloud.sun",
    "多云": "smoke",
    "阴": "smoke.fill",
    "阵雨": "cloud.rain",
    "雷阵雨": "cloud.bolt.rain",
    "小雨": "cloud.drizzle",
    "中雨": "cloud.hail",
    "大雨": "cloud.rain",
    "暴雨": "cloud.heavyrain",
    "大暴雨": "cloud.heavyrain",
]
