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

class SearchPageViewController: TNBaseViewController, UITextFieldDelegate, UITableViewDelegate {
    
    var placeholder = ""
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SearchViewModel()
    
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.placeholder = placeholder
        textField.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        textField.rx.text.orEmpty
                    .bind(to: viewModel.searchOB).disposed(by: disposeBag)
        
        viewModel.searchData
            .drive(tableView.rx.items(cellIdentifier: "cell")) { _, model, cell in
                cell.selectionStyle = .none
                cell.imageView?.image = UIImage(named: model.avatar)
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = model.mobile
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension SearchPageViewController {
    
    class Person {
        var avatar = "person.fill"
        var name: String
        var mobile: String
        
        init(name: String, mobile: String) {
            self.name = name
            self.mobile = mobile
        }
    }
    
    class SearchViewModel {
        //1、创建一个序列
        let searchOB = BehaviorSubject(value: "")
        
        lazy var searchData: Driver<[Person]> = {
            return self.searchOB.asObserver()
                .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)//设置300毫秒发送一次消息
                .distinctUntilChanged()//搜索框内容改变才发送消息
                .flatMap(requestPerson)
                .asDriver(onErrorJustReturn: [])
        }()
        
        func requestPerson(_ keyword: String) -> Observable<[Person]> {
            if keyword == "联系人" {
                return getAllContacts()
            } else if keyword.starts(with: "") {
                
            } else if keyword.starts(with: "") {
                
            }
            
            return Observable<[Person]>.just([])
        }
        
        func startSearchContactsByName(_ name: String) {
            let store = CNContactStore()
            let predicate = CNContact.predicateForContacts(matchingName: name)
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
            do {
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                print("Fetched contacts: \(contacts)")
            } catch {
                print("Failed to fetch contact, error: \(error)")
                // Handle the error
            }
        }
        
        func startSearchContactsByNumber(_ number: String) {
            let store = CNContactStore()
            let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: number))
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
            do {
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                print("Fetched contacts: \(contacts)")
            } catch {
                print("Failed to fetch contact, error: \(error)")
                // Handle the error
            }
        }
        
        func getAllContacts() -> Observable<[Person]> {
            let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            if status != .authorized {
                print("授权失败")
                return Observable<[Person]>.just([])
            }
            
            let contactStore = CNContactStore()
            let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor])
            var persons = [Person]()
            
            do {
                try contactStore.enumerateContacts(with: request) { (contact: CNContact, stop) in
                    let fullName = contact.givenName + contact.familyName
                    
                    let phoneNums = contact.phoneNumbers
                    let validTypes = [
//                        CNLabelPhoneNumberiPhone,
                        CNLabelPhoneNumberMobile,
//                        CNLabelPhoneNumberMain
                    ]
                    
                    let numbers = phoneNums.compactMap { phoneNumber -> String? in
                        guard let label = phoneNumber.label, validTypes.contains(label) else { return nil }
                        return phoneNumber.value.stringValue
                    }
                    if numbers.isEmpty {
                        persons.append(Person(name: fullName, mobile: "-"))
                    } else {
                        persons.append(Person(name: fullName, mobile: numbers[0]))
                    }
                }
            } catch {
                print(error)
                return Observable<[Person]>.just([])
            }
            
            return Observable<[Person]>.just(persons)
        }
    }
    
}
