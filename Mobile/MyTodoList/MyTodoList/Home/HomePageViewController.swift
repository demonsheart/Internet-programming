//
//  HomePageViewController.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/15.
//

import UIKit

class HomePageViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = TDLColor.bgGreen
        
        table.register(HomePageListHeaderView.self,
               forHeaderFooterViewReuseIdentifier: "listHeader")
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = TDLColor.bgGreen
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let operations = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(operationTapped))
        let board = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(boardTapped))
        operations.tintColor = TDLColor.iconGray
        board.tintColor = TDLColor.iconGray
        
        navigationItem.rightBarButtonItems = [operations]
        navigationItem.leftBarButtonItems = [board]
    }
    
    @objc func operationTapped() {
        
    }
    
    @objc func boardTapped() {
        
    }

}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - Header
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:"listHeader") as! HomePageListHeaderView
        view.label.text = "Header"
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return CGFloat.leastNonzeroMagnitude }
        return 40
    }
    
    // MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
}
