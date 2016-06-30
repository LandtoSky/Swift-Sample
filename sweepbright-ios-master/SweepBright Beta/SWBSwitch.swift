//
//  SWBSwitch.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/3/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SWBSwitch: UIView {
    @IBInspectable dynamic var checked: Bool = true {
        didSet {
            //add animation to hidde a view
            UIView.animateWithDuration(0.3, animations: {
                self.buttonOn.hidden = !self.checked
            })
        }
    }

    private dynamic var checkedWithObserver: Bool = true {
        didSet {
            self.checked = self.checkedWithObserver
        }
    }

    @IBInspectable dynamic var value: String = ""

    var on: Bool {
        return self.checked
    }

    @IBInspectable var onImage: UIImage! = UIImage(named: "onSwitch")! {
        didSet {
            self.buttonOn?.setImage(onImage, forState: .Normal)
        }
    }
    @IBInspectable var offImage: UIImage! = UIImage(named: "offSwitch")! {
        didSet {
            self.buttonOff?.setImage(offImage, forState: .Normal)
        }
    }

    internal var buttonOn: UIButton!
    internal var buttonOff: UIButton!

    func setOn(on: Bool) {
        self.checkedWithObserver = on
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    func initialize() {
        //Clean the bg
        self.backgroundColor = UIColor.clearColor()

        //Create on button
        self.buttonOn = UIButton(frame: self.bounds)
        self.buttonOn.setImage(onImage, forState: .Normal)
        self.buttonOn.addTarget(self, action: #selector(SWBSwitch.changeValue(_:)), forControlEvents: .TouchUpInside)

        //Create off button
        self.buttonOff = UIButton(frame: self.bounds)
        self.buttonOff.setImage(offImage, forState: .Normal)
        self.buttonOff.addTarget(self, action: #selector(SWBSwitch.changeValue(_:)), forControlEvents: .TouchUpInside)

        buttonOn.frame = self.bounds
        buttonOff.frame = self.bounds

        //Add buttons to view
        self.addSubview(buttonOff)
        self.addSubview(buttonOn)
    }

    internal func changeValue(sender: UIButton) {
        self.setOn(!self.checked)
    }
}

//MARK: ReactiveCocoa
extension SWBSwitch {
    func rac_valueChanged() -> RACSignal {
        return self.rac_valuesAndChangesForKeyPath("checkedWithObserver", options: .New, observer: self)
    }

    func rac_checked() -> RACSignal {
        return self.rac_valuesForKeyPath("checkedWithObserver", observer: self)
    }
}
