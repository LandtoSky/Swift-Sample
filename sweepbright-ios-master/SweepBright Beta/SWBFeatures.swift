//
//  SWBFeatures.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/24/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

private let SEPARATOR = ", "

//MARK:Protocols
protocol SWBFeatures: class, SWBJSONMapper, SWBRealmRequired {
    var id: String {get set}
    var kitchen: SWBGeneralCondition {get set}
    var bathroom: SWBGeneralCondition {get set}
    var property: SWBPropertyModel? {get}
    var features: String {get set}
    var listOfFeatures: [SWBFeature] {get set}

    var architect: String? {get set}
    var yearBuilt: RealmOptional<Int> {get set}
    var renovationDetails: String? {get set}
    var yearRenovated: RealmOptional<Int> {get set}

    func addOrRemove(feature: SWBFeature) -> SWBAddOrRemove
}

//MARK: Enums

enum SWBAddOrRemove: Int {
    case Add = 1
    case Remove = 0
}

enum SWBFeatureGroup: String {
    case Comfort = "comfort"
    case Eco = "ecology"
    case EnergySource = "energy"
    case Security = "security"
    case HC = "heating_cooling"
    case Permissions = "permissions"
    case None = ""
}

enum SWBFeature: String {

    //Comfort
    case HomeAutomation = "home_automation"
    case WaterSoftener = "water_softener"
    case Fireplace = "fireplace"
    case WalkInCloset = "walk_in_closet"
    case HomeCinema = "home_cinema"
    case WineCellar = "wine_cellar"
    case Sauna = "sauna"
    case FitnessRoom = "fitness_room"

    //ECO
    case DoubleGlazing = "double_glazing"
    case SolarPanels = "solar_panels"
    case SolarBoiler = "solar_boiler"
    case RainwaterHarvesting = "rainwater_harvesting"

    //HC
    case CentralHeating = "central_heating"
    case FloorHeating = "floor_heating"
    case AirConditioning = "air_conditioning"

    //Energy
    case Gas = "gas"
    case Fuel = "fuel"
    case Electricity = "electricity"

    //Security
    case Alarm = "alarm"
    case Concierge = "concierge"
    case VideoSurveillance = "video_surveillance"

    //Permissions
    case Construction = "construction"
    case Planning = "planning"
    case Farming = "farming"
    case Fishing = "fishing"

    func title() -> String {
        return self.rawValue.stringByReplacingOccurrencesOfString("_", withString: " ").capitalizedString
    }
}

//MARK: Extensions

extension SWBFeatures {
    private func mapJson(json: JSON) -> String {
        return json.dictionaryValue.filter({$1.boolValue}).map({$0.0}).joinWithSeparator(SEPARATOR)
    }
    func initWithJSON(json: JSON) {
        self.id = self.property?.id ?? NSUUID().UUIDString.lowercaseString
        let conditions = json["conditions"]
        self.kitchen = SWBGeneralCondition(rawValue: conditions["kitchen"].stringValue) ?? .Good
        self.bathroom = SWBGeneralCondition(rawValue: conditions["bathroom"].stringValue) ?? .Good

        let featuresJson = json["features"]

        let comfort = self.mapJson(featuresJson["comfort"])
        let ecology = self.mapJson(featuresJson["ecology"])
        let energy = self.mapJson(featuresJson["energy"])
        let hc = self.mapJson(featuresJson["heating_cooling"])
        let security = self.mapJson(featuresJson["security"])
        let permissions = self.mapJson(json["permissions"])

        self.features = [comfort, ecology, hc, security, energy, permissions].joinWithSeparator(SEPARATOR)

        self.architect = json["building", "construction", "architect"].string
        self.yearBuilt.value = json["building", "construction", "year"].int
        self.renovationDetails = json["building", "renovation", "description"].string
        self.yearRenovated.value = json["building", "renovation", "year"].int

    }
    func toJSON() -> [String : AnyObject] {
        return [:]
    }
}


//MARK: Classes
class SWBFeaturesModel: Object, SWBFeatures {
    dynamic var id: String = NSUUID().UUIDString.lowercaseString
    dynamic var property: SWBPropertyModel?
    dynamic var _kitchen: String = "good"

    dynamic var architect: String?
    var yearBuilt = RealmOptional<Int>()
    dynamic var renovationDetails: String?
    var yearRenovated = RealmOptional<Int>()

    override static func primaryKey() -> String? {
        return "id"
    }

    //The features will be stored as string like "home_automation, fireplace, solar_panels"
    dynamic var features: String = ""

    var listOfFeatures: [SWBFeature] {
        get {
            //The string will be converted into an array of SWBFeatures like [HomeAutomation, FirePlace, SolarPanels]
            return self.features.componentsSeparatedByString(SEPARATOR).filter({SWBFeature(rawValue:$0) != nil}).map({SWBFeature(rawValue: $0)!})
        }set(newValue) {
            //Will update the featuers string
            self.features = newValue.map({$0.rawValue}).joinWithSeparator(SEPARATOR)
        }
    }

    var kitchen: SWBGeneralCondition {
        get {
            return SWBGeneralCondition(rawValue: self._kitchen) ?? .Good
        }set (newValue) {
            self._kitchen = newValue.rawValue
        }
    }

    dynamic var _bathroom: String = "good"
    var bathroom: SWBGeneralCondition {
        get {
            return SWBGeneralCondition(rawValue: self._bathroom) ?? .Good
        }set (newValue) {
            self._bathroom = newValue.rawValue
        }
    }

    func addOrRemove(feature: SWBFeature) -> SWBAddOrRemove {
        var list = self.listOfFeatures
        var action: SWBAddOrRemove!

        if let index = list.indexOf(feature) {
            list.removeAtIndex(index)
            action = .Remove
        } else {
            list.append(feature)
            action = .Add
        }

        self.listOfFeatures = list
        return action
    }
}
