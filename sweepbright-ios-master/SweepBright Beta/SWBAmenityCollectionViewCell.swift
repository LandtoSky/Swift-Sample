//
//  SWBAmenitieCollectionViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/12/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBAmenityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textAmenity: UILabel!
    @IBOutlet weak var selectedSwitch: SWBSwitch!

    var amenity: SWBAmenity! {
        didSet {
            self.imageView?.image = amenity.icon
            self.textAmenity.text = amenity.title
        }
    }
}
