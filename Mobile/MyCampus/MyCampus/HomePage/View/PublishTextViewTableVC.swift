//
//  PublishTextViewTableVC.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/24.
//

import UIKit
import IQKeyboardManagerSwift

class PublishTextViewTableVC: UITableViewCell, SaveBeforeReuse {
    var saveCallBack: ((String) -> Void)?
    
    var deleteCallBack: (() -> Void)?
    
    @IBOutlet weak var textView: IQTextView!
    
    override func prepareForReuse() {
        saveCallBack?(textView.text ?? "")
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = CPColor.bgGray
    }
    
    @IBAction func remove(_ sender: UIButton) {
        deleteCallBack?()
    }
    
}
