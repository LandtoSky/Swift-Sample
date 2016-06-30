//
//  CounterLabel.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/23/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

class SWBColouredLabel: UILabel {

    @IBInspectable var normalColor: UIColor = UIColor.blackColor()
    @IBInspectable var negativeColor: UIColor = UIColor.redColor()

    @IBInspectable var maxCharacters: Int = 140 {
        didSet {
            //Update counter
            self.counter = self.maxCharacters - self.currentCounter
        }
    }

    var currentCounter: Int = 0 {
        didSet {
            //Update counter
            self.counter = self.maxCharacters - self.currentCounter
        }
    }
    private var counter: Int = 0 {
        didSet {
            self.updateText(self.counter)
        }
    }

    func updateText(counter: Int) {

        //Set color based on counter
        self.textColor = (counter >= 0) ? self.normalColor : self.negativeColor
    }

    func getCounter() -> Int {
        //Return Counter
        return self.counter
    }
}

class SWBNotEmptyLabel: SWBColouredLabel {

    override func updateText(counter: Int) {
        //Set color based on counter
        self.textColor = (self.currentCounter > 0) ? self.normalColor : self.negativeColor
    }
}

class CounterLabel: SWBColouredLabel {

    override func updateText(counter: Int) {
        self.text = "\(counter)"

        //Set color based on counter
        self.textColor = (counter >= 0) ? self.normalColor : self.negativeColor
    }
}
class TextViewCounterLabel: SWBColouredLabel {
    @IBOutlet var textview: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textview?.rac_textSignal().subscribeNext({
            _ in
            self.currentCounter = self.textview.text.characters.count
        })
    }
    override func updateText(counter: Int) {
        self.text = "\(counter)"

        //Set color based on counter
        self.textColor = (counter >= 0) ? self.normalColor : self.negativeColor
    }
}
