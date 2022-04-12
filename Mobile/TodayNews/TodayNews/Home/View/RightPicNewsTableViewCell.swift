//
//  RightPicNewsTableViewCell.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/11.
//

import UIKit

class RightPicNewsTableViewCell: UITableViewCell {
    var data: RightPicNewsModel? {
        didSet {
            guard let data = data else { return }
            titleLabel.text = data.title
            imgView.sd_setImage(with: URL(string: data.picURL), placeholderImage: UIImage(named: "photo"))
            sourceLabel.text = data.source
            commentNumLabel.text = "\(data.commentNum)评论"
            timeLabel.text = data.time
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byCharWrapping
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
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
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-140)
        }
        
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(120)
            make.height.equalTo(88)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.contentView.addSubview(sourceLabel)
        sourceLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.bottom.equalTo(imgView)
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
            make.height.equalTo(0.35)
            make.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
