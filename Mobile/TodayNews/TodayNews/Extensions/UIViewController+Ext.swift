//
//  UIViewController+Ext.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/19.
//

import UIKit

extension UIViewController {
    //Show a basic alert
    func showAlert(alertText: String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "确认", style: UIAlertAction.Style.default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
}
