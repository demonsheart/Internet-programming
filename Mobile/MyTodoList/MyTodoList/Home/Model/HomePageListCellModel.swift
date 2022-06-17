//
//  HomePageListCellModel.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/16.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
import RxRelay


enum HomePageListCellModel {
    case search
    case list(ToDoModel)
}

struct SectionOfHPCellData {
  var header: String
  var items: [Item]
}

extension SectionOfHPCellData: SectionModelType {
  typealias Item = HomePageListCellModel

   init(original: SectionOfHPCellData, items: [Item]) {
    self = original
    self.items = items
  }
}
