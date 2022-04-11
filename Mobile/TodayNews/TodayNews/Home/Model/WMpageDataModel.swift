//
//  WMpageDataModel.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/10.
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
        WMpageDataModel(title: "关注", controller: UIViewController()),
        WMpageDataModel(title: "推荐", controller: RecommendViewController()),
        WMpageDataModel(title: "热榜", controller: UIViewController()),
        WMpageDataModel(title: "视频", controller: UIViewController()),
        WMpageDataModel(title: "娱乐", controller: UIViewController()),
        WMpageDataModel(title: "抗疫", controller: UIViewController()),
        WMpageDataModel(title: "小视频", controller: UIViewController()),
        WMpageDataModel(title: "图片", controller: UIViewController()),
        WMpageDataModel(title: "免费小说", controller: UIViewController()),
        WMpageDataModel(title: "科技圈", controller: UIViewController()),
    ]
}
