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
        tableView.register(UINib(nibName: "PublishTool2TableViewCell", bundle: nil), forCellReuseIdentifier: "tool2")
        tableView.register(UINib(nibName: "PublishBtnTableVC", bundle: nil), forCellReuseIdentifier: "btn")
        tableView.register(UINib(nibName: "PublishTextViewTableVC", bundle: nil), forCellReuseIdentifier: "text")
        tableView.register(UINib(nibName: "PublishImageTableViewCell", bundle: nil), forCellReuseIdentifier: "image")
        tableView.register(UINib(nibName: "PublishVideoTableViewCell", bundle: nil), forCellReuseIdentifier: "video")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
        <SectionOfPublishItemData>(configureCell: {
            (dataSource, tv, indexPath, element) in
            let withOfCell = UIScreen.main.bounds.size.width - 20
            switch element {
            case .tool1:
                let cell = tv.dequeueReusableCell(withIdentifier: "tool", for: indexPath) as! PublishToolTableViewCell
                cell.callBack = { [weak self] type in
                    if type == 0 {
                        self?.viewModel.addText(in: tv)
                    } else if type == 1 {
                        self?.showImagePicker()
                    } else if type == 2 {
                        // TODO: Add Location, Use GaoDe API
                        print("location")
                    }
                }
                return cell
            case .tool2:
                let cell = tv.dequeueReusableCell(withIdentifier: "tool2", for: indexPath) as! PublishTool2TableViewCell
                cell.callBack = { [weak self] type in
                    if type == 0 {
                        // TODO: audio cell
                        print("audio")
                    } else if type == 1 {
                        self?.showVideoPicker()
                    }
                }
                return cell
            case .btn:
                let cell = tv.dequeueReusableCell(withIdentifier: "btn", for: indexPath) as! PublishBtnTableVC
                cell.callBack = { [weak self] in
                    self?.viewModel.publish(in: tv, title: self?.titleTextView.text ?? "") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                return cell
            case .text(let textItem):
                let cell = tv.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! PublishTextViewTableVC
                cell.textView.text = textItem.text
                cell.saveCallBack = { text in
                    textItem.text = text
                }
                cell.deleteCallBack = { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.removeItem(in: tv, at: indexPath)
                }
                
                return cell
            case .image(let imageItem):
                let cell = tv.dequeueReusableCell(withIdentifier: "image", for: indexPath) as! PublishImageTableViewCell
                cell.imgView.image = imageItem.image
                cell.imgHeight.constant = imageItem.image.getImageHeight(width: withOfCell)
                cell.saveCallBack = { image in
                    imageItem.image = image
                }
                cell.deleteCallBack = { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.removeItem(in: tv, at: indexPath)
                }
                
                return cell
            case .video(let videoItem):
                let cell = tv.dequeueReusableCell(withIdentifier: "video", for: indexPath) as! PublishVideoTableViewCell
                cell.prepareVideo(model: videoItem)
                return cell
            }
        })
        
        //绑定单元格数据
        viewModel.sectionListSubject.asObserver()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // image选择器
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
    
    // video 选择器
    private func showVideoPicker() {
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .video]
        config.startOnScreen = .library
        config.library.mediaType = .video
        config.shouldSaveNewPicturesToAlbum = false
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker, unowned self] items, cancelled in
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            if let video = items.singleVideo {
                viewModel.addVideo(in: self.tableView, video: video)
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
