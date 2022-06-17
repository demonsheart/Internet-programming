//
//  HomePageListViewModel.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/15.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
import RxRelay

class HomePageListViewModel {
    let sectionListSubject = BehaviorSubject(value: [SectionOfHPCellData]())
    
    let data = ToDoModel.default
    
//    let expiredList = BehaviorRelay
    
    init() {
        sectionListSubject.onNext([
            SectionOfHPCellData(header: "", items: [
                .search
            ]),
            SectionOfHPCellData(header: "已过期", items: data.filter{ $0.type == .expired }.map({ model in
                return HomePageListCellModel.list(model)
            })),
            SectionOfHPCellData(header: "高优先级", items: data.filter{ $0.type == .high }.map({ model in
                return HomePageListCellModel.list(model)
            })),
            SectionOfHPCellData(header: "中优先级", items: data.filter{ $0.type == .middle }.map({ model in
                return HomePageListCellModel.list(model)
            })),
            SectionOfHPCellData(header: "低优先级", items: data.filter{ $0.type == .low }.map({ model in
                return HomePageListCellModel.list(model)
            })),
            SectionOfHPCellData(header: "无优先级", items: data.filter{ $0.type == .none }.map({ model in
                return HomePageListCellModel.list(model)
            })),
        ])
    }
}
