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
    
    let viewModel = EditNAddTodoViewModel()
    
    // popover
    fileprivate var levels = [3, 2, 1, 0]
    fileprivate var flagItemHeight: CGFloat = 45
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
      .type(.down),
      .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    convenience init(model: ToDoModel? = nil) {
        self.init(nibName: nil, bundle: nil)
        if let model = model {
            viewModel.model = model
            viewModel.isEdit = true
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
        dateBtn.setTitle(viewModel.model.dateStr, for: .normal)
        changeColor(to: viewModel.model.color)
        
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
                self.checkBox.tintColor = TDLColor.nonePriority
            } else {
                self.checkBox.tintColor = self.viewModel.model.color
            }
        }).disposed(by: disposeBag)
        
        flagSelected.subscribe(onNext: { [unowned self] no in
            self.viewModel.model.level = no
            self.changeColor(to: self.viewModel.model.color)
        }).disposed(by: disposeBag)
        
        // isRender
        isRender.map{!$0}.bind(to: mdView.rx.isHidden).disposed(by: disposeBag)
        isRender.bind(to: inputScrollView.rx.isHidden).disposed(by: disposeBag)
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
        // TODO: validate && save
        
        // saveDataToViewModel
        viewModel.model.keyword = titleTextView.text ?? ""
        viewModel.model.content = textView.text
        // level & date
    }
    
    @IBAction func dateBtnTouch(_ sender: UIButton) {
        titleTextView.resignFirstResponder()
        textView.resignFirstResponder()
        
        self.popover = Popover(options: self.popoverOptions)
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 500))
        calendar.dataSource = self
        calendar.delegate = self
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
        self.popover.show(tableView, fromView: self.flagBtn)
    }
}

// MARK: - calendar delegate
extension EditNAddTodoViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // TODO: 自定义
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
