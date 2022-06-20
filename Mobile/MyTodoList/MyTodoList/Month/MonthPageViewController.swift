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
import Popover

class MonthPageViewController: BaseViewController {
    
    fileprivate var calendar = FSCalendar()
    fileprivate let viewModel = MonthPageViewModel()
    
    fileprivate var popover: Popover!

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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        viewModel.selectedDate.accept(date)
        let todos = viewModel.selectedTodos
        if todos.count == 0 { return }
        
        let height: CGFloat = min(10 * 48, CGFloat(todos.count) * 48)
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "HomePageTodoVC", bundle: nil), forCellReuseIdentifier: "todo")
        self.popover = Popover(options: [.arrowSize(.zero), .type(.down)])
//        self.popover.show(tableView, point: CGPoint(x: 0, y: 100))
        self.popover.show(tableView, fromView: calendar.calendarHeaderView)
    }
    
//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//    }
    
}

extension MonthPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectedTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! HomePageTodoVC
        cell.render(todo: viewModel.selectedTodos[indexPath.row])
        cell.checkCallBack = { [weak self] id, check in
            self?.viewModel.doneTodo(in: id, to: check)
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popover.dismiss()
        self.popover.didDismissHandler = { [unowned self] in
            let model = viewModel.selectedTodos[indexPath.row].copy()
            let vc = EditNAddTodoViewController(model: model)
            vc.title = "详情"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MonthPageViewController {
    class MonthPageViewModel {
        var todos = BehaviorRelay(value: [ToDoModel]())
        
        var selectedDate = BehaviorRelay(value: Date())
        var selectedTodos = [ToDoModel]()
        
        private let disposeBag = DisposeBag()
        
        init() {
            subscribeDataFromCathe()
            // TODO: date || todos更新都要subscribe
            Observable.combineLatest(selectedDate, todos).subscribe(onNext: { [unowned self] date, todos in
                let dateInRegion = DateInRegion(date, region: Region.local)
                var res = todos.filter { $0.dateRegion.compare(.isSameDay(dateInRegion)) }
                // 排序 未做的在前 高优先级的在前
                res = res.sorted { lhs, rhs in
                    let rule1 = !lhs.done
                    let rule2 = lhs.level > rhs.level
                    return rule1 && rule2
                }
                self.selectedTodos = res
            }).disposed(by: disposeBag)
        }
        
        private func subscribeDataFromCathe() {
            // MARK: 订阅todos
            StoragedToDos.shared.todos.subscribe(onNext: { [unowned self] todos in
                self.todos.accept(todos)
            }).disposed(by: disposeBag)
        }
        
        func doneTodo(in id: Int, to check: Bool) {
            StoragedToDos.shared.doneTodo(in: id, to: check)
        }
        
        func getTodosIn(date: Date) -> [ToDoModel] {
            let dateInRegion = DateInRegion(date, region: Region.local)
            return todos.value.filter { $0.dateRegion.compare(.isSameDay(dateInRegion)) }.sorted { lhs, rhs in
                let rule1 = !lhs.done
                let rule2 = lhs.level > rhs.level
                return rule1 && rule2
            }
        }
    }
}
