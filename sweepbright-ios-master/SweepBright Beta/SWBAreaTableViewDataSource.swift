//
//  SWBAreaTableViewDataSource.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/14/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import RealmSwift

let AreaReuseIdentifier = "areaCell"

class SWBAreaTableViewDataSource: NSObject, UITableViewDataSource {

    var serviceDelegate: SWBRoomServiceDelegate!

    //SWBRoomsTableViewController and SWBSelectRoomTableViewController share the list of rooms and the datasource.
    private static var room: SWBPropertyRoom!

    var areas: List<SWBRoomClass> {
        get {
            return SWBAreaTableViewDataSource.room.rooms
        }
    }

    class func setRoom(room: SWBPropertyRoom) {
        SWBAreaTableViewDataSource.room = room
    }

    class func getRoom() -> SWBPropertyRoom {
        return room
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.areas.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let area = self.areas[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(AreaReuseIdentifier) as! SWBAreaTableViewCell
        cell.room = area
        cell.cellDelegate = self.serviceDelegate
        return cell

    }
}
