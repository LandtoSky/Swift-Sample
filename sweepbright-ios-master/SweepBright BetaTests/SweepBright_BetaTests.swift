//
//  SweepBright_BetaTests.swift
//  SweepBright BetaTests
//
//  Created by Kaio Henrique on 24/11/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
import Alamofire
@testable import SweepBright

class MockRoomService: NSObject, SWBRoomServiceProtocol {
    var queue: NSOperationQueue! = NSOperationQueue()

    var setOrientationExecuted: Bool = false
    var setTotalOfRoomsExecuted: Bool = false
    var setGeneralConditionExecuted: Bool = false
    var setNumberOfFloorsExecuted: Bool = false
    var syncAmenitiesExecuted: Bool = false

    func setGeneralCondition(propertyId: String, generalCondition: SWBGeneralCondition) {
        self.setGeneralConditionExecuted = true
    }

    func setOrientation(propertyId: String, orientationType: SWBOrientationType, orientation: SWBOrientation, completionHandler:(()->())?) {
        self.setOrientationExecuted = true
    }

    func setNumberOfFloors(propertyId: String, numberOfFloors: Int) {
        self.setNumberOfFloorsExecuted = true
    }

    func setTotalOfRooms(propertyId: String, withType type: SWBStructure, total: Int, completionHandler:(()->())?) {
        self.setTotalOfRoomsExecuted = true
    }

    func syncAmenities(propertyId: String, amenities: [SWBAmenity]) {
        self.syncAmenitiesExecuted = true
    }
}

class MockRoomServiceDelegate: SWBRoomServiceDelegate {
    var roomService = MockRoomService()
    var property = SWBPropertyModel()

    var service: SWBRoomServiceProtocol {
        return self.roomService
    }
    var serviceProperty: SWBProperty {
        return self.property
    }
}

class MockSWBLegalDocsService: SWBLegalDocServiceProtocol {
    var syncLegalDocsExecuted = false
    var queue: NSOperationQueue! = NSOperationQueue()

    func syncTenantContractDate(legalDocs: SWBLegalDocs, path: SWBTenantDates, value: NSDate) {

    }

    func syncLegalDocs(legalDocs: SWBLegalDocs) {
        self.syncLegalDocsExecuted = true
    }
}

class MockAccessService: SWBAccessServiceProtocol {
    var synced = false
    var queue: NSOperationQueue! = NSOperationQueue()
    func syncAccess(access: Access, completionBlock: (()->())?) {
        self.synced = true
    }
}

class MockSettingsService: SWBSettingsServiceProtocol {
    var queue: NSOperationQueue! = NSOperationQueue()
    var allowedSynced = false
    var fromSynced = false
    var archived = false
    var notesSynced = false
    var mandateStartDateSynced = false
    var mandateEndDateSynced = false
    var referenceSynced = false
    var negotiatorSynced = false
    var stateSynced = false

    func syncStateOfSale(propertyId: String, state: SWBPropertyStatusSettings) {
        self.stateSynced = true
    }
    func syncOfficeNegotiator(propertyId: String, negotiator: String) {
        self.negotiatorSynced = true
    }

    func syncOfficeReference(propertyId: String, reference: String) {
        self.referenceSynced = true
    }
    func syncMandateEndDate(propertyId: String, withDate date: NSDate) {
        self.mandateEndDateSynced = true
    }
    func syncMandateStartDate(propertyId: String, withDate date: NSDate) {
        self.mandateStartDateSynced = true
    }
    func syncNotes(propertyId: String, notes: String) {
        self.notesSynced = true
    }
    func syncAdvertisementAllowed(propertyId: String, allowed: Bool) {
        self.allowedSynced = true
    }
    func syncAdvertisementFrom(propertyId: String, withDate date: NSDate) {
        self.fromSynced = true
    }
    func archiveProperty(propertyId: String) {
        self.archived = true
    }
}

class MockFeaturesService: SWBFeaturesServiceDelegate {
    var queue: NSOperationQueue! = NSOperationQueue()
    var setConditionExecuted: Bool = false
    var syncedFeatures: Bool = false
    var architectSynced: Bool = false
    var yearBuiltSync: Bool = false
    var detailsSynced: Bool = false
    var yearRenovatedSynced: Bool = false
    var completionHandler: (Response<AnyObject, NSError> -> Void)?

    var service: SWBFeaturesServiceProtocol {
        return self
    }
    var _property = SWBPropertyModel()

    var property: SWBProperty! {
        return self._property
    }
}

extension MockFeaturesService: SWBFeaturesServiceProtocol {
    func setCondition(onProperty property: SWBProperty, condition: SWBConditionType, value: SWBGeneralCondition) {
        self.setConditionExecuted = true
    }

    func syncFeatures(onProperty property: SWBProperty, onTheGroup group: SWBFeatureGroup, value: SWBFeature) {
        self.syncedFeatures = true
    }
    func syncArchitect(onProperty property: SWBProperty, architect: String) {
        self.architectSynced = true
    }
    func syncYearBuilt(onProperty property: SWBProperty, year: Int) {
        self.yearBuiltSync = true
    }

    func syncYearRenovated(onProperty property: SWBProperty, year: Int) {
        self.yearRenovatedSynced = true
    }

    func syncRenovationDetails(onProperty property: SWBProperty, details: String) {
        self.detailsSynced = true
    }
}

class MockPropertyService: SWBPropertyServiceProtocol, SWBNewPropertyProtocol {

    var propertyService: SWBPropertyServiceProtocol {
        return self
    }
    var negotiation: SWBPropertyNegotiation {
        return self.propertyNegotiation
    }

    var propertyNegotiation: SWBPropertyNegotiation
    var createdProperty = false
    var createdProject = false

    init(negotiation: SWBPropertyNegotiation = .ForSale) {
        self.propertyNegotiation = negotiation
    }

    func createProject(type: SWBPropertyType, negotiation: SWBPropertyNegotiation, completionBlock: CompletionBlock?) -> PropertyID {
        self.createdProject = true
        let property = SWBPropertyModel(value: ["propertyType": type.rawValue, "negotiation": negotiation.rawValue])
        property.project = SWBProjectModel(value: ["id": property.id])
        return property.id
    }
    func createNewProperty(property: SWBPropertyModel, completionBlock: CompletionBlock?) -> PropertyID {
        return property.id
    }
    func createNewProperty(type: SWBPropertyType, negotiation: SWBPropertyNegotiation, completionBlock: CompletionBlock?) -> PropertyID {
        self.createdProperty = true
        return SWBPropertyModel(value: ["propertyType": type.rawValue, "negotiation": negotiation.rawValue]).id
    }
    func updateListOfProperties(completionBlock: CompletionBlock?) {

    }
}
