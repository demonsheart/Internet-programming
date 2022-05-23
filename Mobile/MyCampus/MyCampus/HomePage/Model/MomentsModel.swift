//
//  MomentsModel.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import Foundation
import AVFoundation

// AVAudioRecorder AVAudioPlayer

protocol MomentItem {
}

struct MomentTextItem: MomentItem {
    let text: String
    
}

// TODO: https://linsyorozuya.gitbook.io/avfoundation-programming-guide/
// PhotoKit
// 视频、音频后续再实现
// https://developer.apple.com/documentation/photokit/selecting_photos_and_videos_in_ios
struct MomentPicItem: MomentItem {
}

struct MomentAudioItem: MomentItem {
    
}

struct MomentVideoItem: MomentItem {
    
}

struct Owner {
    var avatar: String
    var nick: String
}

// 每个文章可由文字、图片、视频、音频组合形成
// 缓存如何做？ Cache
struct MomentsModel {
    var title: String
    var location: String?
    var timeStamp: String
    var owner: Owner
    var items: [MomentItem]
    
    // 0文本 < 1语音 < 2图片 < 3视频
    var modelType: Int {
        let videoCount = items.reduce(0) { partialResult, item in
            return item is MomentVideoItem ? partialResult + 1 : partialResult
        }
        if videoCount > 0 {
            return 3
        }
        
        let picCount = items.reduce(0) { partialResult, item in
            return item is MomentPicItem ? partialResult + 1 : partialResult
        }
        if picCount > 0 {
            return 2
        }
        
        let voiceCount = items.reduce(0) { partialResult, item in
            return item is MomentAudioItem ? partialResult + 1 : partialResult
        }
        if voiceCount > 0 {
            return 1
        }
        
        return 0;
    }
    
    var overLookHeight: CGFloat {
        var totalHeight: CGFloat = 8 + 15 + 8 + 25 + 8 // 从下往上数 space为8
        switch modelType {
            case 0:
                // 仅title 两行
                totalHeight += 40
            case 1:
                // voice + title
                totalHeight += 30 + 8 + 40
            case 2, 3:
                // pic/video + title
                totalHeight += 130 + 8 + 40
            default:
                totalHeight = 0
        }
        
        return totalHeight + 8 // top space
    }
    
    static var `default`: [MomentsModel] = [
        MomentsModel(title: "总书记的一周（4月4日-4月10日）", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "央视新闻"), items: [
            MomentTextItem(text: ""),
        ]),
        MomentsModel(title: "焦点访谈：并肩战“疫”同心守“沪”", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "央视网"), items: [
            MomentTextItem(text: ""),
            MomentPicItem(),
        ]),
        MomentsModel(title: "雾海中的重庆丰都宛如“天空之城”", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "新华社"), items: [
            MomentAudioItem(),
        ]),
        MomentsModel(title: "习近平关心网信事业发展", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "新华网"), items: [
            MomentVideoItem(),
        ]),
        MomentsModel(title: "小山村“贷”来4300万元的背后", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "人民网"), items: [
            MomentPicItem(),
        ]),
        MomentsModel(title: "吴尊友发文解读动态清零及其四点误解", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "中国网"), items: [
            MomentTextItem(text: ""),
            MomentAudioItem(),
        ]),
    ]
}
