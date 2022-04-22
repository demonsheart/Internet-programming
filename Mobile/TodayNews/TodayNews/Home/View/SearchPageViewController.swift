//
//  SearchPageViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Contacts

class SearchPageViewController: TNBaseViewController, UITextFieldDelegate {
    
    var placeholder = ""
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.placeholder = placeholder
        textField.delegate = self
        
        //        startSearchContactsByName()
        //        startSearchContactsByNumber()
        getAllContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func startSearchContactsByName() {
        let store = CNContactStore()
        let predicate = CNContact.predicateForContacts(matchingName: "Appleseed")
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
        do {
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            print("Fetched contacts: \(contacts)")
        } catch {
            print("Failed to fetch contact, error: \(error)")
            // Handle the error
        }
    }
    
    private func startSearchContactsByNumber() {
        let store = CNContactStore()
        let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: "(555) 564-8583"))
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
        do {
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            print("Fetched contacts: \(contacts)")
        } catch {
            print("Failed to fetch contact, error: \(error)")
            // Handle the error
        }
    }
    
    private func getAllContacts() {
        // 验证授权
        // 1. 判断授权
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        // 2. 如果授权没有请求,需要请求
        if status != .authorized {
            print("授权失败")
            return
        }
        
        // 获取所有联系人
        // 1.创建联系人仓库对象
        let contactStore = CNContactStore()
        
        // 2, 使用一个方法, 遍历所有联系人
        // 作用, 根据筛选的条件, 遍历所有的联系人
        // 值获取这个参数里面提供的key对应的值, 其他的字段属性, 都不获取
        let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor])
        
        do {
            // 遍历联系人
            // 注意, 这种遍历, 类似于数组的遍历
            // 每执行一次block, 只会传递过来一个联系人对象
            // 而联系人对象里面的值得获取, 是根据上面 CNContactFetchRequest, 参数指定的key来的, 没写的key, 统统不获取
            try contactStore.enumerateContacts(with: request) { (contact: CNContact, stop) in
                //
                let givenName = contact.givenName
                print(givenName)
                // 遍历电话号码
                let phoneNums = contact.phoneNumbers
                // 每个电话号码, 包括标签和值
                for phoneNum in phoneNums {
                    let label = phoneNum.label
                    let value = phoneNum.value
                    print(label, value.stringValue)
                }
            }
        } catch {
            
            print(error)
            return
        }
    }
    
}
