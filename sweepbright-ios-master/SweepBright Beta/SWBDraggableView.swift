//
//  SWBDraggableView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/12/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBDraggableView: UIView {
    //Content loaded from SWBDraggableView.xib
    var image: SWBPropertyImage? {
        didSet {
            self.imageView?.image = self.image?.image
        }
    }
    @IBOutlet weak var imageView: UIImageView!
}
