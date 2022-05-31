//
//  MomentsModel.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import Foundation
import AVFoundation
import UIKit
import SwiftDate
import Cache

enum StorageError: Error {
  /// Object can not be found
  case notFound
  /// Object is found, but casting to requested type failed
  case typeNotMatch
  /// The file attributes are malformed
  case malformedFileAttributes
  /// Can't perform Decode
  case decodingFailed
  /// Can't perform Encode
  case encodingFailed
  /// The storage has been deallocated
  case deallocated
  /// Fail to perform transformation to or from Data
  case transformerFail
}

class MomentTextItem: Codable {
    var text: String
    
    init(text: String) {
        self.text = text
    }
}

class MomentPicItem: Codable {
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    enum CodingKeys: String, CodingKey {
        case image
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        guard let image = UIImage(data: data) else {
            throw StorageError.decodingFailed
        }
        
        self.image = image
    }
    
    // cache_toData() wraps UIImagePNG/JPEGRepresentation around some conditional logic with some whipped cream and sprinkles.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let data = image.cache_toData() else {
            throw StorageError.encodingFailed
        }
        
        try container.encode(data, forKey: CodingKeys.image)
    }
}

class MomentAudioItem: Codable {
    // AVAudioRecorder AVAudioPlayer
    
}

class MomentVideoItem: Codable {
    // YPImagePicker已经做了导出缓存 但是暂时缓存 需要另外做一次持久缓存
    // fileURL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingUniquePathComponent(pathExtension: YPConfig.video.fileType.fileExtension)
    // PHCachingImageManager().requestAVAssetForVideo
    
    // AVPlayer AVPlayerItem
    // YPVideoView -- setPreviewImage setAssetFrame
    // ||| loadVideo play deallocate
    
    var url: String
    
    var thumbnail: UIImage {
        guard let ur = URL(string: url) else { return UIImage() }
        let asset = AVURLAsset(url: ur, options: nil)
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        var actualTime = CMTimeMake(value: 0, timescale: 0)
        let image: CGImage
        do {
            image = try gen.copyCGImage(at: time, actualTime: &actualTime)
            let thumbnail = UIImage(cgImage: image)
            return thumbnail
        } catch { }
        
        return UIImage()
    }
//    var asset: PHAsset?
//
//    var avAsset: AVAsset {
//        return AVAsset(url: url)
//    }
    
    init(url: String) {
        self.url = url
    }
}

enum MomentItemWrapper: Codable {
    case text(MomentTextItem)
    case pic(MomentPicItem)
    case audio(MomentAudioItem)
    case video(MomentVideoItem)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let data = try? container.decode(MomentTextItem.self) {
            self = .text(data)
        } else if let data = try? container.decode(MomentPicItem.self) {
            self = .pic(data)
        } else if let data = try? container.decode(MomentAudioItem.self) {
            self = .audio(data)
        } else if let data = try? container.decode(MomentVideoItem.self) {
            self = .video(data)
        } else {
            throw StorageError.decodingFailed
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let text):
            try container.encode(text)
        case .pic(let pic):
            try container.encode(pic)
        case .audio(let audio):
            try container.encode(audio)
        case .video(let video):
            try container.encode(video)
        }
    }
}

struct Owner: Codable {
    var avatar: String
    var nick: String
    // TODO: subText
}

// 每个文章可由文字、图片、视频、音频组合形成
class MomentsModel: Codable {
    var title: String
    var location: String?
    var timeStamp: String
    var owner: Owner
    var items: [MomentItemWrapper]
    
    init(title: String, location: String?, timeStamp: String, owner: Owner, items: [MomentItemWrapper]) {
        self.title = title
        self.location = location
        self.timeStamp = timeStamp
        self.owner = owner
        self.items = items
    }
    
    var firstImage: UIImage? {
        var image: UIImage? = nil
        for item in items {
            switch item {
            case .text(_):
                break
            case .pic(let imageItem):
                image = imageItem.image
            case .audio(_):
                break
            case .video(let videoItem):
                image = videoItem.thumbnail
            }
            if image != nil { break }
        }
        return image
    }
    
    var firstImageHeight: CGFloat {
        var height: CGFloat = 130
        if let firstImage = firstImage {
            height = firstImage.getImageHeight(width: (UIScreen.main.bounds.size.width - 3 * 8)/2)
        }
        return height
    }
    
    var formattedTimeStr: String {
        guard let intStamp = TimeInterval(timeStamp) else { return "" }
        
        var timeText = ""
        let date = DateInRegion(seconds: intStamp, region: Date.currentRome)
        let current = DateInRegion(seconds: Date().timeIntervalSince1970, region: Date.currentRome)
        let timeIntervalMinute = date.getInterval(toDate: current, component: .minute)
        
        if timeIntervalMinute <= 1 && timeIntervalMinute >= 0 {
            timeText = "刚刚"
        } else if timeIntervalMinute > 1 && timeIntervalMinute < 60 {
            timeText = String(format: "%d分钟前", Int(timeIntervalMinute))
        } else if timeIntervalMinute >= 60 && timeIntervalMinute < 24 * 60 {
            timeText = String(format: "%d小时前", Int(timeIntervalMinute / 60))
        } else {
            // 超过24小时展示时间
            if date.compare(.isThisYear) {
                timeText = date.toFormat("HH:mm MM/dd")
            } else {
                timeText = date.toFormat("HH:mm yyyy/MM/dd")
            }
        }
        
        return timeText
    }
    
    // 0文本 < 1图片 < 2视频
    var modelType: Int {
        var videoCount = 0
        var picCount = 0
        var textCount = 0
        var audioCount = 0
        for item in items {
            switch item {
            case .text(_):
                textCount += 1
            case .pic(_):
                picCount += 1
            case .audio(_):
                audioCount += 1
            case .video(_):
                videoCount += 1
            }
        }
        
        if videoCount > 0 { return 2 }
        if picCount > 0 { return 1 }
        
        return 0;
    }
    
    var overLookHeight: CGFloat {
        var totalHeight: CGFloat = 8 + 15 + 8 + 40 + 8 // 从下往上数 space为8
        let margin: CGFloat = 8
        let titleHeight = title.height(withConstrainedWidth: (UIScreen.main.bounds.width - 3 * margin)/2 - 2 * margin, font: .systemFont(ofSize: 14))
        switch modelType {
            case 0:
                // 仅title + topSpace
                totalHeight += titleHeight + 10
            case 1, 2:
                // pic/video + title
                totalHeight += firstImageHeight + margin + titleHeight
            default:
                totalHeight = 0
        }
        
        return totalHeight
    }
    
    static var `default`: [MomentsModel] = [
        MomentsModel(title: "总书记的一周", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "央视新闻"), items: [
            MomentItemWrapper.text(MomentTextItem(text: "")),
        ]),
        MomentsModel(title: "焦点访谈：并肩战“疫”同心守“沪”", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "央视网"), items: [
            MomentItemWrapper.text(MomentTextItem(text: "")),
            MomentItemWrapper.pic(MomentPicItem(image: UIImage(systemName: "airtag.fill")!)),
        ]),
        MomentsModel(title: "雾海中的重庆丰都宛如“天空之城”", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "新华社"), items: [
            MomentItemWrapper.audio(MomentAudioItem()),
        ]),
        MomentsModel(title: "习近平关心网信事业发展", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "新华网"), items: [
            MomentItemWrapper.video(MomentVideoItem(url: "")),
        ]),
        MomentsModel(title: "小山村“贷”来4300万元的背后", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "人民网"), items: [
            MomentItemWrapper.pic(MomentPicItem(image: UIImage(systemName: "airtag.fill")!))
        ]),
        MomentsModel(title: "吴尊友发文解读动态清零及其四点误解,据网友爆料，吴尊为了他的妻子", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "中国网"), items: [
            MomentItemWrapper.text(MomentTextItem(text: "")),
            MomentItemWrapper.audio(MomentAudioItem()),
        ]),
    ]
    
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case title
        case location
        case timeStamp
        case owner
        case items
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        location = try? values.decode(String.self, forKey: .location)
        timeStamp = try values.decode(String.self, forKey: .timeStamp)
        owner = try values.decode(Owner.self, forKey: .owner)
        items = try values.decode([MomentItemWrapper].self, forKey: .items)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(location, forKey: .location)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(owner, forKey: .owner)
        try container.encode(items, forKey: .items)
    }
}

// MARK: StoragedMoments
class StoragedMoments {
    
    static let shared = StoragedMoments()
    
    var key = "MomentsModels"
    
    var list: [MomentsModel] = [MomentsModel]() {
        didSet {
            writeToCache()
        }
    }
    
    // FIXME: 每次Application/下的目录会变
    var videoFileDirectory: URL {
        return getDirectoryPath().appendingPathComponent("video", isDirectory: true)
    }
    
    lazy var storage: Storage<String, [MomentsModel]>? = {
        let diskConfig = DiskConfig(name: "Floppy")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

        let storage = try? Storage<String, [MomentsModel]>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: [MomentsModel].self)
        )
        
        return storage
    }()
    
    init() {
        guard let storage = storage else {
            print("storage not init")
            return
        }
        if let list = try? storage.object(forKey: key) {
            self.list = list
        }
        
        // 创建video目录
        do {
            try FileManager.default.createDirectory(at: videoFileDirectory, withIntermediateDirectories: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func writeToCache() {
        guard let storage = storage else {
            print("storage not init")
            return
        }
        try? storage.setObject(list, forKey: key, expiry: .date(Date().addingTimeInterval(45 * 24 * 60 * 60)))
    }
    
    private func getDirectoryPath() -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let fileURL = URL(fileURLWithPath: documentsDirectory)
        
        return fileURL
    }
}
