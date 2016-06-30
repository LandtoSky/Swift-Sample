//
//  SWBGeneralConditionSlider.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift

class SWBGeneralConditionSlider: SWBColouredUISlider {
    var roomDelegate: SWBRoomServiceDelegate!
    var conditions: [SWBGeneralCondition] = [.Poor, .Fair, .Good, .Mint, .New]

    override var afterUpdate:(()->()) {
        return {
            //Show alert
            AlertFactory.loadingTopBarMessage("Updating general condition", dismissAfter: 1.0)
        self.roomDelegate?.service.setGeneralCondition( self.roomDelegate.serviceProperty.id, generalCondition: self.getCondition())

        }
    }

    func getCondition() -> SWBGeneralCondition {
        //Convert slider value into SWBGeneralCondition
        return self.conditions[Int(self.value)]
    }

    func setCondition(condition: SWBGeneralCondition, sync: Bool = true) {
        //Set the value based on a SWBGeneralCondition
        let index = self.conditions.indexOf(condition)
        self.value = Float(index!)
        self.updateValue()
        if sync {
            self.afterUpdate()
        }
    }
}

class SWBGenericGeneralConditionSlider: SWBGeneralConditionSlider {
    @IBInspectable var key: String = ""
    var conditionType: SWBConditionType? {
        return SWBConditionType(rawValue: self.key)
    }
    var delegate: SWBFeaturesServiceDelegate?

    override var afterUpdate: (() -> ()) {
        return {
            AlertFactory.loadingTopBarMessage("Updating \(self.key)", dismissAfter: 1.0)
            (self.delegate?.service)?.setCondition(onProperty: (self.delegate?.property)!, condition: self.conditionType!, value: self.getCondition())
        }
    }
}
