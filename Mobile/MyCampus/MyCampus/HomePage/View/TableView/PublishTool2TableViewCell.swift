//
//  PublishTool2TableViewCell.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/31.
//

import UIKit

class PublishTool2TableViewCell: UITableViewCell {
    
    var callBack: ((Int) -> Void)? // 0 -> audio; 1 -> video
    
    @IBAction func addAudio(_ sender: UIButton) {
        callBack?(0)
    }
    
    @IBAction func addVideo(_ sender: UIButton) {
        callBack?(1)
    }
}
