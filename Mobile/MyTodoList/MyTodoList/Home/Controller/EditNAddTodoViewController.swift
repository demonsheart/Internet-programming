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

class EditNAddTodoViewController: BaseViewController {
    
    var model: ToDoModel!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var flagBtn: UIButton!
    @IBOutlet weak var textView: UITextView! // markdown 文本
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerWidth.constant = UIScreen.main.bounds.width - 20
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dot = UIBarButtonItem(image: UIImage(systemName: "dots.and.line.vertical.and.cursorarrow.rectangle"), style: .plain, target: self, action: #selector(dotTapped))
        dot.tintColor = TDLColor.iconGray
        
        navigationItem.rightBarButtonItems = [dot]
    }
    
    @objc func dotTapped() {
        
    }

}
