//
//  CRMContactImageCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/30/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMContactImageCell: UITableViewCell, CRMContactDependent {
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var addPhotoButtonView: UIView!
    @IBOutlet var removePhotoButtonView: UIView!
    @IBOutlet var profileImage: ProfilePictureView!
    @IBOutlet var viewController: UIViewController?
    var uploadProgress: PhotoUploadProgress? {
        didSet {
            self.profileImage.uploadProgress = self.uploadProgress
        }
    }

    //When this attribute changes, the cell will be updated
    private var contactPhoto: UIImage? {
        didSet {
            self.profileImage.imageView.image = self.contactPhoto
            //Show buttons based on the contact image
            if let _ = self.contactPhoto {
                self.removePhotoButtonView.hidden = false
                self.addPhotoButtonView.hidden = true
                let formatter = NSDateFormatter()
                formatter.dateStyle = .MediumStyle
                self.detailsLabel.text = "Updated \(formatter.stringFromDate(NSDate()))"
            } else {
                self.addPhotoButtonView.hidden = false
                self.removePhotoButtonView.hidden = true
                self.detailsLabel.text = ""
            }
        }
    }

    var contact: CRMContact! {
        didSet {
            self.contactPhoto = nil
            self.profileImage.profile = self.contact
        }
    }

    func removePhoto() {
        self.contactPhoto = nil
    }

    func addPhoto(image: UIImage!) {
        self.contactPhoto = image
    }
}
