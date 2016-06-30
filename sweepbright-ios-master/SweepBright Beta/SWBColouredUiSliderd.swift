//
//  SWBColouredUiSliderd.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/6/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBColouredUISlider: UISlider {

    var titlesLabel: [String] = ["Poor", "Fair", "Good", "Mint", "New"] {
        didSet {
            self.sliderLabels?.updateLabels()
        }
    }

    @IBOutlet weak var sliderLabels: SWBSliderStackVIew? {
        didSet {
            self.sliderLabels?.updateLabels()
        }
    }
    let coloursOrder = UIColor.getSliderArrayOfColours()
    @IBOutlet weak var label: UILabel! {
        didSet {
            self.updateValue()
        }
    }
    @IBOutlet weak var image: UIImageView!
    @IBInspectable var imagePrefix: String!

    //This closure will be called after the user stop sliding or press in one of the buttons
    var afterUpdate:(()->()) {
        return {

        }
    }

    func initialize() {
        self.maximumValue = Float(self.titlesLabel.count - 1)
        self.minimumValue = 0.0
        self.continuous = true

        //Add image with stepper
        let imageView = UIImageView(image: UIImage(named: "slider-bar"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        self.maximumTrackTintColor = UIColor.clearColor()
        self.minimumTrackTintColor = UIColor.clearColor()

        //Add imageView constratins
        self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 10.0))

        self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))

        //Send the request to the server when the user stop the sliding
        self.rac_signalForControlEvents([.TouchUpInside, .TouchUpOutside]).subscribeNext({
            _ in
            self.afterUpdate()
        })

        //Create a signal for everytime the value changes
        self.rac_signalForControlEvents(.ValueChanged).subscribeNext({
            newValue in
            self.updateValue()
        })

        self.sliderLabels?.updateLabels()

        //Update items on initialize
        self.sendActionsForControlEvents(.ValueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    override init(frame: CGRect) {
        super.init(frame:frame)

        self.initialize()
    }

    internal func updateValue() {
        //Avoid float value
        self.value = Float(Int(self.value + 0.5))

        //Get the correct index
        let index = Int(self.value)

        //Update colours
        let newColour = self.coloursOrder[index]
        self.thumbTintColor = newColour

        //Update the label text
        if let _ = self.label {
            self.label.textColor = newColour
            self.label.text = self.titlesLabel[index]
        }
        self.refreshImage()
    }

    func refreshImage() {
        //Get the correct index
        let index = Int(self.value)
        let newColour = self.coloursOrder[index]

        let icon = UIImage(named: "\(self.imagePrefix)-\(index)")
        self.image?.tintColor = newColour
        self.image?.image =  icon?.imageWithRenderingMode(.AlwaysTemplate)
    }
}
