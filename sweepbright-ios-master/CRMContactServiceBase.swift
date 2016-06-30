//
//  CRMContactServiceBase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

protocol CRMContactServiceBase {
    var queue: NSOperationQueue! {get}
}

extension CRMContactServiceBase {
    internal func leadOrVendor(contactId: String) -> String? {
        let realm = try! Realm()
        if let contact = realm.objectForPrimaryKey(CRMContact.self, key: contactId) {
            return self.getURLPrefix(fromContact: contact)
        }
        return nil
    }
    func getURLPrefix(fromContact contact: CRMContact) -> String {
        return contact.contactType!.rawValue + "s"
    }
    internal var updateContactResponse: Response<AnyObject, NSError> -> Void {
        return {
            response in
            let statusCode = response.response?.statusCode ?? 500
            if statusCode > 299 {
                debugPrint(response)
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                let contact = CRMContact(value: json.dictionaryObject ?? [:])
                contact.initWithJSON(json)
                let realm = try! Realm()
                realm.saveOrUpdate(contact: contact)
            }
        }
    }
}
