//
//  PublishVC.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/24.
//

import UIKit
import IQKeyboardManagerSwift
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

class PublishVC: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTextView: IQTextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var isAddedLoc = false
    
    var textCellNum = 3
    
    let disposeBag = DisposeBag()
    
    let viewModel = PublishTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布"
        self.navigationController?.navigationBar.fixBarTintColor = .white
        self.view.backgroundColor = CPColor.bgGray
        titleTextView.delegate = self
        titleTextView.textContainerInset = .init(top: 3, left: 10, bottom: 3, right: 10)
        titleTextView.becomeFirstResponder()

//        tableView.delegate = self
//        tableView.dataSource = self
        
        tableView.backgroundColor = CPColor.bgGray
        tableView.register(UINib(nibName: "PublishToolTableViewCell", bundle: nil), forCellReuseIdentifier: "tool")
        tableView.register(UINib(nibName: "PublishBtnTableVC", bundle: nil), forCellReuseIdentifier: "btn")
        tableView.register(UINib(nibName: "PublishTextViewTableVC", bundle: nil), forCellReuseIdentifier: "text")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
        <SectionOfPublishItemData>(configureCell: {
            (dataSource, tv, indexPath, element) in
            
            switch element {
            case let element as PublishTextData:
                let cell = tv.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! PublishTextViewTableVC
                cell.textView.text = element.text
                cell.deleteCallBack = { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.removeItem(in: tv, at: indexPath)
                }
                
                return cell
            case _ as PublishToolData:
                let cell = tv.dequeueReusableCell(withIdentifier: "tool", for: indexPath) as! PublishToolTableViewCell
                cell.callBack = { [weak self] type in
                    if type == 0 {
                        self?.viewModel.addText(in: tv)
                    }
                }
                return cell
            case _ as PublishBtnData:
                let cell = tv.dequeueReusableCell(withIdentifier: "btn", for: indexPath) as! PublishBtnTableVC
                cell.callBack = { [weak self] in
                    self?.viewModel.publish(in: tv, at: indexPath)
                }
                return cell
            default:
                return UITableViewCell()
            }
        })
        
        //绑定单元格数据
        viewModel.sectionListSubject.asObserver()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}
