//
//  SWBOwnerFeedbackView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/7/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBOwnerFeedbackView: UIView {

    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!

    class func loadFromNib() -> SWBOwnerFeedbackView {
        let nib = UINib(nibName: "SWBOwnerFeedback", bundle: nil)
        return nib.instantiateWithOwner(SWBOwnerFeedbackView.self, options: nil)[0] as! SWBOwnerFeedbackView
    }
}
