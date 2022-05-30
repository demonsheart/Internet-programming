//
//  PublishBtnTableVC.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/24.
//

import UIKit

class PublishBtnTableVC: UITableViewCell {
    
    var callBack: (() -> Void)?
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = CPColor.bgGray
//        self.btn.tintColor = UIColor( "262626")
    }
    
    @IBAction func publish(_ sender: UIButton) {
        callBack?()
    }
}
