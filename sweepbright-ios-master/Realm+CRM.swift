//
//  Realm+CRM.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import RealmSwift

extension Realm {
    func getAllContacts() -> Results<CRMContact> {
        return self.objects(CRMContact.self)
    }

    func getLeads() -> Results<CRMContact> {
        return self.getAllContacts().filter("type == 'lead'")
    }

    func add(contact contact: CRMContact) {

        try! self.write({
            let id = contact.id
            contact.address = CRMContactAddress(value: ["contact" : contact, "id": id])
            contact.photo = CRMContactPhoto(value: ["contact" : contact, "id": id])
            if contact.contactType == .Lead {
                contact.preferences = CRMContactPreferences(value: ["contact" : contact])
            }
            contact.createdAt = NSDate()
            contact.updatedAt = NSDate()
            self.add(contact)
        })
    }
    func unarchive(contactWithId id: String) {
        let contacts = self.objects(CRMContact.self).filter("id == %@", id)
        self.beginWrite()
        contacts.setValue(false, forKey: "is_archived")
        try! self.commitWrite()
    }

    func archive(contactWithId id: String) {
        let contacts = self.objects(CRMContact.self).filter("id == %@", id)
        self.beginWrite()
        contacts.setValue(true, forKey: "is_archived")
        try! self.commitWrite()
    }

    func updateNotes(contactWithId id: String, notes: String) {
        let contacts = self.objects(CRMContact.self).filter("id == %@", id)
        self.beginWrite()
        contacts.setValue(notes, forKey: "note")
        try! self.commitWrite()
    }

    func saveOrUpdate(object: Object) {
        self.beginWrite()
        self.add(object, update: true)
        try!self.commitWrite()
    }
    func saveOrUpdate(contact contact: CRMContact) {
        self.saveOrUpdate(contact)
    }
}
