//
//  TopNewsModel.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/11.
//

import Foundation

var nextRamdom = false
struct TopNewsModel {
    let title: String
    let isTop: Bool
    let source: String
    let commentNum: Int
    
    static func randomGetTopNews() -> [TopNewsModel] {
        if nextRamdom {
            nextRamdom.toggle()
            return TopNewsModel.default
        } else {
            nextRamdom.toggle()
            return TopNewsModel.default2
        }
    }
    
    static var `default`: [TopNewsModel] = [
        TopNewsModel(title: "总书记的一周（4月4日-4月10日）", isTop: true, source: "央视新闻", commentNum: 4492),
        TopNewsModel(title: "焦点访谈：并肩战“疫”同心守“沪” ", isTop: true, source: "央视网", commentNum: 1209),
        TopNewsModel(title: "1200多公里 异地转运守护患者生命", isTop: true, source: "央视新闻", commentNum: 8869),
        TopNewsModel(title: "雾海中的重庆丰都宛如“天空之城”", isTop: false, source: "新华社", commentNum: 2509),
        TopNewsModel(title: "视频｜新华全媒+｜“黑土粮仓”春日农事忙", isTop: false, source: "新华网", commentNum: 3452),
    ]
    
    static var `default2`: [TopNewsModel] = [
        TopNewsModel(title: "习近平关心网信事业发展", isTop: true, source: "人民网", commentNum: 1805),
        TopNewsModel(title: "当前中国经济十问", isTop: true, source: "新华社", commentNum: 749),
        TopNewsModel(title: "把稳增长放在更加突出位置", isTop: true, source: "经济日报", commentNum: 145),
        TopNewsModel(title: "小山村“贷”来4300万元的背后", isTop: false, source: "新华社", commentNum: 2482),
        TopNewsModel(title: "吴尊友发文解读动态清零及其四点误解", isTop: false, source: "中国网", commentNum: 3881),
    ]
}
