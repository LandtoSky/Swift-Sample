//
//  SWBOrientationProtocol.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/16/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

protocol SWBOrientationProtocol {
    var orientation: SWBOrientation? {get }
}

struct SWBOrientationModel: SWBOrientationProtocol {
    var orientation: SWBOrientation? {
        get {
            if let _ = self._orientation {
                return SWBOrientation(rawValue: self._orientation!)
            }
            return nil
        }
    }
    var _orientation: String? = nil

}
