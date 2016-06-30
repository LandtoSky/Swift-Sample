//
//  ButtonState.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/23/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class ButtonState: UIButton {
    @IBInspectable var disabledColor: UIColor = UIColor.clearColor()
    private var bgColorCopy: UIColor!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgColorCopy = self.backgroundColor
        self.rac_valuesForKeyPath("enabled", observer: nil).subscribeNext({ _ in
            self.backgroundColor = self.enabled ? self.bgColorCopy : self.disabledColor
        })
    }
}
