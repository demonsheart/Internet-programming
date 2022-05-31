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
    
    // YPVideoView
    @IBOutlet weak var videoView: YPVideoView!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func prepareForReuse() {
        saveCallBack?(model)
        super.prepareForReuse()
    }
    
    func prepareVideo(model: MomentVideoItem) {
        self.model = model
        videoView.setPreviewImage(model.thumbnail)
        if let ur = URL(string: model.url) {
            videoView.loadVideo(ur)
        } else {
            print("invalid url")
        }
    }
    
    @IBAction func deleteCell(_ sender: UIButton) {
        videoView.deallocate()
        deleteCallBack?()
    }
    
}
