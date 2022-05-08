//
//  PersonalPageViewController.swift
//  MyTodoList
//
//  Created by aicoin on 2022/5/7.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SDWebImage

class PersonalPageViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.delegate = self
        table.dataSource = self
        table.register(AvatarTableViewCell.self, forCellReuseIdentifier: "Avatar")
        table.register(UINib(nibName: "CommonTableViewCell", bundle: nil), forCellReuseIdentifier: "Common")
        table.separatorStyle = .none
        table.backgroundColor = TDLColor.bgGreen
        table.allowsSelection = false
        
        UserDefaults.standard.rx.observe(Bool.self, "LoginState")
            .skip(1)
            .subscribe(onNext: { [weak table] _ in
                table?.reloadData()
            })
            .disposed(by: disposeBag)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TDLColor.bgGreen
        self.navigationController?.navigationBar.fixBarTintColor = TDLColor.bgGreen
        self.title = "个人"
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }

    // MARK: 修复uitableviewwrapperview 导致的偏移 观察得到值35
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let inset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
    }
    
}

extension PersonalPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return CommonTableViewCell.CommonCellType.allCases.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Avatar", for: indexPath) as! AvatarTableViewCell
            cell.tapCallBack = {
                // TODO: 未登录则登录 已登陆则跳转详情
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Common", for: indexPath) as! CommonTableViewCell
            cell.type = CommonTableViewCell.CommonCellType.allCases[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }
        return 50
    }
    
    // MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return .leastNonzeroMagnitude
        } else if section == 1 {
            return 50
        } else {
            return 20
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}
