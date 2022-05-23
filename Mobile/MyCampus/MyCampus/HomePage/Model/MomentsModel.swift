//
//  MomentsModel.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import Foundation
import AVFoundation

// AVAudioRecorder AVAudioPlayer

protocol MomentItem: Codable {
    var position: Int { get set } // item在正文中的顺序号 正文依照此项顺序排列
}

struct MomentTextItem: MomentItem {
    var position: Int
    
    let text: String
    
}

struct MomentPicItem: MomentItem {
    var position: Int
    
    let picture: String
}

// TODO: https://linsyorozuya.gitbook.io/avfoundation-programming-guide/
// PhotoKit
// 视频、音频后续再实现
// https://developer.apple.com/documentation/photokit/selecting_photos_and_videos_in_ios

struct MomentVoiceItem: MomentItem {
    var position: Int
    
}

struct MomentVideoItem: MomentItem {
    var position: Int
    
}

struct Owner: Codable {
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
    
    // 0仅文本 1有图片 2仅语音 3有视频
//    var modelType: Int {
//        
//    }
}
