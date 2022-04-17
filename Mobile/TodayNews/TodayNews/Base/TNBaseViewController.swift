//
//  TNBaseViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/12.
//

import UIKit

class TNBaseViewController: UIViewController {
    override func rt_customBackItem(withTarget target: Any!, action: Selector!) -> UIBarButtonItem! {
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
        item.tintColor = TNColor.iconGray
        return item
    }
    
    func jumpToLogin() {
        self.present(LoginViewController(), animated: true) {
            
        }
    }
}
