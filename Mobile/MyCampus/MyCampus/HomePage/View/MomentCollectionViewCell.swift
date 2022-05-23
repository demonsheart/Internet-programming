//
//  BaseCollectionViewCell.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import UIKit
import SDWebImage
import SnapKit
import AVFoundation

class MomentCollectionViewCell: UICollectionViewCell {
    
    // MomentsModel
    var model: MomentsModel? {
        didSet {
            guard let model = model else {
                return
            }
            resetUI(model: model)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var timeLocationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    lazy var userView = UserView()
    
    // image
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 6
        self.contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetUI(model: MomentsModel) {
        self.contentView.subviews.forEach{ $0.removeFromSuperview() }
        let margin: CGFloat = 8
        // 自底向上布局 timeLocationLabel userView titleLabel
        self.contentView.addSubview(timeLocationLabel)
        timeLocationLabel.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(-margin)
            make.height.equalTo(15)
        }
        
        if let location = model.location {
            timeLocationLabel.text = location + " " + model.formattedTimeStr
        } else {
            timeLocationLabel.text = model.formattedTimeStr
        }
        
        self.contentView.addSubview(userView)
        userView.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(40)
            make.bottom.equalTo(timeLocationLabel.snp.top).offset(-margin)
        }
//        userView.avatarView.sd_setImage(with: URL(string: model.owner.avatar), placeholderImage: UIImage(named: "person.crop.circle"))
        userView.avatarView.sd_setImage(with: URL(string: "https://p3-sign.toutiaoimg.com/pgc-image/21507a12df2c4e7eb2d859c6f32dd497~tplv-tt-large.image?x-expires=1965128203&x-signature=RgTmiaTxyrICK4%2B%2B1xB4esDHb7U%3D"), placeholderImage: UIImage(named: "person.crop.circle"))
        userView.sourceLabel.text = model.owner.nick
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.bottom.equalTo(userView.snp.top).offset(-margin)
        }
        titleLabel.text = model.title
        
        // 分情况布局剩下的view
        if model.modelType == 1 { // image
            self.contentView.addSubview(imgView)
            imgView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(titleLabel.snp.top).offset(-margin)
            }
            imgView.sd_setImage(with: URL(string: "https://img2.baidu.com/it/u=1497164695,4188964579&fm=253&fmt=auto&app=138&f=JPEG?w=888&h=500"))
            
        } else if model.modelType == 2 { // video
            self.contentView.addSubview(imgView)
            imgView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(130)
                make.bottom.equalTo(titleLabel.snp.top).offset(-margin)
            }
            imgView.image = UIImage(systemName: "video")
        }
    }
}

extension MomentCollectionViewCell {
    // 40 height
    class UserView: UIView {
        
        lazy var avatarView = UIImageView()
        
        lazy var sourceLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 13)
            label.textAlignment = .left
            return label
        }()
        
        lazy var sourceInfoLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 12)
            label.textColor = .lightGray
            label.textAlignment = .left
            return label
        }()
        
        init() {
            super.init(frame: .zero)
            
            self.addSubview(avatarView)
            avatarView.contentMode = .scaleToFill
            avatarView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(25)
                make.left.equalTo(10)
            }
            
            self.addSubview(sourceLabel)
            sourceLabel.snp.makeConstraints { make in
                make.bottom.equalTo(self.snp.centerY)
                make.left.equalTo(avatarView.snp.right).offset(20)
            }
            
            self.addSubview(sourceInfoLabel)
            sourceInfoLabel.snp.makeConstraints { make in
                make.top.equalTo(self.snp.centerY)
                make.left.equalTo(sourceLabel)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
}
