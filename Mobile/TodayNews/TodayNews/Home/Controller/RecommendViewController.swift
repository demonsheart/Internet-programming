//
//  RecommendViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/10.
//

import UIKit
import SnapKit
import MJRefresh

class RecommendViewController: UIViewController {
    
    var topNews = TopNewsModel.default
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.register(TopNewsTableViewCell.self, forCellReuseIdentifier: "TopNews")
        table.register(BigPicNewsTableViewCell.self, forCellReuseIdentifier: "BigPicNews")
        table.register(ThreePicNewsTableViewCell.self, forCellReuseIdentifier: "ThreePicNews")
        table.register(RightPicNewsTableViewCell.self, forCellReuseIdentifier: "RightPicNews")
        table.separatorStyle = .none
        table.separatorInset = .init(top: 0, left: 10.xZoom, bottom: 0, right: 10.xZoom)
        table.backgroundColor = .white
        table.rowHeight = UITableView.automaticDimension
        
        MJRefreshConfig.default.languageCode = "zh-Hans"
        table.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            sleep(1)
            // TODO: request data
            table.reloadData()
            table.mj_header?.endRefreshing()
        })
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RecommendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return topNews.count
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TopNews", for: indexPath) as! TopNewsTableViewCell
                cell.data = topNews[indexPath.row]
                return cell
            case 1:
                return UITableViewCell()
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
    }
    
}
