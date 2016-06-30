//
//  SWBSettingsService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift

protocol SWBSettingsServiceProtocol: SWBService {
    func syncNotes(propertyId: String, notes: String)
    func syncStateOfSale(propertyId: String, state: SWBPropertyStatusSettings)
    func syncAdvertisementAllowed(propertyId: String, allowed: Bool)
    func syncAdvertisementFrom(propertyId: String, withDate date: NSDate)
    func syncMandateStartDate(propertyId: String, withDate date: NSDate)
    func syncMandateEndDate(propertyId: String, withDate date: NSDate)
    func syncOfficeReference(propertyId: String, reference: String)
    func syncOfficeNegotiator(propertyId: String, negotiator: String)
    func archiveProperty(propertyId: String)
}

class SWBSettingsService: SWBSettingsServiceProtocol {
    var queue: NSOperationQueue! = NSOperationQueue()

    lazy var realm: Realm! = {
        return try! Realm()
    }()

    func syncStateOfSale(propertyId: String, state: SWBPropertyStatusSettings) {
        AlertFactory.loadingTopBarMessage("Sync state of sale", dismissAfter: 0.5)
        try! realm.write({
            self.realm.objects(SWBPropertySettingsModel).filter("id = %@", propertyId).setValue(state.rawValue, forKey: "status")
        })
        self.setValueForProperty(propertyId, op: "add", path: "/status", value: state.rawValue)
    }

    func syncOfficeNegotiator(propertyId: String, negotiator: String) {
        AlertFactory.loadingTopBarMessage("Sync negotiator", dismissAfter: 0.5)
        try! realm.write({
            self.realm.objects(SWBPropertySettingsModel).filter("id = %@", propertyId).setValue(negotiator, forKey: "negotiator")
        })
        self.setValueForProperty(propertyId, op: "add", path: "/settings/office/negotiator", value: negotiator)
    }

    func syncOfficeReference(propertyId: String, reference: String) {
        AlertFactory.loadingTopBarMessage("Sync reference", dismissAfter: 0.5)
        try! realm.write({
            self.realm.objects(SWBPropertySettingsModel).filter("id = %@", propertyId).setValue(reference, forKey: "reference")
        })
        self.setValueForProperty(propertyId, op: "add", path: "/settings/office/reference", value: reference)
    }

    func syncNotes(propertyId: String, notes: String) {
        AlertFactory.loadingTopBarMessage("Sync notes", dismissAfter: 0.5)
        try! realm.write({
            self.realm.objects(SWBPropertySettingsModel).filter("id = %@", propertyId).setValue(notes, forKey: "notes")
        })
        self.setValueForProperty(propertyId, op: "add", path: "/settings/internal_note", value: notes)
    }

    func syncAdvertisementAllowed(propertyId: String, allowed: Bool) {
        AlertFactory.loadingTopBarMessage("Sync advertisement allowed", dismissAfter: 0.5)
        try! realm.write({
            self.realm.objects(SWBPropertySettingsModel).filter("id = %@", propertyId).setValue(allowed, forKey: "allowed")
        })
        self.setValueForProperty(propertyId, op: "add", path: "/settings/advertisement/allowed", value: allowed)
    }

    func syncMandateStartDate(propertyId: String, withDate date: NSDate) {
        AlertFactory.loadingTopBarMessage("Sync mandate start date", dismissAfter: 0.5)
        try! realm.write({
            self.realm.objects(SWBPropertySettingsModel).filter("id = %@", propertyId).setValue(date, forKey: "startDate")
        })
        self.setValueForProperty(propertyId, op: "add", path: "/settings/mandate/start_date", value: date.inShortFormat())
    }

    func syncMandateEndDate(propertyId: String, withDate date: NSDate) {

        AlertFactory.loadingTopBarMessage("Sync mandate end date", dismissAfter: 0.5)
        try! realm.write({
            self.realm.objects(SWBPropertySettingsModel).filter("id = %@", propertyId).setValue(date, forKey: "endDate")
        })
        self.setValueForProperty(propertyId, op: "add", path: "/settings/mandate/end_date", value: date.inShortFormat())
    }

    func syncAdvertisementFrom(propertyId: String, withDate date: NSDate) {
        AlertFactory.loadingTopBarMessage("Sync advertisement available from", dismissAfter: 0.5)
        try! realm.write({
            self.realm.objects(SWBPropertySettingsModel).filter("id = %@", propertyId).setValue(date, forKey: "from")
        })
        self.setValueForProperty(propertyId, op: "add", path: "/settings/advertisement/from", value: date.inShortFormat())
    }

    func archiveProperty(propertyId: String) {
        AlertFactory.loadingTopBarMessage("Archiving property", dismissAfter: 0.5)
        let accessTokenOperation = SWBRoutes.getAccessToken()
        let archiveOp = SWBRoutes.archive(propertyWithId: propertyId)
        let deleteProperty = NSBlockOperation {
            let realm = try! Realm()
            try! realm.write {
                if let property = realm.objectForPrimaryKey(SWBPropertyModel.self, key: propertyId) {
                    realm.delete(property)
                }
            }
        }
        archiveOp.addDependency(accessTokenOperation)
        self.queue.addOperations([accessTokenOperation, archiveOp, deleteProperty], waitUntilFinished: false)
    }
}
