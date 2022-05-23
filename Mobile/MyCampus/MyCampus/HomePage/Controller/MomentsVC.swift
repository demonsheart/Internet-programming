//
//  HomeMomentsVC.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import UIKit
import SnapKit

class MomentsVC: UIViewController {
    
    private let cellID = "moment"
    
    let data = MomentsModel.default
    
    var itemCount: Int = 30
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpView()
    }
    
    func setUpView() {
        // 设置 flowlayout
        let layout = WaterFallFlowLayout()
        layout.delegate = self
        
        // 设置 collectionview
        let  margin: CGFloat = 8
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        
        // 注册 Cell
        collectionView.register(MomentCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MomentsVC: UICollectionViewDelegate{
    
}

extension MomentsVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MomentCollectionViewCell
        cell.model = data[indexPath.row]
        return cell
    }
}

extension MomentsVC: WaterFallLayoutDelegate{
    func waterFlowLayout(_ waterFlowLayout: WaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat {
        return data[indexPath.row].overLookHeight
    }
}
