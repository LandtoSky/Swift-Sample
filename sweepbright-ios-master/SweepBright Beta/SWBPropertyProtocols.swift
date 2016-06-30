//
//  SWBPropertyProtocols.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/7/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift

enum SWBPropertyNegotiation: String {
    case ForSale = "sale"
    case ToLet = "let"

    func title() -> String {
        switch self {
        case .ForSale:
            return "For Sale"
        case .ToLet:
            return "To Let"
        }
    }
}

enum SWBPropertyType: String {
    case House = "house"
    case Apartment = "apartment"
    case Parking = "parking"
    case Land = "land"
    case Retail = "retail"
    case Office = "office"
}

enum PropertySituation: String {
    case Match = "READY FOR MATCH", Close = "READY TO CLOSE", Publish = "READY FOR PUBLISH"
}


protocol SWBProperty: SWBJSONMapper {
    var id: String {get set}

    //Primitive
    var title: String { get set }
    var desc: String! {get set } //Description is reserved
    var created_at: NSDate {get set}
    var updated_at: NSDate {get set}
    var negotiation: String! { get set}
    var propertyType: String! {get set}

    //Ignored
    var situation: PropertySituation! {get set}
    var status: SWBPropertyNegotiation! { get set }
    var address: String { get }
    var type: SWBPropertyType! {get set}

    //Composition
    var images: [SWBPropertyImage]! { get set}
    var location: SWBPropertyLocationModel? { get set}
    var access: Access? { get set}
    var price: Price? {get set}
    var room: SWBPropertyRoomClass? {get set}
    var legalDocs: SWBLegalDocsModel? {get set}
    var features: SWBFeaturesModel? {get set}
    var settings: SWBPropertySettingsModel? {get set}
    var project: SWBProjectModel? {get set}

    //Functions
    func addImage(image: SWBPropertyImage)
    func removeImage(image: SWBPropertyImage)
    func removeImages(images: [SWBPropertyImage])
    func getImagesByVisibility(visibility: Visibility) -> [SWBPropertyImage]
}

extension SWBProperty {
    //This list will change based on the type of property
    var amenitiesAvailable: [SWBAmenity] {
        switch self.type! {
        case .House:
            return [.Pool, .Attic, .Basement,
                    .Terrace, .Garden, .Parking,
                    .Lift, .GuestHouse
            ]
        case .Apartment:
            return [.Pool, .Basement,
                    .Terrace, .Garden, .Parking,
                    .Lift
            ]
        case .Parking:
            return [.EletricalGate, .ManualGate,
                    .Fence, .RemoteControl, .KeyCard,
                    .Code, .Lift, .ClimateControl
            ]
        case .Land:
            return [.WaterAccess, .Fence, .UtilitiesAccess,
                    .SewerAccess, .Drainage, .RoadAccess
            ]
        default:
            return []
        }
    }
}
