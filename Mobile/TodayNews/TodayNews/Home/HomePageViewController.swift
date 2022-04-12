//
//  HomePageViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/10.
//

import UIKit
import SnapKit
import WMPageController
import RTRootNavigationController

class HomePageViewController: UIViewController {
    
    lazy var searchBar = FakeSearchBar()
    
    lazy var publishBtn: TopImageBtn = {
        let button = TopImageBtn(image: UIImage(systemName: "plus.circle.fill"), text: "发布", color: .white)
        button.addTarget(self, action: #selector(publish), for: .touchUpInside)
        return button
    }()
    
    lazy var settingMenuBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.justify")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(settingMenu), for: .touchUpInside)
        return button
    }()
    
    let data = WMpageDataModel.default
    
    lazy var pagesVC: WMPageController = {
        let pages = WMPageController()
        pages.titles = data.map{ $0.title }
        pages.viewControllerClasses = data.map { $0.controllerForCoder }
        pages.itemsWidths = data.map{ NSNumber(value: Float(($0.title.width(withConstrainedHeight: 30, font: UIFont.systemFont(ofSize: 15))))) }
        var itemsMargins: [NSNumber] = []
        for i in 0...data.count {
            if i == 0 {
                itemsMargins.append(NSNumber(value: 10))
            } else if i < data.count {
                itemsMargins.append(NSNumber(value: 20))
            } else {
                itemsMargins.append(NSNumber(value: 50)) // menu控制按钮所在区域
            }
        }
        pages.itemsMargins = itemsMargins
        pages.titleSizeNormal = 15
        pages.titleSizeSelected = 15
        pages.menuViewStyle = .line
        pages.titleColorSelected = TNColor.red
        pages.dataSource = self
        pages.delegate = self
        pages.selectIndex = 1
        
        return pages
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.fixBarTintColor = TNColor.red
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
        
        self.addChild(pagesVC)
        self.view.addSubview(pagesVC.view)
        pagesVC.didMove(toParent: self)
        pagesVC.view.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        guard let menu = pagesVC.menuView else { return }
        
        self.view.addSubview(settingMenuBtn)
        settingMenuBtn.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(40)
            make.right.equalToSuperview()
            make.centerY.equalTo(menu.snp.centerY)
        }
        
        let line = UIView()
        line.backgroundColor = .lightGray
        self.view.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.3)
            make.top.equalTo(menu.snp.bottom)
        }
    }
    
    @objc func publish() {
        print("publish")
    }
    
    @objc func settingMenu() {
        print("settingMenu")
    }
}

extension HomePageViewController: WMPageControllerDelegate, WMPageControllerDataSource {
    func pageController(_ pageController: WMPageController, didEnter viewController: UIViewController, withInfo info: [AnyHashable : Any]) {
        
    }
}
