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
        self.textView.delegate = self
    }
    
    @IBAction func remove(_ sender: UIButton) {
        deleteCallBack?()
    }
    
}

extension PublishTextViewTableVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
