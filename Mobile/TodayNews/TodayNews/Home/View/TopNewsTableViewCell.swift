//
//  TopNewsTableViewCell.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/11.
//

import UIKit

class TopNewsTableViewCell: UITableViewCell {

    var data: TopNewsModel? {
        didSet {
            guard let data = data else { return }
            titleLabel.text = data.title
            sourceLabel.text = data.source
            commentNumLabel.text = "\(data.commentNum)评论"
            resetUI()
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
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = TNColor.red
        label.text = "置顶"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 11)
        return label
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(topLabel)
        self.contentView.addSubview(sourceLabel)
        self.contentView.addSubview(commentNumLabel)
        
        setDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetUI() {
        guard let data = data else {
            return
        }
        
        if data.isTop {
            setDefaultUI()
        } else {
            setOtherUI()
        }
        
    }
    
    // 含top
    private func setDefaultUI() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        topLabel.isHidden = false
        topLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview()
            make.left.equalTo(10)
        }
        
        sourceLabel.snp.remakeConstraints { make in
            make.top.bottom.equalTo(topLabel)
            make.left.equalTo(topLabel.snp.right).offset(3)
        }
        
        commentNumLabel.snp.remakeConstraints { make in
            make.top.bottom.equalTo(topLabel)
            make.left.equalTo(sourceLabel.snp.right).offset(3)
        }
    }
    
    // 不含top
    private func setOtherUI() {
        topLabel.isHidden = true
        
        sourceLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.left.equalTo(10)
        }
        
        commentNumLabel.snp.remakeConstraints { make in
            make.top.bottom.equalTo(sourceLabel)
            make.left.equalTo(sourceLabel.snp.right).offset(3)
        }
    }
    
}
