//
//  SWBFloorPlanCollectionViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/20/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBFloorPlanCollectionViewCell: UICollectionViewCell {

    var plan: SWBPlan! {
        didSet {
            self.imageView.image = self.plan.image
        }
    }

    @IBOutlet weak var imageView: UIImageView!
}
