//
//  Zoom+Ext.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/11.
//

import UIKit
import Foundation

/// 以iPhoneX (375 * 812)为基准 进行缩放
/// 对于tableViewCell这种对屏幕高度限制无要求的 可以将x轴与y轴都用xZoom缩放 以铺满x方向
/// 在宽度限制无要求的 比如说单一居中显示的label 可以使用yZoom缩放 以铺满y方向
extension Int {
    
    var yZoom: CGFloat { return CGFloat(self) * (UIScreen.main.bounds.size.height / 812.0) }
    
    var xZoom: CGFloat { return CGFloat(self) * (UIScreen.main.bounds.size.width / 375.0) }
}

extension Double {
    
    var yZoom: CGFloat { return CGFloat(self) * (UIScreen.main.bounds.size.height / 812.0) }
    
    var xZoom: CGFloat { return CGFloat(self) * (UIScreen.main.bounds.size.width / 375.0) }
}

extension CGFloat {
    
    var yZoom: CGFloat { return self * (UIScreen.main.bounds.size.height / 812.0) }
    
    var xZoom: CGFloat { return self * (UIScreen.main.bounds.size.width / 375.0) }
}
