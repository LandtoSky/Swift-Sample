//
//  CRMContactAddressService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift

protocol CRMContactAddressService: CRMContactServiceBase {

}

extension CRMContactAddressService {
    func update(address address: CRMContactAddress, completionBlock: (() -> Void)? = nil) {
        let body = address.toJSON()
        let contactID = address.id

        let saveAddress = NSBlockOperation {
            let realm = try! Realm()
            realm.saveOrUpdate(address)
        }

        let accessToken = SWBRoutes.getAccessToken()
        let syncAddress = NSBlockOperation {
            let header = [
                "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")",
                "Content-Type": "application/json",
                "Accept": "application/vnd.sweepbright.v1+json"
            ]
            SWBSynchronousRequestFactory.sharedInstance.safeSynchronousRequest(.PUT, url: "\(SWBRoutes.SWBSERVERURL)/contacts/\(contactID)/address", parameters: body, headers: header, completionHandler: self.updateContactResponse)
        }
        syncAddress.addDependency(saveAddress)
        syncAddress.addDependency(accessToken)
        syncAddress.completionBlock = completionBlock

        NSOperationQueue.mainQueue().addOperation(saveAddress)
        self.queue.addOperations([accessToken, syncAddress], waitUntilFinished: false)
    }
}
