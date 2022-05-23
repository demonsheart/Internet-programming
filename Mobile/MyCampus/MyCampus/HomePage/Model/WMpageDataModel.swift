//
//  WMpageDataModel.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import Foundation
import UIKit

struct WMpageDataModel {
    var title: String
    var controller: UIViewController
    
    var controllerForCoder: AnyClass {
        return controller.classForCoder
    }
    
    // 静态数据
    static var `default`: [WMpageDataModel] = [
        WMpageDataModel(title: "首页", controller: MomentsVC()),
        WMpageDataModel(title: "推荐", controller: MomentsVC()),
        WMpageDataModel(title: "关注", controller: MomentsVC()),
    ]
}
