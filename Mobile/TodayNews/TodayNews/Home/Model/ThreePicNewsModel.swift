//
//  ThreePicNewsModel.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/11.
//

import Foundation

struct ThreePicNewsModel: RandomNews {
    let title: String
    let picURLs: [String]
    let source: String
    let commentNum: Int
    let time: String
    
    static var `default`: [ThreePicNewsModel] = [
        ThreePicNewsModel(title: "手机电量剩一半就充比较好，还是等快没电了再充比较好？为什么？",
                          picURLs: [
                            "https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/99325965658445abab71c0fcde070b51?from=pc",
                            "https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/3fab8e9240fb47a3968b680fabf80aea?from=pc",
                            "https://p9.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/5df6dc8ef0114046a6fe631acc3d8cf9?from=pc",
                          ],
                          source: "坐景观天", commentNum: 83, time: "3月11日"),
    ]
}
