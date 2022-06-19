//
//  FlagItemTableVC.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/19.
//

import UIKit

class FlagItemTableVC: UITableViewCell {

    @IBOutlet weak var flagBtn: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setColorFor(level: Int) {
        let color: UIColor
        switch level {
        case 1:
            label.text = "低优先级"
            color = TDLColor.lowPriority
        case 2:
            label.text = "中优先级"
            color = TDLColor.middlePriority
        case 3:
            label.text = "高优先级"
            color = TDLColor.highPriority
        default:
            label.text = "无优先级"
            color = TDLColor.nonePriority
        }
        flagBtn.tintColor = color
        label.textColor = color
    }
    
    func select(ok: Bool) {
        selectBtn.isSelected = ok
        if ok {
            selectBtn.tintColor = UIColor("08A4D5")
        } else {
            selectBtn.tintColor = TDLColor.nonePriority
        }
    }
}
