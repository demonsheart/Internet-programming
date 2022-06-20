//
//  TodoCalendarCell.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/20.
//

import UIKit
import FSCalendar

class TodoCalendarCell: FSCalendarCell {
    
    let todoLabel1 = UILabel()
    let todoLabel2 = UILabel()
    let todoLabel3 = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = TDLColor.selectedDate
            } else {
                self.contentView.backgroundColor = .clear
            }
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(todoLabel1)
        self.addSubview(todoLabel2)
        self.addSubview(todoLabel3)
        
        setLabelAttr(label: todoLabel1)
        setLabelAttr(label: todoLabel2)
        setLabelAttr(label: todoLabel3)
    }
    
    private func setLabelAttr(label: UILabel) {
        label.isHidden = true
        label.layer.backgroundColor = TDLColor.undoCell.cgColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 9)
        label.layer.cornerRadius = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.contentView.frame.size
        let titleHeight = size.height/3
        titleLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: titleHeight)
        shapeLayer.frame = CGRect(x: (size.width - titleHeight)/2, y: 0, width: titleHeight, height: titleHeight)
        let path = UIBezierPath(roundedRect: shapeLayer.bounds, cornerRadius: shapeLayer.bounds.width*0.5)
        shapeLayer.path = path.cgPath
        
        let space: CGFloat = 3
        let todoHeight = (size.height - titleHeight)/3
        var startY = titleLabel.frame.maxY
        startY += space
        todoLabel1.frame = CGRect(x: 5, y: startY, width: size.width - 10, height: todoHeight - space)
        startY += todoHeight
        todoLabel2.frame = CGRect(x: 5, y: startY, width: size.width - 10, height: todoHeight - space)
        startY += todoHeight
        todoLabel3.frame = CGRect(x: 5, y: startY, width: size.width - 10, height: todoHeight - space)
    }
    
    override func performSelecting() {
        super.performSelecting()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideAllLabel()
    }
    
    func hideAllLabel() {
        todoLabel1.isHidden = true
        todoLabel2.isHidden = true
        todoLabel3.isHidden = true
    }
    
    func setTodos(todos: [ToDoModel]?) {
        if let todos = todos {
            let count = todos.count
            if count >= 1 {
                todoLabel1.isHidden = false
                let todo = todos[0]
                todoLabel1.text = todo.keyword
                todoLabel1.layer.backgroundColor = todo.done ? TDLColor.doneCell.cgColor : TDLColor.undoCell.cgColor
                todoLabel1.textColor = todo.done ? TDLColor.nonePriority : .darkText
            }
            if count >= 2 {
                todoLabel2.isHidden = false
                let todo = todos[1]
                todoLabel2.text = todo.keyword
                todoLabel2.layer.backgroundColor = todo.done ? TDLColor.doneCell.cgColor : TDLColor.undoCell.cgColor
                todoLabel2.textColor = todo.done ? TDLColor.nonePriority : .darkText
            }
            if count >= 3 {
                todoLabel3.isHidden = false
                let todo = todos[2]
                todoLabel3.text = todo.keyword
                todoLabel3.layer.backgroundColor = todo.done ? TDLColor.doneCell.cgColor : TDLColor.undoCell.cgColor
                todoLabel3.textColor = todo.done ? TDLColor.nonePriority : .darkText
            }
        }
    }
    
}
