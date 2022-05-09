//
//  AvatarTableViewCell.swift
//  MyTodoList
//
//  Created by aicoin on 2022/5/7.
//

import UIKit
import RxSwift
import RxCocoa

class AvatarTableViewCell: UITableViewCell {
    
    // 未登录则登录 已登陆则跳转详情
    var tapCallBack: (() -> Void)?
    
    var disposeBag = DisposeBag()
    
    lazy var imgView: UIImageView = {
        let view = UIImageView()
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
        
        UserDefaults.standard.rx.observe(Bool.self, "LoginState")
            .subscribe(onNext: { [weak self] ok in
                self?.updateUserMess(ok ?? false)
            })
            .disposed(by: disposeBag)
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
        tapCallBack?()
    }
    
    func updateUserMess(_ ok: Bool) {
        if ok {
            Service.shared.getUserMess { [weak self] success in
                if success {
                    self?.imgView.sd_setImage(with: URL(string: UserConfig.shared.avatar), placeholderImage: UIImage(named: "default_avatar"))
                    self?.nameLabel.text = UserConfig.shared.nick
                }
            }
        } else {
            imgView.image = UIImage(named: "default_avatar")
            nameLabel.text = "请登录"
        }
    }
    
}
