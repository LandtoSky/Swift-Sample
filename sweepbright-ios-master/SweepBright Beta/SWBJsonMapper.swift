//
//  SWBJsonMapper.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/9/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol SWBJSONMapper {
    func initWithJSON(json: JSON)
    func toJSON() -> [String: AnyObject]
}

extension SWBJSONMapper {
    func toJSON() -> [String: AnyObject] {
        return [:]
    }
}
