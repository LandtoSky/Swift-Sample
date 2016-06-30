//
//  SWBAddButton.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/20/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBAddButton: UIButton {
    var label: UILabel!
    var titleText: String! {
        didSet {
            self.label.text = self.titleText
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .Left

        //Create new button labels
        let font = UIFont(name: "LFTEtica-Light", size: 17.0)
        self.label = UILabel()
        self.label.text = self.titleLabel?.text
        self.label.font = font
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textAlignment = .Center
        self.label.textColor = self.titleColorForState(.Normal)
        self.label.backgroundColor = UIColor.clearColor()

        let attributedStr = NSMutableAttributedString(string: self.label.text!)
        let range = NSMakeRange(0, attributedStr.length)
        attributedStr.addAttribute(NSKernAttributeName, value: 1.0, range: range)
        self.label.attributedText = attributedStr

        self.setTitleColor(UIColor.clearColor(), forState: .Normal)
        self.setTitle("", forState: .Normal)
        self.addSubview(label)

        //Add constraints
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
    }
}
