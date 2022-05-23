//
//  HomePageViewController.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import UIKit
import SnapKit
import WMPageController

class HomePageViewController: UIViewController {
    
    lazy var publishBtn: TopImageBtn = {
        let button = TopImageBtn(image: UIImage(systemName: "plus.circle.fill"), text: "发布", color: .white)
        button.addTarget(self, action: #selector(publish), for: .touchUpInside)
        return button
    }()
    
    lazy var searchIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        return view
    }()
    
    let wmModel = WMpageDataModel.default
    
    lazy var pagesVC: WMPageController = {
        let pages = WMPageController()
        pages.titles = wmModel.map{ $0.title }
        pages.viewControllerClasses = wmModel.map { $0.controllerForCoder }
        pages.itemsWidths = wmModel.map{ NSNumber(value: Float(($0.title.width(withConstrainedHeight: 35, font: UIFont.systemFont(ofSize: 20))))) }
        var itemsMargins: [NSNumber] = []
        for i in 0...wmModel.count {
            if i == 0 {
                itemsMargins.append(NSNumber(value: 10))
            } else if i < wmModel.count {
                itemsMargins.append(NSNumber(value: 20))
            } else {
//                itemsMargins.append(NSNumber(value: 50)) // menu控制按钮所在区域
            }
        }
        pages.itemsMargins = itemsMargins
        pages.titleSizeNormal = 18
        pages.titleSizeSelected = 20
        pages.menuViewStyle = .line
        pages.titleColorSelected = CPColor.red
        pages.dataSource = self
        pages.delegate = self
        pages.selectIndex = 0
        
        return pages
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "帖子"
        self.navigationController?.navigationBar.fixBarTintColor = CPColor.red

        self.navigationController?.navigationBar.addSubview(publishBtn)
        publishBtn.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
        
        self.navigationController?.navigationBar.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        self.addChild(pagesVC)
        self.view.addSubview(pagesVC.view)
        pagesVC.didMove(toParent: self)
        pagesVC.view.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
    }
    
    @objc func publish() {
        print("publish")
    }
}

extension HomePageViewController: WMPageControllerDelegate, WMPageControllerDataSource {
    func pageController(_ pageController: WMPageController, didEnter viewController: UIViewController, withInfo info: [AnyHashable : Any]) {
        
    }
}
