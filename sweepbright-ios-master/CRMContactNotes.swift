//
//  CRMContactNotes.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

protocol CRMContactNotesService: CRMContactDependent, CRMContactServiceBase {

}

extension CRMContactNotesService {
    /**
     Update the service contact's notes.

     - parameter notes: New notes value
     - parameter completionBlock: Block executed after sending the request

     */
    func updateNotes(notes: String, completionBlock: CompletionBlock? = nil) {
        self.updateNotes(onContact: self.contact, notes: notes, completionBlock: completionBlock)
    }

    /**
     Update the notes on the contact parameter

     - parameter contact: contact that will be updated
     - parameter notes: New notes value
     - parameter completionBlock: Block executed after sending the request

     */
    func updateNotes(onContact contact: CRMContact, notes: String, completionBlock: CompletionBlock? = nil) {
        let contactID = contact.id
        let urlPrefix = self.getURLPrefix(fromContact: contact)
        var body = contact.toJSON()
        body["note"] = notes

        let accessTokenOp = SWBRoutes.getAccessToken()
        let saveNotes = NSBlockOperation {
            let realm = try! Realm()
            realm.updateNotes(contactWithId: contactID, notes: notes)
        }

        let updateNotesBlock = NSBlockOperation {
            let header = [
                "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")",
                "Content-Type": "application/json"
            ]
            SWBSynchronousRequestFactory.sharedInstance.safeSynchronousRequest(.PUT, url: "\(SWBRoutes.SWBSERVERURL)/\(urlPrefix)/\(contactID)", parameters: body, headers: header, completionHandler: self.updateContactResponse)
        }
        updateNotesBlock.addDependency(accessTokenOp)
        updateNotesBlock.completionBlock = completionBlock
        self.queue.addOperations([accessTokenOp, updateNotesBlock, saveNotes], waitUntilFinished: false)
    }
}
