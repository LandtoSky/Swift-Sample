//
//  PropertyImageViewCell.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 11/25/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

class PropertyImageViewCell: UICollectionViewCell {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var checkLabel: UILabel!

    var image: SWBPropertyImage! {
        didSet {
            if let propertyImage = image.image {
                self.imageview.image = propertyImage
                self.imageview.hidden = false
            } else {
                self.imageview.hidden = true
            }

        }
    }
}
