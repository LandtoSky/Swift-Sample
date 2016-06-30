//
//  SWBFloorPlanCollectionDatasource.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/20/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBFloorPlanCollectionDatasource: NSObject, UICollectionViewDataSource {
    let reuseIdentifier = "floorPlanViewCell"
    private static var room: SWBPropertyRoom!


    var plans: [SWBPlan] {
        get {
            return SWBFloorPlanCollectionDatasource.room.plans
        }
    }

    class func getRoom() -> SWBPropertyRoom {
        return room
    }

    class func setRoom(room: SWBPropertyRoom) {
        SWBFloorPlanCollectionDatasource.room = room
    }

    class func addPlan(plan: SWBPlan) {
        room.plans.append(plan)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.hidden = (plans.count == 0)
        return plans.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! SWBFloorPlanCollectionViewCell
        cell.plan = self.plans[indexPath.row]
        return cell
    }
}
