//
//  Service.swift
//  MyTodoList
//
//  Created by aicoin on 2022/5/8.
//

import Foundation
import SwiftyJSON
import Alamofire

let session = URLSession.shared

protocol ServiceProtocol {
    func login(account: String, password: String, completion: @escaping (Bool) -> Void)
    func heartbeatForLogin(completion: @escaping (Bool) -> Void)
//    func heartbeatForConnnect(completion: @escaping (Bool) -> Void)
//    func startHeartbeat()
//    func stopHeartbeat()
    
    var isConnnected: Bool { get }
}

class Service {
    static let shared: ServiceProtocol = Service()
    static let defaultHeaders: HTTPHeaders = [
        "Content-Type": "application/json",
        "User-Agent": "HRJ",
    ]
    static let domain = "http://127.0.0.1:60035/"
    
    private var heartbeatTimer: Timer?
    
    private init() {
        UserDefaults.standard.set(true, forKey: "isConnected")
    }
}

extension Service: ServiceProtocol {
    
    var isConnnected: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isConnected")
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "isConnected")
        }
    }
    
    func login(account: String, password: String, completion: @escaping (Bool) -> Void) {
        let params: [String: String] = [
            "account": account,
            "password": password
        ]
        
        AF.request(Service.domain + "login", method: .post, parameters: JSON(params), encoder: JSONParameterEncoder.default, headers: Service.defaultHeaders)
            .responseData { response in
                switch response.result {
                    case .success(let value):
                        let json = try? JSON(data: value)
                        guard let json = json else { completion(false); return }
                        let success = json["success"].boolValue
                        if success {
                            let token = json["data"]["token"].stringValue
                            print(token)
                            UserDefaults.standard.set(token, forKey: "token")
                            UserDefaults.standard.set(account, forKey: "account")
                            UserDefaults.standard.set(true, forKey: "LoginState")
                            
                            // 开启心跳定时器
//                            UserConfig.shared.startHeartbeatForLogin()
                            
                            completion(true)
                        } else {
                            completion(false)
                        }
                    case .failure(let err):
                        print(err)
                        completion(false)
                }
            }
    }
    
    func heartbeatForLogin(completion: @escaping (Bool) -> Void) {
        guard
            let account = UserDefaults.standard.string(forKey: "account"),
            let token = UserDefaults.standard.string(forKey: "token")
        else {
            completion(false)
            return
        }
        
        let params: [String: Any] = [
            "account": account,
            "token": token
        ]
        
        AF.request(Service.domain + "heartbeat", method: .post, parameters: JSON(params), encoder: JSONParameterEncoder.default, headers: Service.defaultHeaders)
            .responseData { response in
                switch response.result {
                    case .success(let value):
                        let json = try? JSON(data: value)
                        guard let json = json else { completion(false); return }
                        let success = json["success"].boolValue
                        completion(success)
                    case .failure(_):
                        print("=======已断开连接，尝试重连=======")
                }
            }
    }
    
//    func heartbeatForConnnect(completion: @escaping (Bool) -> Void) {
//        AF.request(Service.domain + "heartbeat", method: .post, headers: Service.defaultHeaders)
//            .responseData { response in
//                switch response.result {
//                    case .success(let value):
//                        let json = try? JSON(data: value)
//                        guard let json = json else { completion(false); return }
//                        let success = json["success"].boolValue
//                        completion(success)
//                    case .failure(_):
//                        print("=======已断开连接，尝试重连=======")
//                        completion(false)
//                }
//            }
//    }
    
//    func startHeartbeat() {
//        stopHeartbeat()
//
//        heartbeatTimer = Timer(timeInterval: 5, repeats: true, block: { [weak self] timer in
//            self?.heartbeatForConnnect { success in
//                UserDefaults.standard.set(success, forKey: "isConnected")
//
//            }
//        })
//
//        RunLoop.current.add(heartbeatTimer!, forMode: .default)
//        heartbeatTimer!.fire()
//    }
//
//    func stopHeartbeat() {
//        guard let timer = heartbeatTimer else { return }
//        timer.invalidate()
//        heartbeatTimer = nil
//    }
}

