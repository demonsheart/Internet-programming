//
//  UINavigationbar+Ext.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/10.
//

import UIKit

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
