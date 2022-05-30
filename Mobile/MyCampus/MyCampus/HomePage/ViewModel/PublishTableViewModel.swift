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

enum PublishCellModel {
    case text(MomentTextItem)
    case image(MomentPicItem)
    case tool
    case btn
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
                PublishCellModel.tool,
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
    
    // 捕获数据到model
    func saveDataIntoModel(in tableView: UITableView) {
        // TODO: 捕获数据到model
        guard let _ = preData(from: tableView) else { return }
        
        let _ =  MomentsModel(title: "总书记的一周", location: "深圳大学", timeStamp: "1653299917", owner: Owner(avatar: "", nick: "央视新闻"), items: [
            MomentItemWrapper.text(MomentTextItem(text: "")),
        ])
        
    }
    
    func publish(in tableView: UITableView, at indexPath: IndexPath) {
        // TODO: publish
        saveDataIntoModel(in: tableView)
        print("publish")
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
            case .tool, .btn:
                break
            }
        }
        
        return preSection
    }
}
