//
//  Extensions.swift
//  MyTodoList
//
//  Created by aicoin on 2022/5/7.
//

import UIKit
import Foundation

// MARK: UIColor
extension UIColor {
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}

// MARK: UINavigationBar
extension UINavigationBar {
    var fixBarTintColor: UIColor? {
        get {
            return self.barTintColor
        }
        
        set(newColor) {
            self.barTintColor = newColor
            
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = newColor
                appearance.shadowColor = .clear
                appearance.titleTextAttributes = self.titleTextAttributes ?? [.foregroundColor: UIColor.label]
                self.standardAppearance = appearance
                self.scrollEdgeAppearance = appearance
            }
        }
    }
    
    var fixTitleTextAttributes: [NSAttributedString.Key : Any]? {
        get {
            return self.titleTextAttributes
        }
        
        set(newAttr) {
            self.titleTextAttributes = newAttr
            
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = self.barTintColor
                appearance.shadowColor = .clear
                appearance.titleTextAttributes = newAttr ?? [.foregroundColor: UIColor.label]
                self.standardAppearance = appearance
                self.scrollEdgeAppearance = appearance
            }
        }
    }
    
    func clearBgColor() {
        if #available(iOS 15.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = UIColor.clear
            navBarAppearance.shadowColor = UIColor.clear
            self.scrollEdgeAppearance = nil
            self.standardAppearance = navBarAppearance
        } else {
            self.setBackgroundImage(UIImage(), for: .default)
            self.shadowImage = UIImage()
        }
    }
}

// MARK: String
extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

// MARK: NSAttributedString
extension NSAttributedString {
    
    /// 根据给定的宽度计算NSAttributedString需要的高度
    /// 必须在NSAttributedString中设置好Font
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// 根据给定的高度计算NSAttributedString需要的宽度
    /// 必须在NSAttributedString中设置好Font
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

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

// MARK: UIViewController
extension UIViewController {
    //Show a basic alert
    func showAlert(alertText: String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
}
