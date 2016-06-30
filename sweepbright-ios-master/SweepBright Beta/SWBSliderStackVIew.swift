//
//  SWBSliderStackVIew.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBIndexButton: UIButton, SWBElementWithIndex {
    @IBInspectable var index: Int = -1
}

class SWBSliderStackVIew: UIStackView {
    var titlesLabel: [String]!

    let coloursOrder = UIColor.getSliderArrayOfColours()

    @IBOutlet var slider: SWBColouredUISlider! {
        didSet {
            self.createButtons()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    func createButtons() {

        //Add custom buttons on the StackView
        for index in 0..<self.titlesLabel.count {

            //creating a button
            let btn = SWBIndexButton()
            btn.index = index
            btn.addTarget(self, action: #selector(SWBSliderStackVIew.indexButtonPressed(_:)), forControlEvents: .TouchUpInside)
            btn.setTitle(self.titlesLabel[index], forState: .Normal)
            btn.setTitleColor(self.coloursOrder[index], forState: .Normal)
            btn.titleLabel!.font = UIFont(name: "LFT Etica", size: 11.0)

            self.addArrangedSubview(btn)
        }
    }

    func initialize() {

        self.alignment = .Fill
        self.distribution = .FillEqually
        self.axis = .Horizontal

        self.titlesLabel = self.slider?.titlesLabel ?? []

        self.createButtons()
    }

    func updateLabels() {
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
        self.initialize()
        self.slider.updateValue()
    }

    func indexButtonPressed(button: SWBIndexButton) {
        //update the slider value
        if let slider = self.slider {
            slider.setValue(Float(button.index), animated: true)
            slider.sendActionsForControlEvents(.ValueChanged)
            slider.sendActionsForControlEvents([.TouchUpInside, .TouchUpOutside])
        }
    }

}
