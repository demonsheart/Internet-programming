//
//  HomeMomentsVC.swift
//  MyCampus
//
//  Created by herongjin on 2022/5/23.
//

import UIKit
import SnapKit
import MJRefresh

class MomentsVC: UIViewController {
    
    private let cellID = "moment"
    
    let model = StoragedMoments.shared
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refleshData()
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
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            sleep(1)
            self?.refleshData()
        })
        
        // 注册 Cell
        collectionView.register(MomentCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func refleshData() {
        collectionView.reloadData()
        collectionView.mj_header?.endRefreshing()
    }
}

extension MomentsVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(model.list[indexPath.row].title)
    }
}

extension MomentsVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MomentCollectionViewCell
        cell.model = model.list[indexPath.row]
        return cell
    }
}

extension MomentsVC: WaterFallLayoutDelegate{
    func waterFlowLayout(_ waterFlowLayout: WaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat {
        return model.list[indexPath.row].overLookHeight
    }
}
