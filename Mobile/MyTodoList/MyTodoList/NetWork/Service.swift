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
    func getUserMess(completion: @escaping (Bool) -> Void)
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
        isConnnected = true
    }
}

extension Service: ServiceProtocol {
    
    var isConnnected: Bool {
        get {
            UserDefaults.standard.bool(forKey: "IsConnected")
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "IsConnected")
        }
    }
    
    var userParams: [String : Any] {
        return [
            "account": UserConfig.shared.account,
            "token": UserConfig.shared.token
        ]
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
                            UserConfig.shared.token = token
                            UserConfig.shared.account = account
                            UserConfig.shared.isLogin = true
                            
                            // 开启心跳定时器
                            UserConfig.shared.startHeartbeatForLogin()
                            
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
    
    func getUserMess(completion: @escaping (Bool) -> Void) {
        AF.request(Service.domain + "getUserMess", method: .post, parameters: JSON(userParams), encoder: JSONParameterEncoder.default, headers: Service.defaultHeaders)
            .responseData { response in
                switch response.result {
                    case .success(let value):
                        let json = try? JSON(data: value)
                        guard let json = json else { completion(false); return }
                        let success = json["success"].boolValue
                        if success {
                            let data = json["data"]
                            UserConfig.shared.avatar = data["avatar"].stringValue
                            UserConfig.shared.nick = data["nick"].stringValue
                            UserConfig.shared.phone = data["phone"].stringValue
                            UserConfig.shared.email = data["email"].stringValue
                        }
                        completion(success)
                    case .failure(_):
                        print("=======已断开连接，尝试重连=======")
                }
            }
    }
    
    func heartbeatForLogin(completion: @escaping (Bool) -> Void) {
        AF.request(Service.domain + "heartbeat", method: .post, parameters: JSON(userParams), encoder: JSONParameterEncoder.default, headers: Service.defaultHeaders)
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
//                self?.isConnnected = success
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

