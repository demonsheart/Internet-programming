//
//  EditNAddTodoViewController.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import MarkdownView
import IQKeyboardManagerSwift
import Popover
import FSCalendar
import SwiftDate
import EventKit
import Toaster

class EditNAddTodoViewController: BaseViewController {
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var flagBtn: UIButton!
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var titleTextView: IQTextView!
    @IBOutlet weak var mdView: MarkdownView! // 渲染后
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    
    @IBOutlet weak var inputScrollView: UIScrollView! // 渲染前
    
    var isRender = BehaviorRelay(value: false)
    var isCheck = BehaviorRelay(value: false)
    var flagSelected = BehaviorRelay(value: 0)
    var dateSelected = BehaviorRelay(value: DateInRegion(region: Region.local))
    
    let viewModel = EditNAddTodoViewModel()
    
    // popover
    fileprivate let levels = [3, 2, 1, 0]
    fileprivate let flagItemHeight: CGFloat = 45
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
      .type(.down),
      .arrowSize(.zero),
      .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    // luna calendar
    fileprivate let chineseCalendar = Calendar(identifier: .chinese)
    fileprivate let lunarChars = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
    fileprivate var events: [EKEvent]?
    
    convenience init(model: ToDoModel? = nil) {
        self.init(nibName: nil, bundle: nil)
        if let model = model {
            viewModel.model = model
            viewModel.isEdit = true
        }
        fetchEvents {
            
        }
    }
    
    // MARK: fetch events
    func fetchEvents(complete: @escaping () -> Void) {
        let store = EKEventStore()
        store.requestAccess(to: .event) { [weak self] granted, err in
            if granted {
                let start = Date() - 6.months
                let end = Date() + 6.months
                let fetchCalendarEvents = store.predicateForEvents(withStart: start, end: end, calendars: nil)
                let eventList = store.events(matching: fetchCalendarEvents)
                let events = eventList.filter { event in
                    return event.calendar.isSubscribed
                }
                self?.events = events
            }
            complete()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerWidth.constant = UIScreen.main.bounds.width - 20
        self.view.backgroundColor = .white
        
        // 初始化 同步model至UI
        titleTextView.text = viewModel.model.keyword
        textView.text = viewModel.model.content
        checkBox.isSelected = viewModel.model.done
        isCheck.accept(viewModel.model.done)
        dateBtn.setTitle(viewModel.model.dateStr, for: .normal)
        dateSelected.accept(viewModel.model.dateRegion)
        changeColor(to: viewModel.model.color)
        flagSelected.accept(viewModel.model.level)
        
        // textview
        titleTextView.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
        // checkBox
        checkBox.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.checkBox.isSelected.toggle()
                self.isCheck.accept(self.checkBox.isSelected)
            }).disposed(by: disposeBag)
        
        isCheck.subscribe(onNext: { [unowned self] check in
            self.viewModel.model.done = check
            if check {
                self.changeColor(to: TDLColor.nonePriority)
            } else {
                self.changeColor(to: self.viewModel.model.color)
            }
        }).disposed(by: disposeBag)
        
        flagSelected.subscribe(onNext: { [unowned self] no in
            self.viewModel.model.level = no
            self.changeColor(to: self.viewModel.model.color)
        }).disposed(by: disposeBag)
        
        dateSelected.subscribe(onNext: { [unowned self] dateRegion in
            self.viewModel.model.date = "\(dateRegion.timeIntervalSince1970)"
            self.dateBtn.setTitle(self.viewModel.model.dateStr, for: .normal)
        }).disposed(by: disposeBag)
        
        // isRender
        isRender.map{!$0}.bind(to: mdView.rx.isHidden).disposed(by: disposeBag)
        isRender.bind(to: inputScrollView.rx.isHidden).disposed(by: disposeBag)
        
        // 编辑显示渲染后的 新增显示渲染前
        if viewModel.isEdit {
            dotTapped()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dot = UIBarButtonItem(image: UIImage(systemName: "menucard"), style: .plain, target: self, action: #selector(dotTapped))
        dot.tintColor = TDLColor.iconGray
        
        let save = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(saveTapped))
        save.tintColor = TDLColor.iconGray
        
        navigationItem.rightBarButtonItems = [save, dot]
    }
    
    private func changeColor(to color: UIColor) {
        checkBox.tintColor = color
        dateBtn.tintColor = color
        flagBtn.tintColor = color
    }
    
    @objc func dotTapped() {
        titleTextView.resignFirstResponder()
        textView.resignFirstResponder()
        let titleStr = titleTextView.text == nil ? "" : "### \(titleTextView.text!)\n\n"
        let contentStr = textView.text ?? ""
        mdView.load(markdown: titleStr + contentStr,enableImage: true)
        self.isRender.accept(!self.isRender.value)
    }
    
    @objc func saveTapped() {
        titleTextView.resignFirstResponder()
        textView.resignFirstResponder()
        
        // saveDataToViewModel
        viewModel.model.keyword = titleTextView.text ?? ""
        viewModel.model.content = textView.text
        
        if viewModel.model.keyword.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast(text: "必须输入事项标题").show()
        } else {
            viewModel.commit { [weak self] ok in
                if ok {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    Toast(text: "保存失败").show()
                }
            }
        }
    }
    
    @IBAction func dateBtnTouch(_ sender: UIButton) {
        titleTextView.resignFirstResponder()
        textView.resignFirstResponder()
        
        self.popover = Popover(options: self.popoverOptions)
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 500))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.locale = Locale(identifier: "zh_cn")
        calendar.select(dateSelected.value.date)
        self.popover.show(calendar, fromView: self.dateBtn)
    }
    
    @IBAction func flagBtnTouch(_ sender: UIButton) {
        titleTextView.resignFirstResponder()
        textView.resignFirstResponder()
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 200, height: CGFloat(levels.count) * flagItemHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "FlagItemTableVC", bundle: nil), forCellReuseIdentifier: "flag")
        self.popover = Popover(options: self.popoverOptions)
        fetchEvents {
            self.popover.show(tableView, fromView: self.flagBtn)
        }
    }
}

// MARK: - calendar delegate
extension EditNAddTodoViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func eventsFor(date: Date) -> [EKEvent]? {
        guard let events = events else { return nil }
        let filteredEvents = events.filter { event in
            return event.occurrenceDate.compare(.isSameDay(date))
        }
        return filteredEvents
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let region = DateInRegion(date, region: Region.local)
        debugPrint(region.toFormat("yyyy-MM-dd"))
        dateSelected.accept(region)
        self.popover.dismiss()
    }
    
//    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        let region = DateInRegion(calendar.currentPage, region: Region.local)
//        debugPrint(region.toFormat("yyyy-MM-dd"))
//    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if DateInRegion(date, region: Region.local).isToday {
            return "今"
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if let event = eventsFor(date: date)?.first {
            return event.title
        } else {
            let day = chineseCalendar.component(.day, from: date)
            return lunarChars[day - 1]
        }
    }
}

// MARK: - flag table view
extension EditNAddTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flag", for: indexPath) as! FlagItemTableVC
        cell.setColorFor(level: levels[indexPath.row])
        cell.select(ok: levels[indexPath.row] == flagSelected.value)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flagSelected.accept(levels[indexPath.row])
        self.popover.dismiss()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return flagItemHeight
    }
}
