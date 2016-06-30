//
//  CRMContactService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import Alamofire
import Haneke

let CRMNewContactAddedNotification: String = "CRMNewContactAddedNotification"

protocol CRMContactService: CRMContactServiceBase {
    func changeArchiveStatus(fromContact contact: CRMContact, completionBlock: CompletionBlock?)
}

extension CRMContactService {

    /**
     Change archive status.

     If the contact is archived, it'll be unarchived, and vice-versa.

     - parameter contact: contact that will have the archive status changed
     - parameter completionBlock: block executed after the request was completed
     */
    func changeArchiveStatus(fromContact contact: CRMContact, completionBlock: CompletionBlock?) {
        // Prevent realm thread issues
        let contactId = contact.id
        let isArchived = contact.is_archived
        let action = isArchived ? "unarchive" : "archive"

        //Change the archived status on the database
        let archiveContact = NSBlockOperation {
            let realm = try! Realm()
            isArchived ? realm.unarchive(contactWithId: contactId) : realm.archive(contactWithId: contactId)
        }

        //Update the archived status on the server
        let accessTokenOp = SWBRoutes.getAccessToken()
        let saveContactOP = NSBlockOperation {
            let header = [
                "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")",
                "Content-Type": "application/json"
            ]
            SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.POST, url: "\(SWBRoutes.SWBSERVERURL)/contacts/\(contactId)/\(action)", parameters: nil, headers: header, completionHandler: self.updateContactResponse)
        }
        saveContactOP.addDependency(accessTokenOp)
        saveContactOP.completionBlock = completionBlock
        self.queue.addOperations([archiveContact, accessTokenOp, saveContactOP], waitUntilFinished: false)
    }

    private func syncContact(contact: CRMContact) -> NSOperation {
        let contactId = contact.id
        let leadOrVendor = self.getURLPrefix(fromContact: contact)
        let contactJson: Dictionary<String, AnyObject> = contact.toJSON()

        return NSBlockOperation {
                let header = [
                    "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")",
                    "Content-Type": "application/json"
                ]
                SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.PUT, url: "\(SWBRoutes.SWBSERVERURL)/\(leadOrVendor)/\(contactId)", parameters: contactJson, headers: header, completionHandler: {
                    response in
                    debugPrint(response)
                })
        }
    }

    /**
     Update the contact data.

     - parameter contact: object that will be saved
     - parameter completionBlock: block executed after the request was completed
     */
    func saveContactInfo(contact: CRMContact, completionBlock: CompletionBlock? = nil) {
        let accessTokenOp = SWBRoutes.getAccessToken()

        let updateContactOpLocal = NSBlockOperation {
            let realm = try! Realm()
            realm.saveOrUpdate(contact: contact)
        }
        let saveContactOP = self.syncContact(contact)
        saveContactOP.addDependency(accessTokenOp)
        saveContactOP.completionBlock = completionBlock

        NSOperationQueue.mainQueue().addOperation(updateContactOpLocal)
        self.queue.addOperations([accessTokenOp, saveContactOP], waitUntilFinished: false)
    }

    /**
     Add a new contact.

     A new contact will be saved locally and also on the server.

     - parameter contact: object that will be updated
     - parameter completionBlock: block executed after the request was completed
     */
    func addNewContact(contact: CRMContact, completionBlock: CompletionBlock? = nil) {
        let accessTokenOp = SWBRoutes.getAccessToken()
        self.addContact(contact)
        let addContactOp = self.syncContact(contact)

        addContactOp.addDependency(accessTokenOp)
        addContactOp.completionBlock = completionBlock

        self.queue.addOperations([addContactOp, accessTokenOp], waitUntilFinished: false)
    }

    /**
     Save the contact locally and post a nofitication.

     - parameter contact: Contact object that will be saved
     */
    private func addContact(contact: CRMContact) {
        let contactID = contact.id

        let realm = try! Realm()
        realm.add(contact: contact)
        NSNotificationCenter.defaultCenter().postNotificationName(CRMNewContactAddedNotification, object: contactID)
    }

    /**
     Get the contacts list on the server and update the list on the local database.
     - parameter completionBlock: block executed after the request was completed
     */
    func updateContactsList(completionBlock: CompletionBlock? = nil) {
        let accessTokenOp = SWBRoutes.getAccessToken()
        let updateContactsListOp = NSBlockOperation {

            NSLog("updateContacts: started")
            let limit = 100
            let header = [
                "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")"]

            SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.GET, url: "\(SWBRoutes.SWBSERVERURL)/contacts?limit=\(limit)", parameters: nil, headers: header, completionHandler: {
                response in
                if let jsonValue = response.result.value {
                    let realm = try! Realm()
                    realm.beginWrite()

                    for contactJson in JSON(jsonValue)["data"].arrayValue {
                        let contact = CRMContact()
                        contact.initWithJSON(contactJson)
                        realm.add(contact, update: true)
                    }
                    try! realm.commitWrite()
                    NSLog("updateContacts: status code \(response.response?.statusCode)")
                } else {
                    NSLog("updateContacts: no connection")
                }
            })
            NSLog("updateContacts: finished")
        }
        updateContactsListOp.addDependency(accessTokenOp)
        updateContactsListOp.completionBlock = completionBlock
        self.queue.addOperations([accessTokenOp, updateContactsListOp], waitUntilFinished: false)
    }

    /**
     Update contact photo.

     - parameter photo: new contact photo
     - parameter contact: Contact id
     - returns: a photo upload progress object
     */
    func uploadPhoto(photo: UIImage, forContactId contact: String) -> PhotoUploadProgress? {
        //Copying necessary data to avoid thread conflicts
        let url = "\(SWBRoutes.SWBSERVERURL)/contacts/\(contact)/photo"
        let medium_url = try! Realm().objectForPrimaryKey(CRMContactPhoto.self, key: contact)?.medium_url ?? ""

        // Add Headers
        let headers = [
            "Authorization":"Bearer \(SWBKeychain.get(.AccessToken) ?? "")",
            "accept": "application/vnd.sweepbright.v1+json",
            "x-http-method-override": "PUT"
        ]
        AlertFactory.loadingTopBarMessage("Uploading photo")
        return SWBSynchronousRequestFactory.sharedInstance.imageUpload(url, headers: headers, image: photo, response: { response in
            debugPrint(response)
            if response.response?.statusCode == 204, let medium_url = NSURL(string: medium_url) {
                    //Remove cache
                    SWBImageCache.refresh(fromURL: medium_url)
                }
            }
        )
    }
}
