//
//  BaseCollectionViewCell.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import UIKit

class MomentCollectionViewCell: UICollectionViewCell {
    
    // MomentsModel
    var model: MomentsModel?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.contentView.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
