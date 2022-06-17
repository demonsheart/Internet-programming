//
//  ToDoModel.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/15.
//

import Foundation

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

struct ToDoModel: Codable {
    
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
    
    // 是否逾期 逾期不管level全都放在一个section里面
    var isExpired: Bool {
        return false
    }
    
    static var `default`: [ToDoModel] = [
        ToDoModel(id: 0, keyword: "H5游戏策划", level: 3, done: false, date: ""),
        ToDoModel(id: 1, keyword: "宣传视频拍摄", level: 3, done: false, date: ""),
        ToDoModel(id: 2, keyword: "功能评审会议", level: 3, done: false, date: ""),
        ToDoModel(id: 3, keyword: "生日会", level: 2, done: false, date: ""),
        ToDoModel(id: 4, keyword: "瑜伽课", level: 2, done: false, date: ""),
        ToDoModel(id: 5, keyword: "问候父母", level: 1, done: false, date: ""),
        ToDoModel(id: 6, keyword: "练琴", level: 1, done: false, date: ""),
        ToDoModel(id: 7, keyword: "佳佳生日", level: 1, done: false, date: ""),
        ToDoModel(id: 8, keyword: "交房租", level: 1, done: true, date: ""),
    ]
}

// TODO: 持久化数据
class StoragedToDos {
    static let shared = StoragedToDos()
}
