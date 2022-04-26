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
import CryptoKit

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
        
        accountTextField.text = UserDefaults.standard.string(forKey: "account")
        
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
            var password = passwordTextField.text
        else { return }
        password = md5Hash(password)
        Service.shared.login(account: account, password: password) { [weak self] isLogin in
            if isLogin {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.errMessageLabel.isHidden = false
            }
        }
    }
    
    func md5Hash(_ source: String) -> String {
        return Insecure.MD5.hash(data: source.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }

    @IBAction func cancelTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
