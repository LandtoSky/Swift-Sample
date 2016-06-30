//
//  SWBFeaturesService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/24/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

enum SWBConditionType: String {
    case Bathroom = "bathroom"
    case Kitchen = "kitchen"
}

protocol SWBFeaturesServiceProtocol: SWBService {
    func setCondition(onProperty property: SWBProperty, condition: SWBConditionType, value: SWBGeneralCondition)
    func syncFeatures(onProperty property: SWBProperty, onTheGroup group: SWBFeatureGroup, value: SWBFeature)
    func syncArchitect(onProperty property: SWBProperty, architect: String)
    func syncYearBuilt(onProperty property: SWBProperty, year: Int)
    func syncYearRenovated(onProperty property: SWBProperty, year: Int)
    func syncRenovationDetails(onProperty property: SWBProperty, details: String)
    var completionHandler: (Response<AnyObject, NSError> -> Void)? {get set}
}

extension SWBFeaturesServiceProtocol {
    func setCondition(onProperty property: SWBProperty, condition: SWBConditionType, value: SWBGeneralCondition) {
        AlertFactory.loadingTopBarMessage("Sync condition", dismissAfter: 1.0)

        let realm = try! Realm()
        let propertyModel = realm.objectForPrimaryKey(SWBPropertyModel.self, key: property.id)
        try! realm.write({
            propertyModel?.features?.setValue(value.rawValue, forKey: "_\(condition.rawValue)")
        })

        //Send request
        self.setValueForProperty(property.id, op:"add", path: "/conditions/\(condition.rawValue)", value: value.rawValue, completionHandler: self.completionHandler)
    }

    func syncFeatures(onProperty property: SWBProperty, onTheGroup group: SWBFeatureGroup, value: SWBFeature) {
        AlertFactory.loadingTopBarMessage("Sync features", dismissAfter: 1.0)

        let realm = try! Realm()
        var addedOrRemoved: SWBAddOrRemove!
        try! realm.write({
            addedOrRemoved = property.features?.addOrRemove(value)
        })

        let path = group == .Permissions ? "/\(group.rawValue)/\(value.rawValue)" : "/features/\(group.rawValue)/\(value.rawValue)"

        //Send request
        self.setValueForProperty(property.id, op:"add", path: path, value: addedOrRemoved.rawValue > 0, completionHandler: self.completionHandler)
    }

    func syncYearBuilt(onProperty property: SWBProperty, year: Int) {
        AlertFactory.loadingTopBarMessage("Sync year built", dismissAfter: 0.5)

        let realm = try! Realm()
        let propertyModel = realm.objectForPrimaryKey(SWBPropertyModel.self, key: property.id)
        try! realm.write({
            propertyModel?.features?.yearBuilt.value = year
        })

        //Send request
        self.setValueForProperty(property.id, op:"add", path: "/building/construction/year", value: year, completionHandler: self.completionHandler)
    }

    func syncArchitect(onProperty property: SWBProperty, architect: String) {
        AlertFactory.loadingTopBarMessage("Sync architect", dismissAfter: 0.5)

        let realm = try! Realm()
        let propertyModel = realm.objectForPrimaryKey(SWBPropertyModel.self, key: property.id)
        try! realm.write({
            propertyModel?.features?.architect = architect
        })

        //Send request
        self.setValueForProperty(property.id, op:"add", path: "/building/construction/architect", value: architect, completionHandler: self.completionHandler)
    }

    func syncYearRenovated(onProperty property: SWBProperty, year: Int) {
        AlertFactory.loadingTopBarMessage("Sync year renovated", dismissAfter: 0.5)

        let realm = try! Realm()
        let propertyModel = realm.objectForPrimaryKey(SWBPropertyModel.self, key: property.id)
        try! realm.write({
            propertyModel?.features?.yearRenovated.value = year
        })

        //Send request
        self.setValueForProperty(property.id, op:"add", path: "/building/renovation/year", value: year, completionHandler: self.completionHandler)
    }
    func syncRenovationDetails(onProperty property: SWBProperty, details: String) {
        AlertFactory.loadingTopBarMessage("Sync renovation description", dismissAfter: 0.5)

        let realm = try! Realm()
        let propertyModel = realm.objectForPrimaryKey(SWBPropertyModel.self, key: property.id)
        try! realm.write({
            propertyModel?.features?.renovationDetails = details
        })

        //Send request
        self.setValueForProperty(property.id, op:"add", path: "/building/renovation/description", value: details, completionHandler: self.completionHandler)
    }
}

protocol SWBFeaturesServiceDelegate {
    var service: SWBFeaturesServiceProtocol {get }
    var property: SWBProperty! { get}
}

class SWBFeaturesService: SWBFeaturesServiceProtocol {
    var queue: NSOperationQueue! = NSOperationQueue()
    var completionHandler: (Response<AnyObject, NSError> -> Void)?
}
