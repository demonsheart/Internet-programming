//
//  ToDoModel.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/15.
//

import Foundation

struct ToDoModel: Codable {
    
    // 6种section isExpired与isDone互斥
    // 1逾期 isExpired == true
    // 2高优先级 level == 3
    // 3中优先级 level == 2
    // 4低优先级 level == 1
    // 5无优先级 level == 0
    // 6已完成 isDone = true
    
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
        ToDoModel(keyword: "H5游戏策划", level: 3, done: false, date: ""),
        ToDoModel(keyword: "宣传视频拍摄", level: 3, done: false, date: ""),
        ToDoModel(keyword: "功能评审会议", level: 3, done: false, date: ""),
        ToDoModel(keyword: "生日会", level: 2, done: false, date: ""),
        ToDoModel(keyword: "瑜伽课", level: 2, done: false, date: ""),
        ToDoModel(keyword: "问候父母", level: 1, done: false, date: ""),
        ToDoModel(keyword: "练琴", level: 1, done: false, date: ""),
        ToDoModel(keyword: "佳佳生日", level: 1, done: false, date: ""),
        ToDoModel(keyword: "交房租", level: 1, done: true, date: ""),
    ]
}

// TODO: 持久化数据
class StoragedToDos {
    static let shared = StoragedToDos()
}
