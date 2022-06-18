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
        getDataFromCathe()
    }
    
    private func getDataFromCathe() {
        // TODO: 今天的todos
        data.accept(ToDoModel.default.filter { $0.shouldInHomePage })
    }
    
    private func saveDataToCathe() {
        
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
        let value = data.value
        for i in 0..<value.count {
            if value[i].id == id {
                value[i].done = check
                break
            }
        }
        data.accept(value)
        // TODO: 持久化
    }
    
    func deleteTodo(in id: Int) {
        let value = data.value.filter { $0.id != id }
        data.accept(value)
        // TODO: 持久化
    }
    
    // 当前只考虑同一个section的
    func moveTodo(from: IndexPath, to: IndexPath) {
        guard from != to,
              let sourceModel = todoSections.value[from.section].items[from.row].todo,
              let destinationModel = todoSections.value[to.section].items[to.row].todo
        else { return }
        
        var value = data.value
        if let sourceIndex = value.firstIndex(where: { $0.id == sourceModel.id }), let destinationIndex = value.firstIndex(where: { $0.id == destinationModel.id }) {
            value.move(from: sourceIndex, to: destinationIndex)
            data.accept(value)
            // TODO: 持久化
        } else {
            print("Err move")
        }
    }
    
    func addToDo() {
        
    }
}
