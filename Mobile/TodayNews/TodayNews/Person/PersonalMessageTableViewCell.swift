//
//  PersonalMessageTableViewCell.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/17.
//

import UIKit
import SDWebImage

class PersonalMessageTableViewCell: UITableViewCell {
    
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "皮卡丘")
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "皮卡丘"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var enterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "个人主页 >"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        
        label.isUserInteractionEnabled = true
        let ges = UITapGestureRecognizer(target: self, action: #selector(enterPersonView))
        ges.numberOfTapsRequired = 1
        label.addGestureRecognizer(ges)
        
        return label
    }()
    
    @objc func enterPersonView() {
        print("enterPersonView")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.height.equalTo(70)
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imgView.snp.right).offset(10)
        }
        
        self.contentView.addSubview(enterLabel)
        enterLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgView.layer.borderWidth = 0.5
        imgView.layer.masksToBounds = false
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
        imgView.clipsToBounds = true
    }
    
}

extension PersonalMessageTableViewCell {
    // 数字 + 描述
    class MessageUnitView: UIView {
        lazy var numberLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 1
            label.font = .boldSystemFont(ofSize: 12)
            return label
        }()
        
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 12)
            label.textColor = .gray
            return label
        }()
        
        init() {
            super.init(frame: .zero)
            self.addSubview(numberLabel)
            self.addSubview(titleLabel)
            
            numberLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(2)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(numberLabel.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
