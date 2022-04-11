//
//  RightPicNewsModel.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/11.
//

import Foundation

struct RightPicNewsModel: RandomNews {
    let title: String
    let picURL: String
    let source: String
    let commentNum: Int
    let time: String
    
    static var `default`: [RightPicNewsModel] = [
        RightPicNewsModel(title: "广西“清桉行动”，会不会影响桉树木材的价格吗",
                          picURL: "https://p3.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/9d8b567d4f7d4efa9a42c0c004b03104?from=pc",
                          source: "森林驴", commentNum: 464, time: "三天前"),
    ]
}
