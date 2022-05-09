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
        table.register(QuitLoginTableViewCell.self, forCellReuseIdentifier: "Quit")
        table.register(UINib(nibName: "CommonTableViewCell", bundle: nil), forCellReuseIdentifier: "Common")
        table.separatorStyle = .none
        table.backgroundColor = TDLColor.bgGreen
        
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
        if UserConfig.shared.isLogin {
            return 3
        } else {
            return 2
        }
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
            cell.tapCallBack = { [weak self] in
                // TODO: 未登录则登录 已登陆则跳转详情
                if !UserConfig.shared.isLogin {
                    self?.present(LoginViewController(), animated: true)
                } else {
                    
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Common", for: indexPath) as! CommonTableViewCell
            cell.type = CommonTableViewCell.CommonCellType.allCases[indexPath.row]
            return cell
        } else if indexPath.section == 2 {
            // 退出登录按钮
            let cell = tableView.dequeueReusableCell(withIdentifier: "Quit", for: indexPath) as! QuitLoginTableViewCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? CommonTableViewCell {
            // TODO: 跳转相应的page
            print(cell.type.rawValue)
        }
        
        if let _ = tableView.cellForRow(at: indexPath) as? QuitLoginTableViewCell {
            UserConfig.shared.logout { ok in
                if ok { tableView.reloadData() }
            }
        }
    }
    
    // MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return .leastNonzeroMagnitude
        } else if section == 1 {
            return 100
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}

extension PersonalPageViewController {
    class QuitLoginTableViewCell: UITableViewCell {
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 15)
            label.textColor = UIColor(named: "textRed")
            label.text = "退出登录"
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
