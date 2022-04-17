//
//  LoginViewModel.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/17.
//

import Foundation

class LoginViewModel {
    
    static var shared = LoginViewModel()
    
    private let userDefault = UserDefaults.standard
    
    var isLogin: Bool {
        get {
            userDefault.bool(forKey: "LoginState")
        }
        set(value) {
            userDefault.set(value, forKey: "LoginState")
        }
    }
    
    init() {
    }
    
    func login(account: String, password: String) -> Bool {
        if account == "demo" && password == "demodemo" {
            isLogin = true
            return true
        }
        return false
    }
    
    func logout() {
        
    }
}
