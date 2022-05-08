//
//  CommonTableViewCell.swift
//  MyTodoList
//
//  Created by aicoin on 2022/5/8.
//

import UIKit

class CommonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    enum CommonCellType: String, CaseIterable {
        case 今日复盘 = "今日复盘"
        case 统计 = "统计"
        case 更多设置 = "更多设置"
        case 分享 = "分享给好友"
        case 关于 = "关于"
    }
    
    var type: CommonCellType = .关于 {
        didSet {
            configUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configUI() {
        title.text = type.rawValue
        switch type {
        case .今日复盘:
            icon.image = UIImage(systemName: "rectangle.and.text.magnifyingglass")
        case .统计:
            icon.image = UIImage(systemName: "align.horizontal.left")
        case .更多设置:
            icon.image = UIImage(systemName: "gearshape")
        case .分享:
            icon.image = UIImage(systemName: "arrow.up.forward.app")
        case .关于:
            icon.image = UIImage(systemName: "exclamationmark.circle")
        }
    }
    
}
