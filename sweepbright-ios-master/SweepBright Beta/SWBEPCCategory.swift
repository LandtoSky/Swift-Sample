//
//  SWBEPCCategory.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import ActionSheetPicker_3_0
import ReactiveCocoa

enum EPCCategory: String {
    case A = "A"
    case B, C, D, E, F, G
}

class SWBEPCCategory: UIButton {
    @IBInspectable var defaultText: String = ""
    dynamic internal var category: String = "" {
        didSet {
            self.setTitle(self.category, forState: .Normal)
        }
    }

    var epcCategory: EPCCategory? {
        return EPCCategory(rawValue: self.category)
    }

    func initialize() {
        self.addTarget(self, action: #selector(SWBDateButton.showDatePicker), forControlEvents: .TouchUpInside)
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
        let categories: [String] = ["A", "B", "C", "D", "E", "F", "G"]
        let sheet = ActionSheetStringPicker(title: "Select an EPC", rows: categories, initialSelection: 0, doneBlock: { _, newCategory, text in
                if let text = text as? String {
                    self.category = text
                }
            }, cancelBlock: { _ in

            }, origin: self)
        sheet.showActionSheetPicker()
    }
}

extension SWBEPCCategory {
    var rac_newCategory: RACSignal {
        return self.rac_valuesAndChangesForKeyPath("category", options: .New, observer: self)
    }
}
