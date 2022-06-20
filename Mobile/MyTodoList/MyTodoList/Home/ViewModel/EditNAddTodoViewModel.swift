//
//  EditNAddTodoViewModel.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/19.
//

import Foundation
import RxRelay
import RxCocoa
import RxSwift

class EditNAddTodoViewModel {
    
    var model = ToDoModel()
    
    var isEdit = false
    
    func commit(complete: @escaping (Bool) -> Void) {
        debugPrint(model)
        if isEdit { // 修改
            StoragedToDos.shared.update(in: model)
            complete(true)
        } else { // 新增
            StoragedToDos.shared.insert(new: model)
            complete(true)
        }
    }
}
