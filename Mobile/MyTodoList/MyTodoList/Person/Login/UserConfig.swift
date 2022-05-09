//
//  UserConfig.swift
//  MyTodoList
//
//  Created by aicoin on 2022/5/8.
//

import Foundation

class UserConfig {
    
    static var shared = UserConfig()
    
    private let userDefault = UserDefaults.standard
    
    private var heartbeatForLoginTimer: Timer?
    
    var email: String {
        get {
            userDefault.string(forKey: "Email") ?? ""
        }
        set(value) {
            userDefault.set(value, forKey: "Email")
        }
    }
    
    var isLogin: Bool {
        get {
            userDefault.bool(forKey: "LoginState")
        }
        set(value) {
            userDefault.set(value, forKey: "LoginState")
        }
    }
    
    var token: String {
        get {
            userDefault.string(forKey: "Token") ?? ""
        }
        set(value) {
            userDefault.set(value, forKey: "Token")
        }
    }
    
    var avatar: String {
        get {
            userDefault.string(forKey: "Avatar") ?? ""
        }
        set(value) {
            userDefault.set(value, forKey: "Avatar")
        }
    }
    
    var nick: String {
        get {
            userDefault.string(forKey: "Nick") ?? ""
        }
        set(value) {
            userDefault.set(value, forKey: "Nick")
        }
    }
    
    var phone: String {
        get {
            userDefault.string(forKey: "Phone") ?? ""
        }
        set(value) {
            userDefault.set(value, forKey: "Phone")
        }
    }
    
    init() {
        
    }
    
    func startHeartbeatForLogin() {
        stopHeartbeatForLogin()
        
        heartbeatForLoginTimer = Timer(timeInterval: 10, repeats: true, block: { timer in
             Service.shared.heartbeatForLogin { success in
                if !success {
                    UserConfig.shared.isLogin = false
                    UserConfig.shared.token = ""
                    timer.invalidate()
                }
            }
        })
        
        RunLoop.current.add(heartbeatForLoginTimer!, forMode: .default)
        heartbeatForLoginTimer!.fire()
    }
    
    func stopHeartbeatForLogin() {
        guard let timer = heartbeatForLoginTimer else { return }
        timer.invalidate()
        heartbeatForLoginTimer = nil
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        isLogin = false
        token = ""
        completion(true)
    }
    
}
