//
//  SWBRoomStepper.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/22/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SWBRoomsStepper: SWBYearStepper {
    @IBInspectable var type: String = ""
    var serviceDelegate: SWBRoomServiceDelegate!

    var structure: SWBStructure! {
        return SWBStructure(rawValue:self.type)
    }
    private dynamic var numberOfRooms: Int = 0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    func initialize() {
        self.valueChangeBlock = {
            self.serviceDelegate?.service.setTotalOfRooms((self.serviceDelegate?.serviceProperty.id)!, withType: self.structure, total: self.value, completionHandler: {
                dispatch_async(dispatch_get_main_queue(), {
                    self.numberOfRooms = self.value
                })
            })
        }
    }

    override func rac_valueChanged() -> RACSignal {
        return self.rac_valuesAndChangesForKeyPath("numberOfRooms", options: .New, observer: self)
    }
}
