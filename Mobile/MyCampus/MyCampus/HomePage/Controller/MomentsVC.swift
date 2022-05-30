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
    
//    let data = MomentsModel.default
    
    // TODO: 改为响应式
    let data = StoragedMoments.shared.list
    
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
        layout.sectionInset = UIEdgeInsets(top: 10, left: margin, bottom: 10, right: margin)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = CPColor.bgGray
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 注册 Cell
        collectionView.register(MomentCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MomentsVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(data[indexPath.row].title)
    }
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
