//
//  SWBRoomService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/17/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift


enum SWBOrientationType: String {
    case Garden = "garden"
    case Terrace = "terrace"
}

class SWBRoomWrapper {
    var parameters: [AnyObject] = []

    func addParameter(room: SWBRoom) {

        let json: [String: AnyObject] = ["op":"add", "path":"/structure/rooms/\(room.id)",
            "value":room.toJSON()
        ]

        //The json structure was created here to avoid safe-thread problems
        self.parameters.append(json)
    }
}

protocol SWBRoomServiceProtocol: SWBService {
    func setOrientation(propertyId: String, orientationType: SWBOrientationType, orientation: SWBOrientation, completionHandler:(()->())?)

    func setTotalOfRooms(propertyId: String, withType type: SWBStructure, total: Int, completionHandler:(()->())?)

    func setGeneralCondition(propertyId: String, generalCondition: SWBGeneralCondition)

    func setNumberOfFloors(propertyId: String, numberOfFloors: Int)

    func syncAmenities(propertyId: String, amenities: [SWBAmenity])
}

class SWBRoomService: SWBRoomServiceProtocol {
    var queue: NSOperationQueue! = NSOperationQueue()

    func setNumberOfFloors(propertyId: String, numberOfFloors: Int) {
        let realm = try! Realm()
        let property = realm.objectForPrimaryKey(SWBPropertyModel.self, key: propertyId)
        try! realm.write({
            property?.room?.floors = numberOfFloors
        })

        self.setValueForProperty(propertyId, op:"add", path: "/structure/floors", value: numberOfFloors ?? 0, completionHandler: { _ in })
    }

    func syncAmenities(propertyId: String, amenities: [SWBAmenity]) {
        AlertFactory.loadingTopBarMessage("Sync amenities", dismissAfter: 1.0)

        let amenities: [String] = amenities.map({$0.rawValue}) ?? []

        self.setValueForProperty(propertyId, op:"add", path: "/amenities", value: amenities, completionHandler: { _ in })
    }
    func setGeneralCondition(propertyId: String, generalCondition: SWBGeneralCondition) {

        //Save new general condition
        let realm = try! Realm()

        let property = realm.objectForPrimaryKey(SWBPropertyModel.self, key: propertyId)
        try! realm.write({
            property?.room?.generalCondition = generalCondition
        })

        //Send request
        self.setValueForProperty(propertyId, op:"add", path: "/general_condition", value: generalCondition.rawValue, completionHandler: {
            _ in
        })
    }

    func setOrientation(propertyId: String, orientationType: SWBOrientationType, orientation: SWBOrientation, completionHandler: (() -> ())? = nil) {
        let wrapperJson = SWBWrapperJSON()

        let accessTokenOp = SWBRoutes.getAccessToken()
        let updateOrientationOp = SWBRoutes.getUpdateOrientationOperation(propertyId, orientationType: orientationType, orientation: orientation, wrapperJson: wrapperJson)

        let saveOrientation = NSBlockOperation {
            NSLog("setOrientation:saveOrientation:started")

            let realm = try! Realm()
            if let property = realm.objects(SWBPropertyModel).filter("id == %@", propertyId).first {
                try! realm.write({
                    property.room?.setValue(orientation.rawValue, forKey: "\(orientationType.rawValue)Location")
                })
            }

            NSLog("setOrientation:saveOrientation:finished")
        }

        updateOrientationOp.addDependency(saveOrientation)
        updateOrientationOp.addDependency(accessTokenOp)
        updateOrientationOp.completionBlock = {
            dispatch_async(dispatch_get_main_queue(), {
                AlertFactory.dismissTopBarMessage()
                completionHandler?()
            })
        }

        AlertFactory.loadingTopBarMessage("Update \(orientationType.rawValue.capitalizedString) orientation")

        self.queue.addOperations([saveOrientation, updateOrientationOp, accessTokenOp], waitUntilFinished: false)
    }

    private func setValueForStructure(propertyId: String, key: String, value: AnyObject, completionHandler:(()->())?) {
        let accessTokenOp = SWBRoutes.getAccessToken()
        let updateFloors = SWBRoutes.setValueForProperty(propertyId, path: "structure", key: key, value: value, completionHandler: {
            _ in

        })

        updateFloors.addDependency(accessTokenOp)
        self.queue.addOperations([updateFloors, accessTokenOp], waitUntilFinished: false)
    }

    func updateRooms(propertyId: String, withType type: SWBStructure, total: Int, roomWrapper: SWBRoomWrapper) -> NSOperation {
        return NSBlockOperation(block: {
            NSLog("updateRooms: Started")

            let realm = try! Realm()
            let property = realm.objects(SWBPropertyModel).filter("id == %@", propertyId).first

            //Filter rooms
            var rooms = property?.room?.rooms.filter({$0.structure == type})
            let totalRooms = rooms!.count

            let diffRooms = total - totalRooms

            realm.beginWrite()

            if diffRooms > 0 {
                //add necessary rooms
                NSLog("updateRooms: add \(diffRooms)")
                for _ in 0..<diffRooms {
                    //create the object and json
                    let room = SWBRoomClass(value:["type":type.rawValue])
                    roomWrapper.addParameter(room)
                    property?.room?.rooms.append(room)
                }
            } else {
                NSLog("updateRooms: remove \(diffRooms)")
                var idsToBeDeleted: [String] = []
                //remove rooms
                for _ in diffRooms..<0 {
                    let json = ["op":"remove", "path":"/structure/rooms/\((rooms!.last?.id)!)"]
                    //The json structure was created here to avoid safe-thread problems
                    roomWrapper.parameters.append(json)
                    idsToBeDeleted.append((rooms!.last?.id)!)
                    rooms?.removeLast()
                }
                realm.delete((property!.room?.rooms.filter("id IN %@", idsToBeDeleted))!)
            }
            //Commit changes
            try! realm.commitWrite()
            NSLog("updateRooms: Started")
        })
    }

    func setTotalOfRooms(propertyId: String, withType type: SWBStructure, total: Int, completionHandler:(() -> ())?) {

        let roomWrapper = SWBRoomWrapper()

        let accessTokenOp = SWBRoutes.getAccessToken()
        let updateRooms = self.updateRooms(propertyId, withType: type, total: total, roomWrapper: roomWrapper)
        let updateRoomsServer = SWBRoutes.updateRoomsOfaProperty(propertyId, wrapper: roomWrapper)

        updateRoomsServer.addDependency(accessTokenOp)
        updateRoomsServer.addDependency(updateRooms)
        updateRoomsServer.completionBlock = completionHandler

        self.queue.addOperations([updateRooms, accessTokenOp, updateRoomsServer], waitUntilFinished: false)

    }
}
