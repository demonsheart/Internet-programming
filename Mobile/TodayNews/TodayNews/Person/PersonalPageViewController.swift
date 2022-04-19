//
//  PersonalPageViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PersonalPageViewController: TNBaseViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.register(UnLoginTableViewCell.self, forCellReuseIdentifier: "UnLogin")
        table.register(PersonalMessageTableViewCell.self, forCellReuseIdentifier: "Loggined")
        table.separatorStyle = .none
        table.backgroundColor = TNColor.bgGray
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
        super.configAlertForLogout()
        super.configAlertForConnect()
        
        self.navigationController?.navigationBar.fixBarTintColor = TNColor.bgGray
        self.view.backgroundColor = TNColor.bgGray
        settingTopButton()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func settingTopButton() {
        let setting = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingTapped))
        let scan = UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(scanTapped))
        setting.tintColor = TNColor.iconGray
        scan.tintColor = TNColor.iconGray
        
        navigationItem.rightBarButtonItem = setting
        navigationItem.leftBarButtonItem = scan
    }
    
    @objc func settingTapped() {
        let settingVC = SettingViewController()
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func scanTapped() {
        
    }
}

extension PersonalPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if UserConfig.shared.isLogin {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Loggined", for: indexPath) as! PersonalMessageTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UnLogin", for: indexPath) as! UnLoginTableViewCell
                cell.loginCallBack = { [weak self] in
                    self?.jumpToLogin()
                }
                return cell
            }
        }
        
        let cell = UITableViewCell()
        cell.contentView.backgroundColor = TNColor.bgWhite
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if UserConfig.shared.isLogin {
                return 80
            } else {
                return 150
            }
        }
        
        return 60
    }
    
    // MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
