//
//  MomentDetailVC.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/30.
//

import UIKit

class MomentDetailVC: BaseViewController {
    
    let model: MomentsModel
    
    let toolBarHeight: CGFloat = 40
    
    let toolBar = BottomToolView()
    
    let header = HeaderView()
    
    let content: ContentView
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-toolBarHeight)
        }
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byCharWrapping
        label.font = .boldSystemFont(ofSize: 23)
        label.text = model.title
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        scrollView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        return view
    }()
    
    init(model: MomentsModel) {
        self.model = model
        self.content = ContentView(items: model.items)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.fixBarTintColor = .white
        self.view.backgroundColor = .white
        
        let more = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(moreTapped))
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchTapped))
        let service = UIBarButtonItem(image: UIImage(systemName: "headphones"), style: .plain, target: self, action: #selector(serviceTapped))
        more.tintColor = CPColor.iconGray
        search.tintColor = CPColor.iconGray
        service.tintColor = CPColor.iconGray
        
        navigationItem.rightBarButtonItems = [more, search, service]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(toolBar)
        toolBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(toolBarHeight)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        containerView.addSubview(header)
        header.avatarView.sd_setImage(with: URL(string: "https://p3-sign.toutiaoimg.com/pgc-image/21507a12df2c4e7eb2d859c6f32dd497~tplv-tt-large.image?x-expires=1965128203&x-signature=RgTmiaTxyrICK4%2B%2B1xB4esDHb7U%3D"), placeholderImage: UIImage(named: "person.crop.circle"))
        header.sourceLabel.text = model.owner.nick
        header.sourceInfoLabel.text = "\(model.formattedTimeStr) · 管理员"
        header.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        containerView.addSubview(content)
        content.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            
            // MARK: botton constraint
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func moreTapped() {
        
    }
    
    @objc func searchTapped() {
        
    }
    
    @objc func serviceTapped() {
        
    }
}

extension MomentDetailVC {
    class BottomToolView: UIView {
        lazy var writeLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .center
            label.text = "写评论..."
            label.backgroundColor = UIColor("F2F2F2")
            return label
        }()
        
        lazy var shareIcon: UIButton = {
            let btn = UIButton()
            btn.setImage(UIImage(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btn.tintColor = CPColor.iconGray
            return btn
        }()
        
        lazy var likeIcon: UIButton = {
            let btn = UIButton()
            btn.setImage(UIImage(systemName: "hand.thumbsup")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btn.tintColor = CPColor.iconGray
            return btn
        }()
        
        lazy var collectIcon: UIButton = {
            let btn = UIButton()
            btn.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btn.tintColor = CPColor.iconGray
            return btn
        }()
        
        lazy var commentIcon: UIButton = {
            let btn = UIButton()
            btn.setImage(UIImage(systemName: "message")?.withRenderingMode(.alwaysTemplate), for: .normal)
            btn.tintColor = CPColor.iconGray
            return btn
        }()
        
        
        init() {
            super.init(frame: .zero)
            
            let line = UIView()
            line.backgroundColor = .lightGray
            self.addSubview(line)
            line.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(0.35)
            }
            
            self.addSubview(writeLabel)
            writeLabel.snp.makeConstraints { make in
                make.width.equalTo(150)
                make.left.equalTo(20)
                make.top.equalTo(3)
                make.bottom.equalTo(-3)
                make.centerY.equalToSuperview()
            }
            
            self.addSubview(shareIcon)
            shareIcon.snp.makeConstraints { make in
                make.right.equalTo(-10)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(35)
            }
            
            self.addSubview(likeIcon)
            likeIcon.snp.makeConstraints { make in
                make.right.equalTo(shareIcon.snp.left).offset(-10)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(35)
            }
            
            self.addSubview(collectIcon)
            collectIcon.snp.makeConstraints { make in
                make.right.equalTo(likeIcon.snp.left).offset(-10)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(35)
            }
            
            self.addSubview(commentIcon)
            commentIcon.snp.makeConstraints { make in
                make.right.equalTo(collectIcon.snp.left).offset(-10)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(35)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // 50 height
    class HeaderView: UIView {
        
        lazy var avatarView = UIImageView()
        
        lazy var sourceLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .left
            return label
        }()
        
        lazy var sourceInfoLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 12)
            label.textColor = .lightGray
            label.textAlignment = .left
            return label
        }()
        
        lazy var likeLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .center
            label.text = "关注"
            label.layer.borderWidth = 0.3
            label.layer.borderColor = CPColor.iconGray.cgColor
            return label
        }()
        
        init() {
            super.init(frame: .zero)
            
            self.addSubview(avatarView)
            avatarView.contentMode = .scaleToFill
            avatarView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(35)
                make.left.equalTo(10)
            }
            
            self.addSubview(sourceLabel)
            sourceLabel.snp.makeConstraints { make in
                make.bottom.equalTo(self.snp.centerY)
                make.left.equalTo(avatarView.snp.right).offset(10)
            }
            
            self.addSubview(sourceInfoLabel)
            sourceInfoLabel.snp.makeConstraints { make in
                make.top.equalTo(self.snp.centerY)
                make.left.equalTo(sourceLabel)
            }
            
            self.addSubview(likeLabel)
            likeLabel.snp.makeConstraints { make in
                make.right.equalTo(-10)
                make.centerY.equalToSuperview()
                make.height.equalTo(30)
                make.width.equalTo(60)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
    
    class ContentView: UIView {
        
        enum UIViewWrapper {
            case label(UILabel)
            case image(UIImageView)
            case audio
            case video
        }
        
        let items: [MomentItemWrapper]
        var views = [UIViewWrapper]()
        
        init(items: [MomentItemWrapper]) {
            self.items = items
            super.init(frame: .zero)
            
            // 按照[MomentItemWrapper]顺序布局 生成布局
            initViews()
            initConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initViews() {
            for item in items {
                switch item {
                case .text(let momentTextItem):
                    views.append(generateUILabel(text: momentTextItem.text))
                case .pic(let momentPicItem):
                    views.append(generateUIImageView(image: momentPicItem.image))
                case .audio(_):
                    break
                case .video(_):
                    break
                }
            }
        }
        
        private func initConstraints() {
            
            var preView = UIView() // 前一个view引用 用来下一个item加top约束
            for i in 0..<views.count {
                let wrapper = views[i]
                
                if i == 0 { // first -- top
                    switch wrapper {
                    case .image(let imageView):
                        self.addSubview(imageView)
                        let height: CGFloat = imageView.image?.getImageHeight(width: UIScreen.main.bounds.size.width - 20) ?? .leastNonzeroMagnitude
                        imageView.snp.makeConstraints { make in
                            make.top.equalToSuperview()
                            make.left.equalTo(10)
                            make.right.equalTo(-10)
                            make.height.equalTo(height)
                        }
                        preView = imageView
                    case .label(let label):
                        self.addSubview(label)
                        label.snp.makeConstraints { make in
                            make.top.equalToSuperview()
                            make.left.equalTo(10)
                            make.right.equalTo(-10)
                        }
                        preView = label
                    case .audio:
                        break
                    case .video:
                        break
                    }
                    // 补充情况 如果唯一元素 则加底部约束
                    if views.count == 1 {
                        preView.snp.makeConstraints { make in
                            make.bottom.equalToSuperview().offset(-10)
                        }
                    }
                } else if i < views.count - 1 { // center
                    switch wrapper {
                    case .image(let imageView):
                        self.addSubview(imageView)
                        let height: CGFloat = imageView.image?.getImageHeight(width: UIScreen.main.bounds.size.width - 20) ?? .leastNonzeroMagnitude
                        imageView.snp.makeConstraints { make in
                            make.top.equalTo(preView.snp.bottom).offset(10)
                            make.left.equalTo(10)
                            make.right.equalTo(-10)
                            make.height.equalTo(height)
                        }
                        preView = imageView
                    case .label(let label):
                        self.addSubview(label)
                        label.snp.makeConstraints { make in
                            make.top.equalTo(preView.snp.bottom).offset(10)
                            make.left.equalTo(10)
                            make.right.equalTo(-10)
                        }
                        preView = label
                    case .audio:
                        break
                    case .video:
                        break
                    }
                } else { // bottom -- bottom
                    switch wrapper {
                    case .image(let imageView):
                        self.addSubview(imageView)
                        let height: CGFloat = imageView.image?.getImageHeight(width: UIScreen.main.bounds.size.width - 20) ?? .leastNonzeroMagnitude
                        imageView.snp.makeConstraints { make in
                            make.top.equalTo(preView.snp.bottom).offset(10)
                            make.left.equalTo(10)
                            make.right.equalTo(-10)
                            make.height.equalTo(height)
                            make.bottom.equalToSuperview().offset(-10)
                        }
                        preView = imageView
                    case .label(let label):
                        self.addSubview(label)
                        label.snp.makeConstraints { make in
                            make.top.equalTo(preView.snp.bottom).offset(10)
                            make.left.equalTo(10)
                            make.right.equalTo(-10)
                            make.bottom.equalToSuperview().offset(-10)
                        }
                        preView = label
                    case .audio:
                        break
                    case .video:
                        break
                    }
                }
            }
        }
        
        private func generateUILabel(text: String) -> UIViewWrapper {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .left
            label.lineBreakMode = .byCharWrapping
            label.textColor = .darkText
            label.font = .systemFont(ofSize: 17)
            label.text = text
            return UIViewWrapper.label(label)
        }
        
        private func generateUIImageView(image: UIImage) -> UIViewWrapper {
            let view = UIImageView()
            view.image = image
            view.contentMode = .scaleToFill
            return UIViewWrapper.image(view)
        }
    }
}
