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
    
    init() {
        generateID()
    }
    
    private func generateID() {
        // TODO:
    }
}
