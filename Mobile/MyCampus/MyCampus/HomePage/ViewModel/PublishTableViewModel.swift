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

// cell identify
enum ItemType: String {
    case Tool = "tool"
    case Btn = "btn"
    case Text = "text"
    case Pic = "pic"
    case Audio = "audio"
    case Video = "video"
}

struct PublishItemData {
    var itemType: ItemType
    // 其他所需变量
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
    
    func removeItem(at indexPath: IndexPath) {
        guard var sections = try? sectionListSubject.value() else { return }

        // Get the current section from the indexPath
        var currentSection = sections[indexPath.section]

        // Remove the item from the section at the specified indexPath
        currentSection.items.remove(at: indexPath.row)

        // Update the section on section list
        sections[indexPath.section] = currentSection

        // Inform your subject with the new changes
        sectionListSubject.onNext(sections)
    }
}
