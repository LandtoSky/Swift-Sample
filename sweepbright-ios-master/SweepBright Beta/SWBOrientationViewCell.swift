//
//  SWBOrientationViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/17/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import CoreLocation

let SWBHideOrientationCells = "BraceYourCells"

class SWBOrientationViewCellUnique {
    dynamic static var orientationCell: SWBOrientationViewCell? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(SWBHideOrientationCells, object: nil)
        }
    }
}

class SWBOrientationViewCell: UITableViewCell {
    var serviceDelegate: SWBRoomServiceDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        NSNotificationCenter.defaultCenter().addObserverForName(SWBHideOrientationCells, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            _ in
            UIView.animateWithDuration(0.5, animations: {
                if SWBOrientationViewCellUnique.orientationCell == self {
                    self.show()
                } else {
                    self.hide()
                }
            })
        })
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    var orientation: SWBOrientation = .N {
        didSet {
            self.setOrientationButton.setTitle("Set \(self.orientation.fullName())", forState: .Normal)
        }
    }

    var heading: CLHeading! {
        didSet {

            //Rotate the compass based on Magnetic north position
            let degrees = self.heading.trueHeading
            let radians = (degrees * M_PI/180) * -1.0
            self.compassImageView.transform = CGAffineTransformMakeRotation(CGFloat(radians))
        }
    }

    internal var orientationTypeEnum: SWBOrientationType! {
        return SWBOrientationType(rawValue: self.orientationType)
    }

    @IBInspectable var orientationType: String = ""

    var height: CGFloat = 0.0

    @IBOutlet weak var setOrientationButton: UIButton! {
        didSet {
            self.setOrientationButton.addTarget(self, action: #selector(SWBOrientationViewCell.setOrientation(_:)), forControlEvents: .TouchUpInside)
        }
    }
    @IBOutlet weak var compassImageView: UIImageView!

    func setOrientation(sender: UIButton) {
        self.serviceDelegate?.service.setOrientation((self.serviceDelegate?.serviceProperty.id)!, orientationType: self.orientationTypeEnum, orientation: self.orientation, completionHandler: nil)
        SWBOrientationViewCellUnique.orientationCell = nil
    }

    func hide() {
        self.height = 0
        self.hidden = true
    }
    func show() {
        self.height = 304.0
        self.hidden = false
    }

    func hideOrShow(completionHandler: (() -> Void)?) {
        UIView.animateWithDuration(0.5, animations: {
            //Hide the cell if it's collapsed
            self.hidden ? self.show() : self.hide()
            completionHandler?()
        })
    }
}
