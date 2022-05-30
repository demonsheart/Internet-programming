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

protocol PublishItemData {
}

// data项必须用class
class PublishTextData: PublishItemData {
    var text: String = ""
}

class PublishImageData: PublishItemData {
    var image: UIImage
    
    init() { self.image = UIImage(named: "example")! }
    
    init(image: UIImage) { self.image = image }
}

class PublishToolData: PublishItemData {
}

class PublishBtnData: PublishItemData {
}

struct SectionOfPublishItemData {
  var header: String
  var items: [Item]
}

extension SectionOfPublishItemData: SectionModelType {
  typealias Item = PublishItemData

   init(original: SectionOfPublishItemData, items: [Item]) {
    self = original
    self.items = items
  }
}

class PublishTableViewModel {
    
    let sectionListSubject = BehaviorSubject(value: [SectionOfPublishItemData]())
    
    init() {
        sectionListSubject.onNext([
            SectionOfPublishItemData(header: "", items: [
                PublishTextData(),
            ]),
            SectionOfPublishItemData(header: "", items: [
                PublishToolData(),
                PublishBtnData(),
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
        preSection.items.append(PublishTextData())
        sections[0] = preSection
        sectionListSubject.onNext(sections)
        
    }
    
    func addImage(in tableView: UITableView, image: UIImage) {
        // 默认在section 0
        guard
            var sections = try? sectionListSubject.value(),
            var preSection = preData(from: tableView)
        else { return }
        preSection.items.append(PublishImageData(image: image))
        sections[0] = preSection
        sectionListSubject.onNext(sections)
    }
    
    // 捕获数据到model
    func saveDataIntoModel() {
        // TODO: 捕获数据到model
    }
    
    func publish(in tableView: UITableView, at indexPath: IndexPath) {
        // TODO: publish
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

            if let cell = cell as? PublishTextViewTableVC, let itemData = itemData as? PublishTextData {
                itemData.text = cell.textView.text
            }

            if let cell = cell as? PublishImageTableViewCell, let itemData = itemData as? PublishImageData {
                itemData.image = cell.imgView.image ?? UIImage()
            }

            // TODO: Other type save

        }
        
        return preSection
    }
}
