//
//  BigPicNewsModel.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/11.
//

import Foundation

struct BigPicNewsModel: RandomNews {
    let title: String
    let picURL: String
    let source: String
    let commentNum: Int
    let time: String
    
    static var `default`: [BigPicNewsModel] = [
        BigPicNewsModel(title: "2022年“五一”放假安排来了！放假调休共5天",
                        picURL: "https://p3.toutiaoimg.com/tos-cn-i-tjoges91tu/T2aWwq7j7Xmd8~tplv-tt-cs0:640:360.jpg?from=feed&_iz=31826",
                        source: "光明网", commentNum: 460, time: "18小时前"),
    ]
}
