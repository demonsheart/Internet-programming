//
//  UserConfig.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/17.
//

import Foundation

class UserConfig {
    
    static var shared = UserConfig()
    
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
    
    func login(account: String, password: String, completion: @escaping (Bool) -> Void) {
        if account == "demodemo" && password == "demodemo" {
            isLogin = true
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        isLogin = false
        completion(true)
    }
}
