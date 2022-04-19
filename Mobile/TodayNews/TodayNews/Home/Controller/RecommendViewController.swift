//
//  RecommendViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/10.
//

import UIKit
import SnapKit
import MJRefresh

class RecommendViewController: TNBaseViewController {
    
    let model = RecommendViewModel()
    
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
        table.estimatedRowHeight = 80
        
        MJRefreshConfig.default.languageCode = "zh-Hans"
        table.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            sleep(1)
            // TODO: request data
            self?.model.changeData()
            table.reloadData()
            table.mj_header?.endRefreshing()
        })
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        super.configAlertForConnect()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func reconnectAction() {
        self.tableView.mj_header?.beginRefreshing()
    }
}

extension RecommendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return model.topNews.count
        case 1:
            return model.bigNews.count + model.threesPicNews.count + model.rightPicNews.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TopNews", for: indexPath) as! TopNewsTableViewCell
//                cell.selectionStyle = .none
                cell.data = model.topNews[indexPath.row]
                return cell
            case 1:
                if let data = model.getData(index: indexPath.row) as? BigPicNewsModel {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BigPicNews", for: indexPath) as! BigPicNewsTableViewCell
//                    cell.selectionStyle = .none
                    cell.data = data
                    return cell
                }
                
                if let data = model.getData(index: indexPath.row) as? ThreePicNewsModel {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ThreePicNews", for: indexPath) as! ThreePicNewsTableViewCell
//                    cell.selectionStyle = .none
                    cell.data = data
                    return cell
                }
                
                if let data = model.getData(index: indexPath.row) as? RightPicNewsModel {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RightPicNews", for: indexPath) as! RightPicNewsTableViewCell
//                    cell.selectionStyle = .none
                    cell.data = data
                    return cell
                }
                
                return UITableViewCell()
                
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath)
        
        let detail = NewsDetailViewController()
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    // MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = SeparateView()
        return view
    }
    
}

extension RecommendViewController {
    class SeparateView: UIView {
        let line = UIView()
        
        init(){
            super.init(frame: .zero)
            self.backgroundColor = .white
            self.addSubview(line)
            line.backgroundColor = .lightGray
            line.snp.makeConstraints { make in
                make.centerY.equalToSuperview().offset(5)
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(0.35)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
