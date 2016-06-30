//
//  SWBVisitClientView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/8/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBVisitClientView: UIView {
    class func loadFromNib() -> SWBVisitClientView {
        let nib = UINib(nibName: "SWBVisitClientView", bundle: nil)
        return nib.instantiateWithOwner(SWBVisitClientView.self, options: nil)[0] as! SWBVisitClientView
    }
}
