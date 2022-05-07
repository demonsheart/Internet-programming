//
//  BaseViewController.swift
//  MyTodoList
//
//  Created by aicoin on 2022/5/7.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    override func rt_customBackItem(withTarget target: Any!, action: Selector!) -> UIBarButtonItem! {
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
        item.tintColor = TDLColor.iconGray
        return item
    }
}
