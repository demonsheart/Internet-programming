//
//  UnLoginTableViewCell.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/17.
//

import UIKit

class UnLoginTableViewCell: UITableViewCell {
    
    var loginCallBack: (() -> Void)?
    
    lazy var imgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "login"))
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(login))
        ges.numberOfTapsRequired = 1
        view.addGestureRecognizer(ges)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TNColor.bgGray
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
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
    
    @objc func login() {
        loginCallBack?()
    }

}
