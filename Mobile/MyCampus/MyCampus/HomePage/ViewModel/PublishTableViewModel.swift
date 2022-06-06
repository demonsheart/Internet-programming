//
//  PublishTableViewModel.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/24.
//

import RxDataSources
import RxCocoa
import RxSwift
import RxRelay
import Cache
import YPImagePicker

enum PublishCellModel {
    case text(MomentTextItem)
    case image(MomentPicItem)
    case video(MomentVideoItem)
    case tool1 // 文字 图片 位置
    case tool2 // 音频 视频
    case btn // 发布按钮
}

struct SectionOfPublishItemData {
  var header: String
  var items: [Item]
}

extension SectionOfPublishItemData: SectionModelType {
  typealias Item = PublishCellModel

   init(original: SectionOfPublishItemData, items: [Item]) {
    self = original
    self.items = items
  }
}

// MARK: PublishTableViewModel
class PublishTableViewModel {
    
    let sectionListSubject = BehaviorSubject(value: [SectionOfPublishItemData]())
    
    init() {
        sectionListSubject.onNext([
            SectionOfPublishItemData(header: "", items: [
                PublishCellModel.text(MomentTextItem(text: "")),
            ]),
            SectionOfPublishItemData(header: "", items: [
                PublishCellModel.tool1,
                PublishCellModel.tool2,
                PublishCellModel.btn,
            ])
        ])
    }
    
    // 删除前必须保存信息并重新渲染
    func removeItem(in tableView: UITableView, at indexPath: IndexPath) {
        guard
            var sections = try? sectionListSubject.value(),
            var preSection = preData(from: tableView)
        else { return }

        // Remove the item from the section at the specified indexPath
        preSection.items.remove(at: indexPath.row)

        // Update the section on section list
        sections[indexPath.section] = preSection

        // Inform your subject with the new changes
        sectionListSubject.onNext(sections)
    }
    
    func addText(in tableView: UITableView) {
        // 默认在section 0
        guard
            var sections = try? sectionListSubject.value(),
            var preSection = preData(from: tableView)
        else { return }
        preSection.items.append(PublishCellModel.text(MomentTextItem(text: "")))
        sections[0] = preSection
        sectionListSubject.onNext(sections)
        
    }
    
    func addImage(in tableView: UITableView, image: UIImage) {
        // 默认在section 0
        guard
            var sections = try? sectionListSubject.value(),
            var preSection = preData(from: tableView)
        else { return }
        preSection.items.append(PublishCellModel.image(MomentPicItem(image: image)))
        sections[0] = preSection
        sectionListSubject.onNext(sections)
    }
    
    func addVideo(in tableView: UITableView, ypVideo: YPMediaVideo) {
        // 默认在section 0
        guard
            var sections = try? sectionListSubject.value(),
            var preSection = preData(from: tableView)
        else { return }
        preSection.items.append(PublishCellModel.video(MomentVideoItem(ypVideo: ypVideo)))
        sections[0] = preSection
        sectionListSubject.onNext(sections)
    }
    
    func publish(in tableView: UITableView, title: String,  _ callback: @escaping () -> Void) {
        guard let data = preData(from: tableView) else { return }
        
        let location: String? = nil
        let timeStamp: String = "\(Int(NSDate().timeIntervalSince1970))"
        // TODO: 读取用户配置
        let owner = Owner(avatar: "", nick: "小何")
        var items = [MomentItemWrapper]()
        
        for item in data.items {
            switch item {
            case .image(let imageItem):
                items.append(MomentItemWrapper.pic(imageItem))
            case .text(let textItem):
                items.append(MomentItemWrapper.text(textItem))
            case .tool1, .tool2, .btn:
                break
            case .video(let videoItem):
                // MARK: picker内部缓存只是暂时缓存 需要自己执行一次copy
                videoItem.saveToCache()
                items.append(MomentItemWrapper.video(videoItem))
            }
        }
        
        let moment =  MomentsModel(title: title, location: location, timeStamp: timeStamp, owner: owner, items: items)
        
        // save to storage
        StoragedMoments.shared.list.append(moment)
        
        callback()
    }
    
    // 获取section0的所有SectionOfPublishItemData
    private func preData(from tableView: UITableView) -> SectionOfPublishItemData? {
        guard let sections = try? sectionListSubject.value() else { return nil }
        // Get the current section from the indexPath
        let preSection = sections[0]
        
        for i in 0..<preSection.items.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
            let itemData = preSection.items[i]
            
            switch itemData {
            case .text(let textItem):
                guard let cell = cell as? PublishTextViewTableVC else {
                    print("error textview")
                    break
                }
                textItem.text = cell.textView.text
                
            case .image(let imageItem):
                guard let cell = cell as? PublishImageTableViewCell else {
                    print("error image")
                    break
                }
                imageItem.image = cell.imgView.image ?? UIImage()
            case .tool1, .tool2, .btn:
                break
            case .video(let videoItem):
                guard let cell = cell as? PublishVideoTableViewCell else {
                    print("error video")
                    break
                }
                videoItem.fileName = cell.model?.fileName ?? ""
            }
        }
        
        return preSection
    }
}
