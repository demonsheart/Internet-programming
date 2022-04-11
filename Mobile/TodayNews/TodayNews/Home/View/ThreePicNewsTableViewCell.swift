//
//  ThreePicNewsTableViewCell.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/11.
//

import UIKit

class ThreePicNewsTableViewCell: UITableViewCell {
    
    var data: ThreePicNewsModel? {
        didSet {
            guard let data = data else { return }
            titleLabel.text = data.title
            sourceLabel.text = data.source
            commentNumLabel.text = "\(data.commentNum)评论"
            timeLabel.text = data.time
            
            if imgContainer.imgViews.count <= data.picURLs.count {
                for i in 0..<imgContainer.imgViews.count {
                    imgContainer.imgViews[i].sd_setImage(with: URL(string: data.picURLs[i]), placeholderImage: UIImage(named: "photo"))
                }
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var imgContainer = PicViewContainer()
    
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    lazy var commentNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 11)
        return label
    }()
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        self.contentView.addSubview(imgContainer)
        imgContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(88)
        }
        
        self.contentView.addSubview(sourceLabel)
        sourceLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(imgContainer.snp.bottom).offset(3)
        }
        
        self.contentView.addSubview(commentNumLabel)
        commentNumLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceLabel)
            make.left.equalTo(sourceLabel.snp.right).offset(3)
        }
        
        self.contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(commentNumLabel)
            make.left.equalTo(commentNumLabel.snp.right).offset(3)
        }
        
        self.contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(sourceLabel.snp.bottom).offset(10)
            make.height.equalTo(0.35)
            make.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ThreePicNewsTableViewCell {
    /// 水平平均分布
    class PicViewContainer: UIView {
        let imgViews: [UIImageView] = [UIImageView(), UIImageView(), UIImageView()]
        
        init() {
            super.init(frame: .zero)
            imgViews.forEach { view in
                view.contentMode = .scaleToFill
                view.backgroundColor = .lightGray
                self.addSubview(view)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let size = self.frame.size
            let spacing: CGFloat = 3
            let picWidth: CGFloat = (size.width - spacing * CGFloat(imgViews.count - 1)) / CGFloat(imgViews.count)
            
            for i in 0..<imgViews.count {
                imgViews[i].snp.remakeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(picWidth)
                    make.left.equalTo(CGFloat(i) * (picWidth + spacing))
                }
            }
            
        }
        
    }
}
