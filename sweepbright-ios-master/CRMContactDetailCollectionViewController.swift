//
//  CRMContactDetailCollectionViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/15/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import RealmSwift

private let ContactDetailReuseIdentifier = "HiperlinkCell"
private let ContactHeaderReuseIdentifier = "contactHeader"

class CRMContactDetailCollectionViewController: UICollectionViewController, CRMContactDependent, CRMContactService {
    var contact: CRMContact!
    var queue: NSOperationQueue!
    var links: [Hiperlink] {
        var listOfLinks = [
            Hiperlink(name: "Contact Info", icon: "contact-info", segue: "contactInfo"),
            Hiperlink(name: "Preferences", icon: "crm-contact-preferences", segue: "preferences"),
            Hiperlink(name: "Interactions", icon: "crm-contact-interaction", segue: nil),
            Hiperlink(name: "Notes", icon: "crm-notes", segue: "notesSegue"),
            Hiperlink(name: "Settings", icon: "crm-settings", segue: "settingsSegue"),
            Hiperlink(name: "Matches", icon: "crm-matches", segue: "matches")
        ]
        if contact.contactType == .Vendor {
            listOfLinks[1] = Hiperlink(name: "Properties", icon: "crm-contact-preferences", segue: nil) // change Preferences to properties
            listOfLinks.removeLast() // Remove matches
        }
        return listOfLinks
    }
    var notificationToken: NotificationToken!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.queue = NSOperationQueue()
        self.updateAreas(fromContact: self.contact)

        self.addContactChangesListener()
        self.collectionView!.registerNib(UINib(nibName: "CRMContactInfoHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ContactHeaderReuseIdentifier)
        self.collectionView?.registerNib(UINib(nibName: "HiperlinkCell", bundle: nil), forCellWithReuseIdentifier: ContactDetailReuseIdentifier)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
        self.navigationItem.title = self.contact.fullName
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! HiperlinkCell
        self.performSegueWithIdentifier(cell.link!.segue, sender: nil)
    }
    override func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        if var contactHeader = view as? CRMContactDependent {
            contactHeader.contact = self.contact
        }
    }
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ContactHeaderReuseIdentifier, forIndexPath: indexPath)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.links.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ContactDetailReuseIdentifier, forIndexPath: indexPath) as! HiperlinkCell
        cell.link = links[indexPath.row]
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //Fix the item's size to always show 3 item per row
        let size = (collectionView.frame.size.width - 18)/3.0
        return CGSize(width: size, height: size)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if var destination = segue.destinationViewController as? CRMContactDependent {
            //Send a copy of the contact object, this should avoid Realm integrity issues
            destination.contact = CRMContact(value: self.contact)
        }
        super.prepareForSegue(segue, sender: sender)
    }
    /// Add the realm a notification block that refresh the UI whenever something changes on Realm
    private func addContactChangesListener() {
        let realm = try! Realm()
        self.notificationToken = realm.addNotificationBlock({ _ in
            self.collectionView?.reloadData()
            self.navigationItem.title = self.contact.fullName
        })
    }
    deinit {
        self.notificationToken?.stop()
    }
}
