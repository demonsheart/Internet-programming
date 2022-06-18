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
        tableView.delegate = self
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
        
        // didselect
        Observable.zip(tableView.rx.modelSelected(HomePageListCellModel.self), tableView.rx.itemSelected).bind { [weak self] model, indexPath in
            if indexPath.section == 0 { self?.search() }
            else {
                debugPrint(indexPath, model)
            }
        }.disposed(by: disposeBag)
        
        // delete
        Observable.zip(tableView.rx.modelDeleted(HomePageListCellModel.self), tableView.rx.itemDeleted).bind { [weak self] model, _ in
            if let todo = model.todo {
                self?.viewModel.deleteTodo(in: todo.id)
            }
        }.disposed(by: disposeBag)
        
        // move
        tableView.rx.itemMoved.subscribe(onNext: { [weak self]
            sourceIndexPath, destinationIndexPath in
            self?.viewModel.moveTodo(from: sourceIndexPath, to: destinationIndexPath)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
        let edit = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(editTapped))
        add.tintColor = TDLColor.iconGray
        edit.tintColor = TDLColor.iconGray
        
        navigationItem.rightBarButtonItems = [add]
        navigationItem.leftBarButtonItems = [edit]
    }
    
    @objc func addTapped() {
        let vc = EditNAddTodoViewController()
        vc.title = "新增"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func editTapped() {
        tableView.isEditing.toggle()
    }
    
    func search() {
        print("search")
    }

}

extension HomePageViewController: UITableViewDelegate {
    //拖拽某行到一个目标上方时触发该方法，询问是否移动或者修正
    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        //如果目标位置和拖动行不是同一个分区，则拖动行返回自己原来的分区
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            //如果是往下面的分区拖动，则回到原分区末尾
            //如果是往上面的分区拖动，则会到原分区开头位置
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = tableView.numberOfRows(inSection: sourceIndexPath.section)-1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
}
