//
//  LoginViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

private let minimalUsernameLength = 5
private let minimalPasswordLength = 8

class LoginViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errMessageLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    let user = UserConfig.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountValidate = accountTextField.rx.text.orEmpty
            .map{ $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValidate = passwordTextField.rx.text.orEmpty
            .map{ $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValidate = Observable.combineLatest(accountValidate, passwordValidate) { $0 && $1 }
            .share(replay: 1)
        
        everythingValidate
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.login() })
            .disposed(by: disposeBag)
        
    }
    
    func login() {
        guard
            let account = accountTextField.text,
            let password = passwordTextField.text
        else { return }
        user.login(account: account, password: password) { [weak self] isLogin in
            if isLogin {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.errMessageLabel.isHidden = false
            }
        }
    }

    @IBAction func cancelTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
