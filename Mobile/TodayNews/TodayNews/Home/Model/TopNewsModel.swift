//
//  TopNewsModel.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/11.
//

import Foundation

struct TopNewsModel {
    let title: String
    let isTop: Bool
    let source: String
    let commentNum: Int
    
    static var `default`: [TopNewsModel] = [
        TopNewsModel(title: "总书记的一周（4月4日-4月10日）", isTop: true, source: "央视新闻", commentNum: 4492),
        TopNewsModel(title: "焦点访谈：并肩战“疫”同心守“沪” ", isTop: true, source: "央视网", commentNum: 1209),
        TopNewsModel(title: "1200多公里 异地转运守护患者生命", isTop: true, source: "央视新闻", commentNum: 8869),
        TopNewsModel(title: "雾海中的重庆丰都宛如“天空之城”", isTop: false, source: "新华社", commentNum: 2509),
        TopNewsModel(title: "视频｜新华全媒+｜“黑土粮仓”春日农事忙", isTop: false, source: "新华网", commentNum: 3452),
    ]
}
