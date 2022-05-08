//
//  AvatarTableViewCell.swift
//  MyTodoList
//
//  Created by aicoin on 2022/5/7.
//

import UIKit

class AvatarTableViewCell: UITableViewCell {
    
    // 未登录则登录 已登陆则跳转详情
    var tapCallBack: (() -> Void)?
    
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "default_avatar"))
//        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(tapAvatar))
        ges.numberOfTapsRequired = 1
        view.addGestureRecognizer(ges)
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16)
        label.text = "登录"
        
        label.isUserInteractionEnabled = true
        let ges = UITapGestureRecognizer(target: self, action: #selector(tapAvatar))
        ges.numberOfTapsRequired = 1
        label.addGestureRecognizer(ges)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TDLColor.bgGreen
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.height.width.equalTo(100)
        }
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imgSize = imgView.frame.size
        imgView.layer.masksToBounds = false
        imgView.layer.cornerRadius = imgSize.height / 2
        imgView.clipsToBounds = true
    }
    
    @objc func tapAvatar() {
        print("djsk")
        tapCallBack?()
    }

}
