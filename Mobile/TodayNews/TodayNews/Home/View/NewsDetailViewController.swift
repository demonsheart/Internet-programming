//
//  NewsDetailViewController.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/12.
//

import UIKit

class NewsDetailViewController: TNBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.fixBarTintColor = .white
        self.view.backgroundColor = .white
        
        let more = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(moreTapped))
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchTapped))
        let service = UIBarButtonItem(image: UIImage(systemName: "headphones"), style: .plain, target: self, action: #selector(serviceTapped))
        more.tintColor = TNColor.iconGray
        search.tintColor = TNColor.iconGray
        service.tintColor = TNColor.iconGray

        navigationItem.rightBarButtonItems = [more, search, service]
    }
    
    @objc func moreTapped() {
        
    }
    
    @objc func searchTapped() {
        
    }
    
    @objc func serviceTapped() {
        
    }
}
