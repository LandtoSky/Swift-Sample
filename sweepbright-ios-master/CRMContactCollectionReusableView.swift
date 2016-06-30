//
//  CRMContactCollectionReusableView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/15/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMContactCollectionReusableView: UICollectionReusableView, CRMContactDependent {
    var clientView: SWBClientViewCell!
    var contact: CRMContact! {
        didSet {
            self.clientView.contact = self.contact
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.clientView = SWBClientViewCell.loadFromNib()
        self.clientView.frame = self.bounds

        self.addSubview(self.clientView)
    }
}
