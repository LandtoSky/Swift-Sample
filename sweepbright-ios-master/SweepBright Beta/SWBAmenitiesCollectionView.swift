//
//  SWBAmenitiesCollectionView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/11/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import RealmSwift

class SWBAmenitiesCollectionView: UICollectionView {
    let reuseIdentifier = "RoomCell"
    var amenities: [SWBAmenity] {
        return self.serviceDelegate?.serviceProperty.amenitiesAvailable ?? []
    }
    var height: CGFloat!
    let cellHeight = 120

    //The app sends the array of amenities enabled to the server
    //If the user select amenities really fast, we may have this problem
    //https://github.com/madewithlove/sweepbright-ios/issues/113
    var amenitiesEnabled: [SWBAmenity]!

    var serviceDelegate: SWBRoomServiceDelegate! {
        didSet {
            self.amenitiesEnabled = self.serviceDelegate.serviceProperty.room?.amenities.filter({$0.amenity != nil}).map({$0.amenity!})
            self.height = CGFloat(Int((Double(self.amenities.count) / 3.0) + 0.7) * self.cellHeight)
            self.reloadData()
        }
    }

    var property: SWBProperty {
        return self.serviceDelegate.serviceProperty
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.initialize()
    }

    func initialize() {
        self.delegate = self
        self.dataSource = self
    }

    func widthFromCell() -> CGFloat {
        return self.frame.size.width / 3.0
    }
}

//MARK: Datasource
extension SWBAmenitiesCollectionView: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenities.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let amenity = self.amenities[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SWBAmenityCollectionViewCell
        cell.amenity = amenity
        cell.selectedSwitch.setOn(self.amenitiesEnabled.indexOf(amenity) > -1 )
        return cell
    }
}

//MARK: Delegate
extension SWBAmenitiesCollectionView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //Fix the item's size to always show 3 item per row
        return CGSize(width: self.widthFromCell(), height: CGFloat(self.cellHeight))
    }

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        //Changing alpha after long pressing
        collectionView.cellForItemAtIndexPath(indexPath)?.alpha = 0.5
    }

    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        //Changing alpha after long pressing be released
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SWBAmenityCollectionViewCell
        cell.alpha = 1.0
        cell.selectedSwitch.setOn(!cell.selectedSwitch.on)

        //addOrRemove from local amenities list
        if let index = self.amenitiesEnabled.indexOf(cell.amenity) {
            self.amenitiesEnabled.removeAtIndex(index)
        } else {
            self.amenitiesEnabled.append(cell.amenity)
        }

        let propertyId = self.property.id

        //Update in case the device is offline
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let realm = try! Realm()
            let property = realm.objectForPrimaryKey(SWBPropertyModel.self, key: propertyId)
            property!.room?.addOrRemoveAmenity(cell.amenity)
        })

        //Sync the amenities
        self.serviceDelegate.service.syncAmenities(self.property.id, amenities: self.amenitiesEnabled)
    }
}
