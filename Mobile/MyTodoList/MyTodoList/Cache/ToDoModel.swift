//
//  ToDoModel.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/15.
//

import Foundation
import SwiftDate
import UIKit

enum ToDoType: Int {
    case done = 5
    case expired = 4
    case high = 3
    case middle = 2
    case low = 1
    case none = 0
    
    var header: String {
        switch self {
        case .done:
            return "已完成"
        case .expired:
            return "已过期"
        case .high:
            return "高优先级"
        case .middle:
            return "中优先级"
        case .low:
            return "低优先级"
        case .none:
            return "无优先级"
        }
    }
}

class ToDoModel: Codable, CustomStringConvertible {
    // 今天: 日期为今天的 + 逾期的
    
    // 6种section isExpired与isDone互斥
    // 1逾期 isExpired == true
    // 2高优先级 level == 3
    // 3中优先级 level == 2
    // 4低优先级 level == 1
    // 5无优先级 level == 0
    // 6已完成 isDone = true
    var type: ToDoType {
        if done { return .done }
        if isExpired { return .expired }
        return ToDoType.init(rawValue: level) ?? .none
    }
    
    var id: Int
    var keyword: String
    var content: String? // mardown格式正文内容 图片看情况支持
    var level: Int // 0 1 2 3四个section
    var done: Bool
    var date: String // timeStamp
    
    init(id: Int, keyword: String, content: String? = nil, level: Int, done: Bool, date: String) {
        self.id = id
        self.keyword = keyword
        self.content = content
        self.level = level
        self.done = done
        self.date = date
    }
    
    var description: String {
        return "\(id), \(keyword)"
    }
    
    var datetime: TimeInterval {
        return TimeInterval(Double(date) ?? 0.years.timeInterval)
    }
    
    // 是否逾期 逾期不管level全都放在一个section里面
    var isExpired: Bool {
        return DateInRegion(seconds: datetime).isBeforeDate(DateInRegion(), granularity: .day)
    }
    
    var shouldInHomePage: Bool {
        return DateInRegion(seconds: datetime).isBeforeDate(DateInRegion(), orEqual: true, granularity: .day)
    }
    
    var color: UIColor {
        switch type {
        case .done, .none:
            return .lightGray
        case .expired:
            switch level {
            case 1: return TDLColor.lowPriority
            case 2: return TDLColor.middlePriority
            case 3: return TDLColor.highPriority
            default: return .lightGray
            }
        case .high:
            return TDLColor.highPriority
        case .middle:
            return TDLColor.middlePriority
        case .low:
            return TDLColor.lowPriority
        }
    }
    
    var dateTuple: (String, UIColor) {
        // TODO: 时间显示规则
        return ("18:00", .lightGray)
    }
    
    static var `default`: [ToDoModel] = [
        ToDoModel(id: 0, keyword: "H5游戏策划", level: 3, done: false, date: "1655603491"),
        ToDoModel(id: 1, keyword: "宣传视频拍摄", level: 3, done: false, date: "1655603491"),
        ToDoModel(id: 2, keyword: "功能评审会议", level: 3, done: false, date: "1655603491"),
        ToDoModel(id: 3, keyword: "生日会", level: 2, done: false, date: "1655603491"),
        ToDoModel(id: 4, keyword: "瑜伽课", level: 2, done: false, date: "1655603491"),
        ToDoModel(id: 5, keyword: "问候父母", level: 1, done: false, date: "1655603491"),
        ToDoModel(id: 6, keyword: "练琴", level: 1, done: false, date: "1655603491"),
        ToDoModel(id: 7, keyword: "佳佳生日", level: 1, done: false, date: "1655603491"),
        ToDoModel(id: 8, keyword: "交房租", level: 1, done: true, date: "1655603491"),
        ToDoModel(id: 9, keyword: "梦华录", level: 3, done: false, date: "1655380640"),
        ToDoModel(id: 10, keyword: "斗罗大陆", level: 1, done: false, date: "1655380640"),
        ToDoModel(id: 11, keyword: "王者", level: 2, done: false, date: "1655380640"),
        ToDoModel(id: 12, keyword: "完结", level: 2, done: false, date: "1655900173"),
        ToDoModel(id: 13, keyword: "快递", level: 0, done: false, date: "1655380640"),
    ]
}

// TODO: 持久化数据
class StoragedToDos {
    static let shared = StoragedToDos()
}
