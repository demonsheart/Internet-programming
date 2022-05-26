//
//  PublishImageTableViewCell.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/26.
//

import UIKit

class PublishImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    var deleteCallBack: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.backgroundColor = CPColor.bgGray
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        deleteCallBack?()
    }
}

