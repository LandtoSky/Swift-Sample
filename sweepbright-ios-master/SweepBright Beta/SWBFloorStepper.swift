//
//  SWBFloorStepper.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/23/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBFloorStepper: SWBYearStepper {

    var serviceDelegate: SWBRoomServiceDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    var completionHandler:()->() = {}

    func initialize() {
        //Whenever the value change, this element will add a request in the service queue to sync the information on the server
        self.valueChangeBlock = {
            self.serviceDelegate?.service.setNumberOfFloors(self.serviceDelegate.serviceProperty.id, numberOfFloors: self.value)
        }
    }
}
