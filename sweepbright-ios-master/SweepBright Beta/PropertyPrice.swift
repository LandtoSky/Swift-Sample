//
//  PropertyPrice.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

enum SWBCurrency: String {
    case EUR = "EUR"
    case GBP = "GBP"
}

protocol SWBPrice: SWBJSONMapper, SWBRealmRequired {
    var value: Float { get set }
    var costs: String { get set }
    var taxes: String { get set }
    var currency: SWBCurrency {get set}
    var property: SWBPropertyModel? {get set}
}

extension SWBPrice {
    var valueFormated: String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.currencySymbol = ""
        return formatter.stringFromNumber(self.value) ?? "\(self.value)"
    }

}

//Price
class Price: Object, SWBPrice {
    dynamic var id: String = NSUUID().UUIDString.lowercaseString
    dynamic var value: Float = 0.0
    dynamic var costs: String = ""
    dynamic var taxes: String = ""
    dynamic var property: SWBPropertyModel?

    var currency: SWBCurrency {
        get {
            return SWBCurrency(rawValue: self._currency) ?? .EUR
        }set (newValue) {
            self._currency = newValue.rawValue
        }
    }

    dynamic internal var _currency: String = "EUR"

    override static func primaryKey() -> String? {
        return "id"
    }

    func initWithJSON(json: JSON) {
        let jsonPrice: JSON = json["price"]
        self.id = self.property?.id ?? NSUUID().UUIDString.lowercaseString
        self.costs = jsonPrice["costs"].stringValue
        self.taxes = jsonPrice["taxes"].stringValue
        self.value = jsonPrice["published_price", "amount"].floatValue
        self._currency = jsonPrice["published_price", "currency"].stringValue
    }
}
