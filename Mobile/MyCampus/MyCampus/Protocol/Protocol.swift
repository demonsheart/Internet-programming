//
//  Protocol.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/26.
//

// tableviewcell 保存内容回调协议
// 由于重用机制 在重用前必须保存内容 否则会丢失输入
// 删除回调也需要更新数据源 因为删除后会reloadData
protocol SaveBeforeReuse {
    associatedtype T
    var saveCallBack: ((T) -> Void)? { get set }
    var deleteCallBack: (() -> Void)? { get set }
}
