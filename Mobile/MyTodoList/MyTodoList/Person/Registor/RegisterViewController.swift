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
let countDownSeconds: Int = 10 //60 // 全局倒计时

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var codeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var password2TextField: SkyFloatingLabelTextField!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var sendCodeButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    let user = UserConfig.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCountDown()
        
        // MARK: email
        let emailValidate = emailTextField.rx.text.orEmpty
            .map{ $0.count >= minimalUsernameLength && $0.isEmail }
            .share(replay: 1)
        
        emailValidate.asObservable().skip(1).subscribe { [weak self] ok in
            self?.emailTextField.errorMessage = ok ? "" : "长度大于\(minimalUsernameLength)且必须为合法邮箱"
        }.disposed(by: disposeBag)
        
        emailValidate.bind(to: sendCodeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // MARK: code validate; 6lenth && isAlphanumeric
        let codeValidate = codeTextField.rx.text.orEmpty
            .map{ $0.count == 6 && $0.isAlphanumeric }
            .share(replay: 1)
        
        codeValidate.asObservable().skip(1).subscribe { [weak self] ok in
            self?.codeTextField.errorMessage = ok ? "" : "长度必须为6且必须为字母和数字的组合"
        }.disposed(by: disposeBag)
        
        // MARK: password validate
        let passwordValidate = passwordTextField.rx.text.orEmpty
            .map{ $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        passwordValidate.asObservable().skip(1).subscribe { [weak self] ok in
            self?.passwordTextField.errorMessage = ok ? "" : "长度必须大于\(minimalPasswordLength)"
        }.disposed(by: disposeBag)
        
        let password2Validate = password2TextField.rx.text.orEmpty
            .map{ $0 == self.passwordTextField.text }
            .share(replay: 1)
        
        password2Validate.asObservable().skip(1).subscribe { [weak self] ok in
            self?.password2TextField.errorMessage = ok ? "" : "检查两次输入密码是否一致"
            
        }.disposed(by: disposeBag)
        
        // MARK: checkbox validate
        let checkRelay = BehaviorRelay(value: false)
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
        
        // MARK: register enable
        let everythingValidate = Observable.combineLatest(emailValidate, codeValidate, passwordValidate, password2Validate, checkRelay) { $0 && $1 && $2 && $3 && $4 }
            .share(replay: 1)
        
        everythingValidate
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.register() })
            .disposed(by: disposeBag)
        
        sendCodeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.sendCode() })
            .disposed(by: disposeBag)
        
    }
    
    func register() {
        print("注册按钮")
        // TODO: register
        
        //        guard
        //            let email = emailTextField.text,
        //            var password = passwordTextField.text
        //        else { return }
        //        password = md5Hash(password)
        // 注册
    }
    
    private func sendCode() {
        print("发送验证码")
        // TODO: send code
    }
    
    private func configCountDown() {
        let second = sendCodeButton.rx.tap
            .flatMapLatest { _ -> Driver<Int> in
                return Observable<Int>.timer(.milliseconds(0), period: .milliseconds(1000), scheduler: MainScheduler.instance)
                    .map{countDownSeconds - $0}
                    .filter{ $0 >= 0 }
                    .asDriver(onErrorJustReturn: 0)
            }
        let sendCodeButtonText = second.map { $0 == 0 ? "获取验证码":"再次发送(\($0)s)"}
        let sendButtonEnable = second.map{$0 == 0 ? true : false}
        
        sendCodeButtonText
            .bind(to: sendCodeButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        sendButtonEnable
            .bind(to: sendCodeButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func md5Hash(_ source: String) -> String {
        return Insecure.MD5.hash(data: source.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }
    
    @IBAction func cancelTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func problemTap(_ sender: UIButton) {
        print("遇到问题")
    }
    
}
