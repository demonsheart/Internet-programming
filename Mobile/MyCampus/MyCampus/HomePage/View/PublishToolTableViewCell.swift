//
//  PublishToolTableViewCell.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/24.
//

import UIKit

class PublishToolTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var callBack: ((Int) -> Void)?
    
    @IBAction func addText(_ sender: UIButton) {
        callBack?(0)
    }
    
    @IBAction func addPic(_ sender: UIButton) {
        callBack?(1)
    }
    
    @IBAction func addLoc(_ sender: UIButton) {
        callBack?(2)
    }
}
