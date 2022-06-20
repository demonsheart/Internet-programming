//
//  MonthPageViewController.swift
//  MyTodoList
//
//  Created by aicoin on 2022/5/7.
//

import UIKit
import FSCalendar
import SnapKit
import SwiftDate
import RxRelay
import RxCocoa
import RxSwift

class MonthPageViewController: BaseViewController {
    
    fileprivate var calendar = FSCalendar()
    fileprivate let viewModel = MonthPageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TDLColor.bgGreen
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.locale = Locale(identifier: "zh_cn")
        self.view.addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        calendar.headerHeight = 30
        calendar.weekdayHeight = 30
        calendar.today = nil
        calendar.register(TodoCalendarCell.self, forCellReuseIdentifier: "cell")
        
        viewModel.todos.subscribe(onNext: { [unowned self] _ in
            self.calendar.reloadData()
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let right = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(rightTapped))
        let left = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.3x2"), style: .plain, target: self, action: #selector(leftTapped))
        right.tintColor = TDLColor.iconGray
        left.tintColor = TDLColor.iconGray
        
        navigationItem.rightBarButtonItems = [right]
        navigationItem.leftBarButtonItems = [left]
    }
    
    @objc func rightTapped() {
        
    }
    
    @objc func leftTapped() {
        
    }
    
}

extension MonthPageViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if DateInRegion(date, region: Region.local).isToday {
            return "今"
        }
        return nil
    }
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! TodoCalendarCell
        // MARK: 设置数据源
        cell.setTodos(todos: viewModel.getTodosIn(date: date))
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
}

extension MonthPageViewController {
    class MonthPageViewModel {
        var todos = BehaviorRelay(value: [ToDoModel]())
        private let disposeBag = DisposeBag()
        
        init() {
            subscribeDataFromCathe()
        }
        
        private func subscribeDataFromCathe() {
            // MARK: 订阅todos
            StoragedToDos.shared.todos.subscribe(onNext: { [unowned self] todos in
                self.todos.accept(todos)
            }).disposed(by: disposeBag)
        }
        
        func getTodosIn(date: Date) -> [ToDoModel] {
            let dateInRegion = DateInRegion(date, region: Region.local)
            return todos.value.filter { $0.dateRegion.compare(.isSameDay(dateInRegion)) }
        }
    }
}
