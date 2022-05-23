//
//  BaseViewController.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func rt_customBackItem(withTarget target: Any!, action: Selector!) -> UIBarButtonItem! {
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
        item.tintColor = CPColor.iconGray
        return item
    }

}
