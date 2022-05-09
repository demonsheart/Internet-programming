//
//  RegisterViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import CryptoKit
import SkyFloatingLabelTextField

private let minimalUsernameLength = 8
private let minimalPasswordLength = 8

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errMessageLabel: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    var disposeBag = DisposeBag()
    
    let user = UserConfig.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errMessageLabel.isHidden = false
        self.errMessageLabel.text = ""
        
        emailTextField.text = UserConfig.shared.email
        
        let emailValidate = emailTextField.rx.text.orEmpty
            .map{ $0.count >= minimalUsernameLength && $0.isEmail }
            .share(replay: 1)
        
        let passwordValidate = passwordTextField.rx.text.orEmpty
            .map{ $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let checkRelay = BehaviorRelay(value: false)
        
        let everythingValidate = Observable.combineLatest(emailValidate, passwordValidate, checkRelay) { $0 && $1 && $2 }
            .share(replay: 1)
        
        emailValidate.asObservable().skip(1).subscribe { [weak self] ok in
            self?.emailTextField.errorMessage = ok ? "" : "长度大于\(minimalUsernameLength)且必须为数字或字母组合"
        }.disposed(by: disposeBag)
        
        passwordValidate.asObservable().skip(1).subscribe { [weak self] ok in
            self?.passwordTextField.errorMessage = ok ? "" : "长度必须大于\(minimalPasswordLength)"
        }.disposed(by: disposeBag)
        
        everythingValidate
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.checkBox.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.checkBox.isSelected.toggle()
                if self?.checkBox.isSelected ?? false {
                    self?.checkBox.tintColor = UIColor(named: "iconBlue")
                } else {
                    self?.checkBox.tintColor = .lightGray
                }
                checkRelay.accept(self?.checkBox.isSelected ?? false)
            }).disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.login() })
            .disposed(by: disposeBag)
        
    }
    
    func login() {
        guard
            let email = emailTextField.text,
            var password = passwordTextField.text
        else { return }
        password = md5Hash(password)
        Service.shared.login(email: email, password: password) { [weak self] isLogin in
            if isLogin {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.errMessageLabel.text = "登录失败"
            }
        }
    }
    
    func md5Hash(_ source: String) -> String {
        return Insecure.MD5.hash(data: source.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }
    
    @IBAction func cancelTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerTap(_ sender: UIButton) {
        print("register")
//        self.present(, animated: true)
    }
}
