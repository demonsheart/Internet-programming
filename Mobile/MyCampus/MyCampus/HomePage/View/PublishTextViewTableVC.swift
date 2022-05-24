//
//  PublishTextViewTableVC.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/24.
//

import UIKit
import IQKeyboardManagerSwift

class PublishTextViewTableVC: UITableViewCell {

    @IBOutlet weak var textView: IQTextView!
    
    var callBack: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = CPColor.bgGray
    }
    
    @IBAction func remove(_ sender: UIButton) {
        callBack?()
    }
    
}
