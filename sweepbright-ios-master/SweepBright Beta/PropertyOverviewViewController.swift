//
//  PropertyOverviewViewController.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 12/3/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class PropertyOverviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PropertyDependent {

    var titleContext = 0
    var property: SWBProperty! {
        didSet {
            self.updateTitle()

            NSLog(self.property.id)
            if let _ = self.property.project {
                NSLog("Is a project: \(self.property.project!.id)")
                self.priceLink = nil
                self.dynamicLink = Hiperlink(name:"Units", icon: "units", segue: "UnitSegue")
            } else {
                self.dynamicLink = Hiperlink(name:"Rooms", icon: "rooms", segue: "roomsSegue")
            }

        }
    }
    var dynamicLink: Hiperlink = Hiperlink(name:"", icon: "", segue: nil)
    var priceLink: Hiperlink? = Hiperlink(name: "Price", icon: "price", segue: "priceSegue")

    var hiperlinks: [Hiperlink]!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let allLinks: [Hiperlink?] = [
            Hiperlink(name:"Location", icon: "location", segue: "locationSegue"), dynamicLink, priceLink,
            Hiperlink(name:"Description", icon: "description", segue: "descriptionSegue"), Hiperlink(name:"Images", icon: "images", segue: "showImages"), Hiperlink(name:"Legal & Docs", icon: "legal-docs", segue: "legalDocsSegue"),
            Hiperlink(name:"Features", icon: "details", segue: "featuresSegue"), Hiperlink(name:"Access", icon: "visit", segue: "accessSegue"), Hiperlink(name:"Settings", icon: "settings", segue: "settingsSegue"),
        ]
        self.hiperlinks = allLinks.filter({$0 != nil}).map({$0!})
    }

    func updateTitle() {
        UIView.animateWithDuration(0.3, animations: {
            self.tabBarController?.navigationItem.title = "\(self.property.type.rawValue) \(self.property.status!.title().uppercaseString)"
        })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTitle()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateTitle()
    }

    //MARK:PropertyDependent
    func propertyDependent(property: SWBProperty) {
        self.property = property
    }

    //MARK: CollectionView Datasource
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HeaderView", forIndexPath: indexPath)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HiperlinkCell", forIndexPath: indexPath) as! HiperlinkCell
        cell.link = hiperlinks[indexPath.row]

        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hiperlinks.count
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is PropertyDependent {
            (segue.destinationViewController as! PropertyDependent).propertyDependent(self.property)
        }

        super.prepareForSegue(segue, sender: sender)
    }

    //MARK: CollectionView  Delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //Fix the item's size to always show 3 item per row
        let size = (collectionView.frame.size.width-16)/3.0
        return CGSize(width: size, height: size)
    }

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        //Changing alpha after long pressing
        collectionView.cellForItemAtIndexPath(indexPath)?.alpha = 0.5
    }

    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        //Changing alpha after long pressing be released
        collectionView.cellForItemAtIndexPath(indexPath)?.alpha = 1.0
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let link = hiperlinks[indexPath.row]
        self.performSegueWithIdentifier(link.segue, sender: self)
    }

}
