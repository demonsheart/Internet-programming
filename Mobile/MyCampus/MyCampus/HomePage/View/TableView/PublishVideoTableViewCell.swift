//
//  PublishVideoTableViewCell.swift
//  MyCampus
//
//  Created by aicoin on 2022/5/31.
//

import UIKit
import YPImagePicker

class PublishVideoTableViewCell: UITableViewCell, SaveBeforeReuse {
    
    var deleteCallBack: (() -> Void)?
    
    var saveCallBack: ((MomentVideoItem?) -> Void)?
    
    var model: MomentVideoItem? = nil
    
    var isRendered = false
    
    // YPVideoView
    @IBOutlet weak var videoView: YPVideoView!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.backgroundColor = CPColor.bgGray
    }
    
    override func prepareForReuse() {
        saveCallBack?(model)
        super.prepareForReuse()
    }
    
    func prepareVideo(model: MomentVideoItem) {
        if isRendered { return }
        self.model = model
        videoView.setPreviewImage(model.thumbnail)
        height.constant = model.thumbnail.getImageHeight(width: UIScreen.main.bounds.size.width - 20)
        if let ur = URL(string: model.url) {
            videoView.loadVideo(ur)
        } else {
            print("invalid url")
        }
        isRendered = true
    }
    
    @IBAction func deleteCell(_ sender: UIButton) {
        videoView.deallocate()
        deleteCallBack?()
    }
    
}
