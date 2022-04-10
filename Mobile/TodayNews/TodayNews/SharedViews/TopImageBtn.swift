//
//  TopImageBtn.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/10.
//

import UIKit

class TopImageBtn: UIControl {
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init(image: UIImage?, text: String, color: UIColor) {
        super.init(frame: .zero)
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
        label.text = text
        label.textColor = color
        
        self.addSubview(imageView)
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = self.frame.size
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(size.height * 0.3)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.width.equalTo(size.height * 0.65)
        }
    }
}
