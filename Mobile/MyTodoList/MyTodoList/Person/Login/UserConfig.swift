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
    
    func startHeartbeatForLogin() {
        stopHeartbeatForLogin()
        
        heartbeatForLoginTimer = Timer(timeInterval: 5, repeats: true, block: { timer in
             Service.shared.heartbeatForLogin { success in
                if !success {
                    UserDefaults.standard.set(false, forKey: "LoginState")
                    UserDefaults.standard.set("", forKey: "token")
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
        UserDefaults.standard.set("", forKey: "token")
        completion(true)
    }
    
}
