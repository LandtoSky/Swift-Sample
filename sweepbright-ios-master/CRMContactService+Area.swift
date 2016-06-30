//
//  CRMContactService+Area.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/21/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

extension CRMContactService {

    /**
     Update the list of location preferences of a contact.
     The old list will be deleted, the location info will be updated and add to the list again.
     - parameter contact: Contact (not vendor) that will have the list updated
     - parameter completionBlock: block executed after update the list
     */
    func updateAreas(fromContact contact: CRMContact, completionBlock: CompletionBlock? = nil) {
        // Avoid run the update when the contact is a vendor
        guard let _ = contact.preferences else {
            completionBlock?()
            return
        }
        let contactID = contact.id

        let leadOrVendor = self.getURLPrefix(fromContact: contact)
        let accessToken = SWBRoutes.getAccessToken()

        let updateListOfAreas = NSBlockOperation {
            SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.GET, url: "\(SWBRoutes.SWBSERVERURL)/\(leadOrVendor)/\(contactID)/location_preferences", parameters: nil, completionHandler: { response in

                if let value = response.result.value {
                    let json = JSON(value)

                    let realm = try! Realm()
                    let newContact = realm.objectForPrimaryKey(CRMContact.self, key: contactID)!
                    realm.beginWrite()

                    // Delete the old list of preferences
                    realm.delete(newContact.preferences!.locations)

                    //Update the location preferences list of a contact
                    for locationJson in json["data"].arrayValue {
                        let locationPreference = CRMLocationPreference()
                        locationPreference.initWithJSON(locationJson)

                        realm.add(locationPreference, update: true)

                        newContact.preferences!.locations.append(locationPreference)
                    }

                    try! realm.commitWrite()
                }
            })
        }
        updateListOfAreas.addDependency(accessToken)
        updateListOfAreas.completionBlock = completionBlock
        self.queue.addOperations([accessToken, updateListOfAreas], waitUntilFinished: false)
    }
}
