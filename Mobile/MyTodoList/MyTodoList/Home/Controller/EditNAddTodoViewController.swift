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
    
    let viewModel = EditNAddTodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerWidth.constant = UIScreen.main.bounds.width - 20
        self.view.backgroundColor = .white
        
        // textview
        titleTextView.text = nil
        textView.text = nil
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
                self.checkBox.tintColor = .lightGray
            } else {
                self.checkBox.tintColor = self.viewModel.model.color
            }
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
        
    }
    
}
