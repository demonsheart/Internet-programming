//
//  HomePageListHeaderView.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/15.
//

import UIKit

class HomePageListHeaderView: UITableViewHeaderFooterView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        contentView.backgroundColor = .lightGray
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
//            make.height.equalTo(40)
        }
    }
}
