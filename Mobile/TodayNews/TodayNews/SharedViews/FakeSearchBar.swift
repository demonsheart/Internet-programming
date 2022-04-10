//
//  FakeSearchBar.swift
//  TodayNews
//
//  Created by herongjin on 2022/4/10.
//

import UIKit

// 处理滚动数据源
protocol FakeSearchDataSource {
    // TODO: 处理滚动数据源
}

// 处理点击代理
protocol FakeSearchDelegate {
    // TODO: 处理点击代理
}

/// 左边含搜索标识的bar 内部是滚动的一个collectionView
class FakeSearchBar: UIControl {
    
    let duration = 4.0
    var isAutoScroll = true
    private var timer: Timer?
    var size = CGSize(width: 0, height: 0) // 依靠layoutSubView计算
    
    var newsArr: [String]? {
        didSet {
            if oldValue == newsArr {
                return
            }
            scrollTo(crtPage: 0 + 1, animated: false)
            if self.isAutoScroll == true {
                addTimer()
            }
            self.hotNewsCollection.reloadData()
        }
    }
    
    lazy var searchIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .gray
        return view
    }()
    
    var hotNewsCollection: UICollectionView!
    
    init() {
        super.init(frame: .zero)
        newsArr = [
            "上海疫情防控情况 | 今年劳动节连休五天 ｜ 油价或将下调",
            "蔚来已暂停整车生产 | 稠州金租主帅辞职 ｜ 费列罗中国道歉",
            "五一放假通知 | 今年劳动节连休五天 ｜ 上海昨增本土“1006+23937”",
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach { $0.removeFromSuperview() }
        
        self.size = self.frame.size
        self.layer.cornerRadius = size.height * 0.52
        self.layer.backgroundColor = UIColor.white.cgColor
        
        let searchWidth = size.height * 0.5
        let leading: CGFloat = 10
        let spacing: CGFloat = 5
        
        self.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(searchWidth)
            make.left.equalTo(leading)
        }
        
        // init collection
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: size.width - searchWidth - spacing - leading*3 - 10, height: size.height)
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        // 禁止手势滑动
        collectionView.isScrollEnabled = false
        collectionView.register(HotNewsCollectionViewCell.self, forCellWithReuseIdentifier: "HotNews")
        
        self.hotNewsCollection = collectionView
        
        self.addSubview(self.hotNewsCollection)
        self.hotNewsCollection.snp.makeConstraints { make in
            make.left.equalTo(searchIcon.snp.right).offset(spacing)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-(leading * 2))
        }
        
        // start
        if self.newsArr == nil {
            return
        }
        guard (self.newsArr?.count)! > 1 else {
            self.hotNewsCollection.isScrollEnabled = false
            return
        }
        scrollTo(crtPage: 0 + 1 , animated: false)
        if self.isAutoScroll == true {
            addTimer()
        }
    }
}

// methods for timer
extension FakeSearchBar {
    fileprivate func addTimer() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: self.duration, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: .common)
        }
    }
    
    fileprivate func invalidateTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc fileprivate func nextPage() {
        if (self.newsArr?.count)! > 1 {
            var crtPage = 0
            crtPage = lroundf(Float(self.hotNewsCollection.contentOffset.y / size.height))
            scrollTo(crtPage: crtPage + 1, animated: true)
        }
    }
    
    fileprivate func scrollTo(crtPage: Int, animated: Bool) {
        self.hotNewsCollection.setContentOffset(CGPoint.init(x: 0, y: size.height * CGFloat(crtPage)), animated: animated)
    }
}

extension FakeSearchBar: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = CGFloat(0)
        offset = scrollView.contentOffset.y
        
        if offset == 0 {
            scrollTo(crtPage: (self.newsArr?.count)!, animated: false)
        } else if offset == CGFloat((self.newsArr?.count)! + 1) * size.height {
            scrollTo(crtPage: 1, animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // pause
        self.timer?.fireDate = Date.distantFuture
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // resume
        self.timer?.fireDate = Date.init(timeIntervalSinceNow: duration)
    }
}

extension FakeSearchBar: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (newsArr?.count)! > 1 ? (newsArr?.count)! + 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotNews", for: indexPath) as! HotNewsCollectionViewCell
        if indexPath.row == 0 {
            cell.label.text = newsArr?.last
        } else if indexPath.row == (newsArr?.count)! + 1 {
            cell.label.text = newsArr?.first
        } else {
            cell.label.text = newsArr?[indexPath.row - 1]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = (self.newsArr?.count)! > 1 ? (indexPath.item - 1) : 0
        print("------>\(row)")
    }
}

extension FakeSearchBar {
    class HotNewsCollectionViewCell: UICollectionViewCell {
        
        lazy var label: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.textAlignment = .center
            label.lineBreakMode = .byClipping
            label.font = .systemFont(ofSize: 13)
            return label
        }()
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(label)
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
