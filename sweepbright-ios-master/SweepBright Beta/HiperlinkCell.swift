//
//  HiperlinkCell.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 12/3/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

class HiperlinkCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var link: Hiperlink? {
        didSet {
            self.icon.image = UIImage(named: self.link!.icon)
            self.nameLabel.text = self.link!.name

            //Disable interaction if it doesn't have a segue
            self.userInteractionEnabled = (self.link!.segue != nil)
            self.alpha = self.userInteractionEnabled ? 1.0 : 0.5

        }
    }
}
