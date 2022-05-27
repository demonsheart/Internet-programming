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
import YPImagePicker

class PublishVC: BaseViewController {
    
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
        self.hideKeyboardWhenTappedAround()
        titleTextView.delegate = self
        titleTextView.textContainerInset = .init(top: 3, left: 10, bottom: 3, right: 10)
        titleTextView.becomeFirstResponder()
        
        tableView.backgroundColor = CPColor.bgGray
        tableView.register(UINib(nibName: "PublishToolTableViewCell", bundle: nil), forCellReuseIdentifier: "tool")
        tableView.register(UINib(nibName: "PublishBtnTableVC", bundle: nil), forCellReuseIdentifier: "btn")
        tableView.register(UINib(nibName: "PublishTextViewTableVC", bundle: nil), forCellReuseIdentifier: "text")
        tableView.register(UINib(nibName: "PublishImageTableViewCell", bundle: nil), forCellReuseIdentifier: "image")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
        <SectionOfPublishItemData>(configureCell: {
            (dataSource, tv, indexPath, element) in
            let withOfCell = UIScreen.main.bounds.size.width - 20
            switch element {
            case let element as PublishTextData:
                let cell = tv.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! PublishTextViewTableVC
                cell.textView.text = element.text
                cell.saveCallBack = { text in
                    element.text = text
                }
                cell.deleteCallBack = { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.removeItem(in: tv, at: indexPath)
                }
                
                return cell
            case let element as PublishImageData:
                let cell = tv.dequeueReusableCell(withIdentifier: "image", for: indexPath) as! PublishImageTableViewCell
                cell.imgView.image = element.image
                cell.imgHeight.constant = element.image.getImageHeight(width: withOfCell)
                cell.saveCallBack = { image in
                    element.image = image
                }
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
                    } else if type == 1 {
                        // TODO: picture picker
                        self?.showImagePicker()
                    } else if type == 2 {
                        // TODO: Add Location, Use GaoDe API
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
    
    private func showImagePicker() {
        var config = YPImagePickerConfiguration()
        config.startOnScreen = .library
        config.shouldSaveNewPicturesToAlbum = false
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker, unowned self] items, cancelled in
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            if let photo = items.singlePhoto {
                viewModel.addImage(in: self.tableView, image: photo.image)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

}

extension PublishVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let character = text.first, character.isNewline {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("end")
    }
}
