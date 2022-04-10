//
//  HomePageViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/10.
//

import UIKit
import SnapKit

class HomePageViewController: UIViewController {
    
    lazy var searchBar = FakeSearchBar()
    
    lazy var publishBtn: TopImageBtn = {
        let button = TopImageBtn(image: UIImage(systemName: "plus.circle.fill"), text: "发布", color: .white)
        button.addTarget(self, action: #selector(publish), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.fixBarTintColor = UIColor("F3664D")
        
        self.navigationController?.navigationBar.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
            make.left.equalTo(15)
            make.right.equalTo(-50)
        }
        
        self.navigationController?.navigationBar.addSubview(publishBtn)
        publishBtn.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
    }
    
    @objc func publish() {
        print("publish")
    }
}

