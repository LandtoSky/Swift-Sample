//
//  Property.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 24/11/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class SWBPropertyModel: Object, SWBProperty {

    dynamic var id = NSUUID().UUIDString.lowercaseString

    //Primitive
    dynamic var title: String = ""
    dynamic var desc: String! //Description is reserve
    dynamic var created_at: NSDate = NSDate()
    dynamic var updated_at: NSDate = NSDate()
    dynamic internal var negotiation: String! = "sale"
    dynamic internal var propertyType: String! = "house"

    //Ignored
    var situation: PropertySituation! = .Publish
    var status: SWBPropertyNegotiation! {
        get {
            return SWBPropertyNegotiation(rawValue: self.negotiation)
        }
        set (newValue) {
            self.negotiation = newValue.rawValue
        }
    }

    var address: String {
        //Ex. London, Baker Street 221B.
        //Ex. Baker Street 221B.
        let city = self.location?.city ?? ""
        return "\(city.isEmpty ? "": "\(city), ")\(self.location?.street ?? "") \(self.location?.nr ?? "")"
    }
    var type: SWBPropertyType! {
        get {
            return SWBPropertyType(rawValue: self.propertyType)
        }
        set(newValue) {
            self.propertyType = newValue.rawValue
        }
    }

    //Composition
    var images: [SWBPropertyImage]! = []
    dynamic var location: SWBPropertyLocationModel?
    dynamic var access: Access? = Access()
    dynamic var price: Price? = Price()
    dynamic var room: SWBPropertyRoomClass? = SWBPropertyRoomClass()
    dynamic var project: SWBProjectModel?
    dynamic var legalDocs: SWBLegalDocsModel? = SWBLegalDocsModel()
    dynamic var features: SWBFeaturesModel? = SWBFeaturesModel()
    dynamic var settings: SWBPropertySettingsModel? = SWBPropertySettingsModel()

    func getImagesByVisibility(visibility: Visibility) -> [SWBPropertyImage] {
        //Filter the images by visibility
        return self.images.filter({
            image in
            return image.visibility == visibility})
    }

    func addImage(image: SWBPropertyImage) {
        //Append an image into Images array
        self.images.append(image)
    }

    func removeImage(image: SWBPropertyImage) {
        //Get the index of image on array
        let index = self.images.map({ $0 as! PropertyImage}).indexOf(image as! PropertyImage)

        //If Image is inside the array, remove it
        if index > -1 {
            self.images.removeAtIndex(index!)
        }
    }

    func removeImages(images: [SWBPropertyImage]) {
        //Shortcut to remove an array of images
        for image in images {
            self.removeImage(image)
        }
    }
}

//JSONMapper
extension SWBPropertyModel {
    func initWithJSON(json: JSON) {
        self.id = json["id"].stringValue.lowercaseString
        self.negotiation = json["negotiation"].stringValue
        self.propertyType = json["type"].stringValue
        self.created_at = json["created_at"].dateTime ?? NSDate()
        self.updated_at = json["updated_at"].dateTime ?? NSDate()

        //Description
        let attributes: JSON = json["attributes"]

        self.title = json["attributes", "description", "title"].stringValue
        self.desc = json["attributes", "description", "description"].string

        //Location
        self.location = SWBPropertyLocationModel()
        self.location!.id = self.id
        self.location!.initWithJSON(attributes["location"])

        //Rooms
        self.room = SWBPropertyRoomClass()
        self.room?.property = self
        self.room?.initWithJSON(attributes)

        self.price = Price()
        self.price?.property = self
        self.price?.initWithJSON(attributes)

        self.legalDocs = SWBLegalDocsModel()
        self.legalDocs?.property = self
        self.legalDocs?.initWithJSON(attributes)

        self.features = SWBFeaturesModel()
        self.features?.property = self
        self.features?.initWithJSON(attributes)

        self.access = Access()
        self.access?.property = self
        self.access?.initWithJSON(attributes)

        self.settings = SWBPropertySettingsModel()
        self.settings?.property = self
        self.settings?.initWithJSON(attributes)

        if json["properties", "data"].exists() {
            self.project = SWBProjectModel(value: ["id": self.id])
            self.project?.property = self
        }
    }
}

//Realm
extension SWBPropertyModel {

    override static func ignoredProperties() -> [String] {
        return ["situation", "status", "address", "images", "location", "units", "type"]
    }

    override class func primaryKey() -> String {
        return "id"
    }
}
