//
//  ToDoModel.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/15.
//

import Foundation
import SwiftDate
import UIKit
import Cache
import RxRelay

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

class ToDoModel: Codable, CustomStringConvertible, Equatable {
    
    static func == (lhs: ToDoModel, rhs: ToDoModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func copy() -> ToDoModel {
        return ToDoModel(id: id, keyword: keyword, content: content, level: level, done: done, date: date)
    }
    
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
    
    init() {
        self.id = -1
        self.keyword = ""
        self.content = nil
        self.level = 0
        self.done = false
        self.date = ""
    }
    
    var description: String {
        return "id: \(id), keyword: \(keyword), level: \(level), done: \(done), date: \(dateStr)\n content: \(content ?? "")\n"
    }
    
    var datetime: TimeInterval {
        return TimeInterval(Double(date) ?? Date().timeIntervalSince1970)
    }
    
    var dateRegion: DateInRegion {
        return DateInRegion(seconds: datetime, region: Region.local)
    }
    
    // 时间展示规则
    var dateStr: String {
        let region = dateRegion
        if region.isToday {
            return "今天"
        } else if region.isYesterday {
            return "昨天"
        } else if region.isTomorrow {
            return "明天"
        } else {
            return region.toFormat("MM-dd")
        }
    }
    
    // 是否逾期 逾期不管level全都放在一个section里面
    var isExpired: Bool {
        return dateRegion.isBeforeDate(DateInRegion(region: Region.local), granularity: .day)
    }
    
    var shouldInHomePage: Bool {
        return dateRegion.isBeforeDate(DateInRegion(region: Region.local), orEqual: true, granularity: .day)
    }
    
    var color: UIColor {
        switch type {
        case .done, .none:
            return TDLColor.nonePriority
        case .expired:
            switch level {
            case 1: return TDLColor.lowPriority
            case 2: return TDLColor.middlePriority
            case 3: return TDLColor.highPriority
            default: return TDLColor.nonePriority
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
        return (dateStr, TDLColor.nonePriority)
    }
    
    static var `default`: [ToDoModel] = [
        ToDoModel(id: 0, keyword: "H5游戏策划", level: 3, done: false, date: "1655683305"),
        ToDoModel(id: 1, keyword: "宣传视频拍摄", level: 3, done: false, date: "1655683305"),
        ToDoModel(id: 2, keyword: "功能评审会议", level: 3, done: false, date: "1655683305"),
        ToDoModel(id: 3, keyword: "生日会", level: 2, done: false, date: "1655683305"),
        ToDoModel(id: 4, keyword: "瑜伽课", level: 2, done: false, date: "1655683305"),
        ToDoModel(id: 5, keyword: "问候父母", level: 1, done: false, date: "1655683305"),
        ToDoModel(id: 6, keyword: "练琴", level: 1, done: false, date: "1655683305"),
        ToDoModel(id: 7, keyword: "佳佳生日", level: 1, done: false, date: "1655683305"),
        ToDoModel(id: 8, keyword: "交房租", level: 1, done: true, date: "1655683305"),
        ToDoModel(id: 9, keyword: "梦华录", level: 3, done: false, date: "1655380640"),
        ToDoModel(id: 10, keyword: "斗罗大陆", level: 1, done: false, date: "1655380640"),
        ToDoModel(id: 11, keyword: "王者", level: 2, done: false, date: "1655380640"),
        ToDoModel(id: 12, keyword: "完结", level: 2, done: false, date: "1655900173"),
        ToDoModel(id: 13, keyword: "快递", level: 0, done: false, date: "1655380640"),
    ]
}

// MARK: 持久化数据
class StoragedToDos {
    static let shared = StoragedToDos()
    
    // 暴露订阅源
    var todos = BehaviorRelay(value: [ToDoModel]())
    
    private let key = "ToDos"
    private var list = [ToDoModel]()
    
    private lazy var storage: Storage<String, [ToDoModel]>? = {
        let diskConfig = DiskConfig(name: "Floppy")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

        let storage = try? Storage<String, [ToDoModel]>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: [ToDoModel].self)
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
            self.todos.accept(list)
        } else {
            // 没记录则初始化默认值
            self.list = ToDoModel.default
            self.todos.accept(list)
        }
    }
    
    private func writeToCache() {
        guard let storage = storage else {
            print("storage not init")
            return
        }
        try? storage.setObject(list, forKey: key, expiry: .never)
    }
    
    // 新id生成 缓存中最大值+1
    private var newId: Int {
        var id: Int = 0;
        for model in list {
            id = max(id, model.id)
        }
        return id + 1;
    }
    
    func insert(new model: ToDoModel) {
        model.id = newId
        var value = todos.value
        value.append(model)
        list = value
        todos.accept(list)
        writeToCache()
    }
    
    func delete(in model: ToDoModel) {
        let value = todos.value.filter { $0 != model }
        list = value
        todos.accept(list)
        writeToCache()
    }
    
    func delete(id: Int) {
        let value = todos.value.filter { $0.id != id }
        list = value
        todos.accept(list)
        writeToCache()
    }
    
    func update(in model: ToDoModel) {
        var value = todos.value
        if let index = value.firstIndex(of: model) {
            value[index] = model
            list = value
            todos.accept(list)
            writeToCache()
        } else {
            print("update Fail")
        }
    }
    
    func doneTodo(in id: Int, to check: Bool) {
        let value = todos.value
        for i in 0..<value.count {
            if value[i].id == id {
                value[i].done = check
                break
            }
        }
        list = value
        todos.accept(list)
        writeToCache()
    }
    
    func moveTodo(from: ToDoModel, to: ToDoModel) {
        var value = todos.value
        if let sourceIndex = value.firstIndex(where: { $0.id == from.id }), let destinationIndex = value.firstIndex(where: { $0.id == to.id }) {
            value.move(from: sourceIndex, to: destinationIndex)
            list = value
            todos.accept(list)
            writeToCache()
        } else {
            print("Err move")
        }
    }
    
}
