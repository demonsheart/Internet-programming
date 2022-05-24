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

protocol PublishItemData {
}

// data项必须用class
class PublishTextData: PublishItemData {
    var text: String = ""
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
    
    // 删除前必须保存信息并重新渲染
    func removeItem(in tableView: UITableView, at indexPath: IndexPath) {
        guard var sections = try? sectionListSubject.value() else { return }

        // Get the current section from the indexPath
        var currentSection = sections[indexPath.section]
        
        for i in 0..<currentSection.items.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section))
            let itemData = currentSection.items[i]
            
            if let cell = cell as? PublishTextViewTableVC, let itemData = itemData as? PublishTextData {
                itemData.text = cell.textView.text
            }
            
            // TODO: Other type save
            
        }

        // Remove the item from the section at the specified indexPath
        currentSection.items.remove(at: indexPath.row)

        // Update the section on section list
        sections[indexPath.section] = currentSection

        // Inform your subject with the new changes
        sectionListSubject.onNext(sections)
    }
    
    // 捕获数据到model
    func saveDataIntoModel() {
        // TODO: 捕获数据到model
    }
}
