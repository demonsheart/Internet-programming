//
//  HomePageSearchTableVC.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/16.
//

import UIKit

class HomePageSearchTableVC: UITableViewCell {
    
    var callBack: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func search(_ sender: UIButton) {
        callBack?()
    }
}
