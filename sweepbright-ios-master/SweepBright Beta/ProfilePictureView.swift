//
//  ProfilePictureView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/2/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ProfilePictureView: UIView {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    private var uploadDisposable: RACDisposable?

    var uploadProgress: PhotoUploadProgress? {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                if let _ = self.uploadProgress {
                    self.showUploadProgress()
                } else {
                    self.downloadImage()
                }
            })
        }
    }
    /**
     Show upload progress.
     During the uploading, the image that'l being uploaded will be showed on the screen.
     */
    private func showUploadProgress() {
        let upload = self.uploadProgress!
        self.imageView.image = upload.image
        self.progressView.hidden = false

        self.uploadDisposable = upload.progressChanged()?.subscribeNext({ _ in
            let progress = Float(upload.progress)
            self.progressView.setProgress(progress, animated: true)
            self.progressView.hidden = (progress == 0 || progress >= 1.0)
        })
    }
    /**
     Get the image in the cache system and show on the screen
     */
    private func downloadImage() {
        self.progressView.hidden = true
        self.imageView.image = UIImage()

        if let imageUrl = (self.profile?.photo?.medium_url) {
            SWBImageCache.get(withKey: imageUrl, image: { image in
                self.imageView.image = image
            })
        }
    }

    var profile: ProfileObject? {
        didSet {
            self.imageView.image = UIImage()
            self.labelText?.text = self.profile?.abbreviation
            self.uploadProgress = self.profile?.uploadProgress
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view =
            NSBundle.mainBundle().loadNibNamed("ProfilePictureView", owner: self, options: nil).first as! UIView
        view.frame = self.bounds
        let radius = self.bounds.height/2
        view.layer.cornerRadius = radius
        self.imageView.layer.cornerRadius = radius
        self.labelText.font = self.labelText.font.fontWithSize(17.0)
        self.addSubview(view)
    }

    deinit {
        self.uploadDisposable?.dispose()
    }
}

protocol ProfileObject {
    var abbreviation: String {get}
    var photo: CRMContactPhoto? {get}
    var uploadProgress: PhotoUploadProgress? {get}
}
extension CRMContact: ProfileObject {
    var uploadProgress: PhotoUploadProgress? {
        return PhotoUploader.getProgress(byContact: self)
    }
}
