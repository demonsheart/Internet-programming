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
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.backgroundColor = TDLColor.bgGreen
        if #available(iOS 15.0, *) {
            tableView.isPrefetchingEnabled = false
            tableView.sectionHeaderTopPadding = 0
        }
        
//        table.register(HomePageListHeaderView.self,
//               forHeaderFooterViewReuseIdentifier: "listHeader")
        tableView.register(UINib(nibName: "HomePageSearchTableVC", bundle: nil), forCellReuseIdentifier: "search")
        
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
                return cell
            case .list(let model):
                let cell = UITableViewCell()
                cell.textLabel?.text = model.keyword
                cell.selectionStyle = .none
                return cell
            }
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        viewModel.sectionListSubject.asObserver()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(HomePageListCellModel.self), tableView.rx.itemSelected).bind { [weak self] model, index in
            print(index, model)
        }.disposed(by: disposeBag)
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

//extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 { return 1 }
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//
//    // MARK: - Header
//    func tableView(_ tableView: UITableView,
//                   viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 { return nil }
//
//        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:"listHeader") as! HomePageListHeaderView
//        view.label.text = "Header"
//
//        return view
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 { return CGFloat.leastNonzeroMagnitude }
//        return 40
//    }
//
//    // MARK: - Footer
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return nil
//    }
//
//
//}
