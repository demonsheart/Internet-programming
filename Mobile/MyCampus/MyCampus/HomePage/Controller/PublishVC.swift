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
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
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
        
        //初始化数据
        viewModel.sectionListSubject.onNext([
            SectionOfPublishItemData(header: "", items: [
                PublishTextData(),
                PublishTextData(),
                PublishTextData(),
                PublishTextData(),
                PublishTextData(),
            ]),
            SectionOfPublishItemData(header: "", items: [
                PublishToolData(),
                PublishBtnData(),
            ])
        ])
        
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
                return cell
            case _ as PublishBtnData:
                let cell = tv.dequeueReusableCell(withIdentifier: "btn", for: indexPath) as! PublishBtnTableVC
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

//extension PublishVC: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return textCellNum
//        }
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! PublishTextViewTableVC
//            cell.callBack = { [weak self] in
//                guard let self = self, self.textCellNum > 1 else {
//                    return
//                }
//                print("cancel \(indexPath)")
//                tableView.beginUpdates()
//                self.textCellNum -= 1
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//                tableView.endUpdates()
//            }
//            return cell
//        }
//
//        if indexPath.section == 1 {
//            // tool
//            let cell = tableView.dequeueReusableCell(withIdentifier: "tool", for: indexPath) as! PublishToolTableViewCell
//            cell.callBack = { [weak self] id in
//                guard let self = self else { return }
//                if id == 2 && !self.isAddedLoc {
//                    self.isAddedLoc = true
//                    // TODO: add Location
//                    print("add Location")
//                } else if id == 0 {
//                    // TODO: add text
//                    print("add text")
//                } else if id == 1 {
//                    // TODO: add pic
//                    print("add pic")
//                }
//
//            }
//            return cell
//        } else if indexPath.section == 2 {
//            // publish button
//            let cell = tableView.dequeueReusableCell(withIdentifier: "btn", for: indexPath) as! PublishBtnTableVC
//            cell.callBack = {
//                print("publish")
//            }
//            return cell
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = CPColor.bgGray
//        return view
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//}
