//
//  SWBDateButton.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/30/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import ReactiveCocoa

class SWBDateButton: UIButton {
    var dateFormatter: NSDateFormatter!
    @IBInspectable var defaultText: String = ""
    dynamic var date: NSDate? {
        didSet {
            if let newDate = self.date {
                self.setTitle(self.dateFormatter.stringFromDate(newDate), forState: .Normal)
            } else {
                self.setTitle(self.defaultText, forState: .Normal)
            }
        }
    }

    func initialize() {
        self.addTarget(self, action: #selector(SWBDateButton.showDatePicker), forControlEvents: .TouchUpInside)
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateStyle = .MediumStyle
        self.dateFormatter.timeStyle = .NoStyle
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    override init(frame: CGRect) {
        super.init(frame:frame)
        self.initialize()
    }

    func showDatePicker() {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, forEvent:nil)
        let datePicker = ActionSheetDatePicker(title: "Select a date", datePickerMode: .Date, selectedDate: self.date ?? NSDate(), doneBlock: {
            _, newDate, _ in
                self.date = newDate as? NSDate
            }, cancelBlock: {
                _ in
            }, origin: self)

        datePicker.showActionSheetPicker()
    }
}

extension SWBDateButton {
    var rac_dateChanged: RACSignal {
        return self.rac_valuesAndChangesForKeyPath("date", options: .New, observer: self)
    }
}
