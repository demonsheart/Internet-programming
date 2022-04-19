//
//  TNBaseViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/12.
//

import UIKit
import RxSwift

class TNBaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func rt_customBackItem(withTarget target: Any!, action: Selector!) -> UIBarButtonItem! {
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: target, action: action)
        item.tintColor = TNColor.iconGray
        return item
    }
    
    func configAlertForLogout() {
        UserDefaults.standard.rx.observe(Bool.self, "LoginState")
            .skip(1)
            .subscribe(onNext: { [weak self] loginState in
                guard let loginState = loginState else { return }
                if !loginState {
                    self?.showAlert(alertText: "提示信息", alertMessage: "您已退出登录")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func jumpToLogin() {
        self.present(LoginViewController(), animated: true) {}
    }
}
