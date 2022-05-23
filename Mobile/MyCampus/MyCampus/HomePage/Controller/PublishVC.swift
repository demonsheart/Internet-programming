//
//  PublishVC.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import UIKit

class PublishVC: UIViewController, UITextViewDelegate {

    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CPColor.bgGray
        self.navigationController?.navigationBar.fixBarTintColor = .white
        
        textView.delegate = self
        
        self.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalToSuperview()
        }
    }

}
