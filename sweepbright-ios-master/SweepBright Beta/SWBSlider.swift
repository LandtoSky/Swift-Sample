//
//  SWBSlider.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/29/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBSlider: UIView {
    @IBOutlet weak var slider: SWBGenericGeneralConditionSlider!
    @IBInspectable var key: String = "" {
        didSet {
            self.slider?.key = self.key
        }
    }
    @IBInspectable var imagePrefix: String = "" {
        didSet {
            self.slider?.imagePrefix = self.imagePrefix
            self.slider.refreshImage()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    var sliderLabels: SWBSliderStackVIew? {
        return self.slider.sliderLabels
    }

    func initialize() {
        //A reusable SWBSlider loaded from SWBSlider.nib file.
        let view = NSBundle.mainBundle().loadNibNamed("SWBSlider", owner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)

        //Variables necessary for the slider
        self.slider.imagePrefix = self.imagePrefix
        self.slider?.key = self.key

        self.sliderLabels?.updateLabels()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

}

class SWBFeedbackSlider: SWBSlider {
    let titleLabels = ["No Interest", "Info", "Visit", "Bid", "Deal"]
    override func initialize() {
        super.initialize()
        self.slider.titlesLabel = self.titleLabels
        self.sliderLabels?.updateLabels()
    }
}
