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
import CoreText

class HomePageListViewModel {
    let todoSections = BehaviorRelay(value: [SectionOfHPCellData]())
    
    private let data = BehaviorRelay(value: [ToDoModel]())
    
    private let disposeBag = DisposeBag()
    
    init() {
        bindSections()
        subscribeDataFromCathe()
    }
    
    private func subscribeDataFromCathe() {
        // MARK: 订阅今天的todos
        StoragedToDos.shared.todos.subscribe(onNext: { [unowned self] todos in
            self.data.accept(todos.filter { $0.shouldInHomePage })
        }).disposed(by: disposeBag)
    }
    
    private func bindSections() {
        data.subscribe (onNext: { [unowned self] todos in
            var sections = [SectionOfHPCellData]()
            sections.append(SectionOfHPCellData(header: "", items: [.search]))
            if let section = self.section(todos: todos, type: .expired) {
                sections.append(section)
            }
            if let section = self.section(todos: todos, type: .high) {
                sections.append(section)
            }
            if let section = self.section(todos: todos, type: .middle) {
                sections.append(section)
            }
            if let section = self.section(todos: todos, type: .low) {
                sections.append(section)
            }
            if let section = self.section(todos: todos, type: .none) {
                sections.append(section)
            }
            if let section = self.section(todos: todos, type: .done) {
                sections.append(section)
            }
            
            self.todoSections.accept(sections)
        }).disposed(by: disposeBag)
    }
    
    private func section(todos: [ToDoModel], type: ToDoType) ->  SectionOfHPCellData? {
        let item = todos.filter{ $0.type == type }
        if item.count == 0 {
            return nil
        } else {
            return SectionOfHPCellData(header: type.header, items: item.map{ HomePageListCellModel.list($0) })
        }
    }
    
    // MARK: - cell 各种操作
    
    func doneTodo(in id: Int, to check: Bool) {
        StoragedToDos.shared.doneTodo(in: id, to: check)
    }
    
    func deleteTodo(in id: Int) {
        StoragedToDos.shared.delete(id: id)
    }
    
    // 当前只考虑同一个section的
    func moveTodo(from: IndexPath, to: IndexPath) {
        guard from != to,
              let sourceModel = todoSections.value[from.section].items[from.row].todo,
              let destinationModel = todoSections.value[to.section].items[to.row].todo
        else { return }
        StoragedToDos.shared.moveTodo(from: sourceModel, to: destinationModel)
    }
}
