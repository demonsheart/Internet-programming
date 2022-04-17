//
//  SettingViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/17.
//

import UIKit

class SettingViewController: TNBaseViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.separatorStyle = .none
        table.backgroundColor = TNColor.bgGray
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TNColor.bgGray
        self.title = "设置"
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserConfig.shared.isLogin {
            return 1
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let label = cell.textLabel {
            label.text = "退出登录"
            label.textAlignment = .center
            label.textColor = .red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UserConfig.shared.logout { [weak self] isLogout in
            if isLogout {
                self?.navigationController?.popViewController(animated: true)
            } else {
                //
            }
        }
        
    }
    
}
