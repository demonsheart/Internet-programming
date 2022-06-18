//
//  HomePageViewController.swift
//  MyTodoList
//
//  Created by aicoin on 2022/6/15.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift
import RxRelay

class HomePageViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = TDLColor.bgGreen
        tableView.separatorStyle = .none
        if #available(iOS 15.0, *) {
            tableView.isPrefetchingEnabled = false
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.register(UINib(nibName: "HomePageSearchTableVC", bundle: nil), forCellReuseIdentifier: "search")
        tableView.register(UINib(nibName: "HomePageTodoVC", bundle: nil), forCellReuseIdentifier: "todo")
        
        return tableView
    }()
    
    let viewModel = HomePageListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = TDLColor.bgGreen
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        let dataSource = RxTableViewSectionedReloadDataSource
        <SectionOfHPCellData>(configureCell: {
            (dataSource, tv, indexPath, element) in
            switch element {
            case .search:
                let cell = tv.dequeueReusableCell(withIdentifier: "search", for: indexPath) as! HomePageSearchTableVC
                cell.selectionStyle = .none
                cell.callBack = { [weak self] in
                    self?.search()
                }
                return cell
            case .list(let model):
                let cell = tv.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! HomePageTodoVC
                cell.render(todo: model)
                cell.checkCallBack = { [weak self] id, check in
                    self?.viewModel.doneTodo(in: id, to: check)
                }
                cell.selectionStyle = .none
                return cell
            }
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return indexPath.section != 0
        }

        dataSource.canMoveRowAtIndexPath = { dataSource, indexPath in
            return indexPath.section != 0
        }
        
        viewModel.todoSections.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(HomePageListCellModel.self), tableView.rx.itemSelected).bind { [weak self] model, indexPath in
            if indexPath.section == 0 { self?.search() }
            else {
                print(indexPath, model)
            }
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
        let board = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(boardTapped))
        add.tintColor = TDLColor.iconGray
        board.tintColor = TDLColor.iconGray
        
        navigationItem.rightBarButtonItems = [add]
        navigationItem.leftBarButtonItems = [board]
    }
    
    @objc func addTapped() {
        let vc = EditNAddTodoViewController()
        vc.title = "新增"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func boardTapped() {
        
    }
    
    func search() {
        print("search")
    }

}
