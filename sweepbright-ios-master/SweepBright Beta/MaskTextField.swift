//
//  MaskTextField.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/23/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class MaskTextField: UITextField {

    let numberFormatter = NSNumberFormatter()

    var numberValue: NSNumber = 0 {
        didSet {
            //Update the text
            self.textHasChanged()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initializer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializer()
    }

    internal func initializer() {
        self.delegate = self

        //Configure the UI
        self.borderStyle = .None
        self.keyboardType = .NumberPad

        //Define numberFormatter type
        self.numberFormatter.numberStyle = .CurrencyAccountingStyle
        self.numberFormatter.currencySymbol = ""

        //Add observer to text changes
        self.rac_textSignal().subscribeNext({
            _ in

            //Remove symbol, commas and dots from the string
            let text = self.text!.stringByReplacingOccurrencesOfString(self.numberFormatter.currencySymbol, withString: "").stringByReplacingOccurrencesOfString(self.numberFormatter.groupingSeparator, withString: "").stringByReplacingOccurrencesOfString(self.numberFormatter.decimalSeparator, withString: "")

            //Convert the clean text
            self.numberValue = (text as NSString).doubleValue / 100.0
        })
        self.numberValue = 0
    }

    func textHasChanged() {
        //Change the text with the correct format
        self.text = self.numberFormatter.stringFromNumber(self.numberValue)
        self.selectedTextRange = self.textRangeFromPosition(self.endOfDocument, toPosition: self.endOfDocument)
    }
}

extension MaskTextField: UITextFieldDelegate {

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.selectedTextRange = self.textRangeFromPosition(self.endOfDocument, toPosition: self.endOfDocument)
        return true
    }
}
