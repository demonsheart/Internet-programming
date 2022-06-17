//
//  HomePageTodoVC.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/17.
//

import UIKit
import RxCocoa
import RxSwift

class HomePageTodoVC: UITableViewCell {

    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var disposeBag = DisposeBag()
    let checkRelay = BehaviorRelay(value: false)
    var color = UIColor.lightGray
    
    var checkCallBack: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.checkBox.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.checkBox.isSelected.toggle()
                self.checkRelay.accept(self.checkBox.isSelected)
            }).disposed(by: disposeBag)
        
        checkRelay.subscribe(onNext: { [unowned self] check in
            if check {
                self.checkBox.tintColor = .lightGray
            } else {
                self.checkBox.tintColor = self.color
            }
        }).disposed(by: disposeBag)
    }
    
    func render(todo: ToDoModel) {
        checkBox.isSelected = todo.done
        color = todo.color
        checkRelay.accept(todo.done)
        titleLabel.text = todo.keyword
        timeLabel.text = todo.dateTuple.0
        timeLabel.textColor = todo.dateTuple.1
    }
    
}
