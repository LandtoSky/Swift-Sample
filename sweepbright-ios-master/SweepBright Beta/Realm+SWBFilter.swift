//
//  Realm+SWBFilter.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/14/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

import RealmSwift

extension Results {
    func filter(filter: SWBFilter) -> Results {
        var result = self

        //Filter per negotiation
        if let negotiation = filter.negotiation {
            result = self.filter(NSPredicate(format: "negotiation == %@", negotiation.rawValue))
        }

        // filter per property type
        result = result.filter(NSPredicate(format: "propertyType IN %@", filter.propertyTypes.map({$0.rawValue})))

        return result
    }
}
