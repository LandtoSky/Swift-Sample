//
//  SWBPastVisitClientView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/8/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBPastVisitClientView: UIView {
    class func loadFromNib() -> SWBPastVisitClientView {
        let nib = UINib(nibName: "SWBPastVisitClientView", bundle: nil)
        return nib.instantiateWithOwner(SWBPastVisitClientView.self, options: nil)[0] as! SWBPastVisitClientView
    }
}
