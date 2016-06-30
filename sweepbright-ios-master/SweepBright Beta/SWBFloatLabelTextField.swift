//
//  SWBFloatLabelTextField.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/21/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

@IBDesignable
class SWBFloatLabelTextField: JVFloatLabeledTextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.placeholderYPadding = 25
        self.floatingLabelYPadding = 9
        self.floatingLabelTextColor = UIColor.get706a7c()
    }

    let padding = UIEdgeInsets(top: 0, left: 4, bottom: 5, right: 0)

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
