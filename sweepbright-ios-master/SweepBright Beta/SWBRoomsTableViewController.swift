//
//  SWBRoomsTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/11/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import CoreLocation
import ReactiveCocoa
import RealmSwift

class SWBRoomsTableViewController: UITableViewController {
    @IBOutlet weak var amenitiesCollectionView: SWBAmenitiesCollectionView!
    @IBOutlet weak var generalConditionSlider: SWBGeneralConditionSlider!

    @IBOutlet weak var beedroomsStepper: SWBRoomsStepper!
    @IBOutlet weak var wcStepper: SWBRoomsStepper!
    @IBOutlet weak var bathroomsStepper: SWBRoomsStepper!
    @IBOutlet weak var floorStepper: SWBFloorStepper!

    @IBOutlet weak var floorPlanCollectionView: UICollectionView!
    let floorPlanDatasource = SWBFloorPlanCollectionDatasource()
    var selectedIndexPath: NSIndexPath!

    var roomService: SWBRoomServiceProtocol = SWBRoomService()

    //Orientations
    @IBOutlet weak var compassCell: SWBOrientationViewCell!
    @IBOutlet weak var gardenOrientationButton: UIButton!

    @IBOutlet weak var terraceOrientationButton: UIButton!
    @IBOutlet weak var terraceCell: SWBOrientationViewCell!

    var deviceOrientation: SWBOrientation! {
        didSet {

            if let orientation = self.deviceOrientation {
                self.compassCell.orientation = orientation
                self.terraceCell.orientation = orientation
            }
        }
    }

    //Rotate the compass image
    var deviceHeading: CLHeading! {
        didSet {
            if let heading = self.deviceHeading {
                self.compassCell.heading = heading
                self.terraceCell.heading = heading
            }
        }
    }

    var locationManager: CLLocationManager!
    let areaDatasource = SWBAreaTableViewDataSource()
    let areaTableViewSectionNumber = 5
    let amenitiesSectionNumber = 3
    let orientationTableViewSectionNumber = 10


    var property: SWBProperty! {
        didSet {
            self.propertyRoom = self.property.room
        }
    }
    var propertyRoom: SWBPropertyRoom! {
        didSet {
            SWBAreaTableViewDataSource.setRoom(self.propertyRoom)
            SWBFloorPlanCollectionDatasource.setRoom(self.propertyRoom)
        }
    }

    let realm = try! Realm()
    var notificationToken: NotificationToken!

    @IBOutlet weak var areaTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.amenitiesCollectionView.serviceDelegate = self

        //Set the service to update a room area
        self.areaDatasource.serviceDelegate = self
        self.areaTableView.dataSource = self.areaDatasource
        self.floorPlanCollectionView.dataSource = self.floorPlanDatasource
        self.floorPlanCollectionView.delegate = self

        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.bindData()
        self.refreshTables()

        self.setRoomServiceDelegates()

        NSNotificationCenter.defaultCenter().addObserverForName(SWBHideOrientationCells, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            _ in
            self.tableView.reloadData()
        })

        //Start update compass
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingHeading()

        self.notificationToken = realm.addNotificationBlock({_, _ in

            dispatch_async(dispatch_get_main_queue(), {
                self.propertyRoom = self.property.room
                self.bindData()
            })
        })
    }

    deinit {
        self.notificationToken.stop()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func setRoomServiceDelegates() {
        //Set the service to update the number of floors
        self.floorStepper.serviceDelegate = self

        //Set the service to update the number of rooms
        self.beedroomsStepper.serviceDelegate = self
        self.bathroomsStepper.serviceDelegate = self
        self.wcStepper.serviceDelegate = self

        //Set the service to update the orientation of garden and/or terrace
        self.compassCell.serviceDelegate = self
        self.terraceCell.serviceDelegate = self

        //Set the service to update the general condition
        self.generalConditionSlider.roomDelegate = self

        RACSignal.merge([self.wcStepper.rac_valueChanged(), self.beedroomsStepper.rac_valueChanged(), self.bathroomsStepper.rac_valueChanged()]).subscribeNext({
            _ in
            self.refreshTables()
        })
    }

    func refreshTables() {

        //Load areaTableView
        self.areaTableView.reloadData()
        self.tableView.reloadData()
    }

    func bindData() {
        //Do not refresh the tables here, the keyboard may dismiss (https://github.com/madewithlove/sweepbright-ios/issues/38)

        self.wcStepper.value = self.propertyRoom.rooms.filter({$0.structure == .WC}).count
        self.bathroomsStepper.value = self.propertyRoom.rooms.filter({$0.structure == .Bathroom}).count
        self.beedroomsStepper.value = self.propertyRoom.rooms.filter({$0.structure == .Bedroom}).count

        self.floorStepper.value = self.propertyRoom.floors

        self.generalConditionSlider.setCondition(self.propertyRoom.generalCondition ?? .Good, sync:false)

        //Populate orientations
        self.gardenOrientationButton.setTitle( self.propertyRoom.gardenOrientation?.orientation?.fullName(), forState: .Normal)
        self.terraceOrientationButton.setTitle(self.propertyRoom.terraceOrientation?.orientation?.fullName(), forState: .Normal)

    }

    @IBAction func toggleTerraceCompass(sender: AnyObject) {
        //collapse the terrace compass
        self.toggleCell(self.terraceCell)
    }

    @IBAction func toggleCompass(sender: AnyObject) {
        //collapse the garden compass
        self.toggleCell(self.compassCell)
    }

    internal func toggleCell(cell: SWBOrientationViewCell) {
        if self.deviceOrientation == nil {
            return
        }
        //This will dispatch a NSNotification
        SWBOrientationViewCellUnique.orientationCell = SWBOrientationViewCellUnique.orientationCell == cell ? nil : cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPlan" {
            if let indexPath = self.selectedIndexPath {
                (segue.destinationViewController as! SWBAddPlanViewController).plan = self.floorPlanDatasource.plans[indexPath.row]
            } else {
                return
            }
        }
        super.prepareForSegue(segue, sender: sender)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.floorPlanCollectionView.reloadData()
        self.tableView.reloadData()
    }

    @IBAction func addPlan(sender: AnyObject) {
        self.performSegueWithIdentifier("addPlan", sender: self)
    }

    //MARK: TableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //areaTableView depends of the number of rows
        if indexPath.section == areaTableViewSectionNumber {
            return self.areaTableView.contentSize.height
        } else if indexPath.section == orientationTableViewSectionNumber {
            let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
            if cell is SWBOrientationViewCell {
                return (cell as! SWBOrientationViewCell).height
            }
        } else if indexPath.section == amenitiesSectionNumber {
            return self.amenitiesCollectionView.height
        }

        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
}

extension SWBRoomsTableViewController:UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
    }
}

extension SWBRoomsTableViewController:PropertyDependent {

    func propertyDependent(property: SWBProperty) {
        self.property = property
    }

}

//MARK: SWBRoomServiceDelegate
extension SWBRoomsTableViewController:SWBRoomServiceDelegate {
    var service: SWBRoomServiceProtocol {
        return self.roomService
    }
    var serviceProperty: SWBProperty {
        return self.property
    }
}

//MARK: LocationManagerDelegate
extension SWBRoomsTableViewController:CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {

        //Rotate the compass based on Magnetic north position
        self.deviceHeading = newHeading
        self.deviceOrientation = self.getOrientation(fromDegrees: newHeading.trueHeading)
    }

    func getOrientation(fromDegrees degrees: CLLocationDirection) -> SWBOrientation! {

        //Convert CLLocationDirection to SWBOrientation
        switch degrees {
        case 0.0...22.5:
            return .N
        case 22.5...67.5:
            return .NE
        case 67.5...115.5:
            return .E
        case 11.5...157.5:
            return .SE
        case 157.5...202.5:
            return .S
        case 202.5...247.5:
            return .SW
        case 247.5...292.5:
            return .W
        case 292.5...337.5:
            return .NW
        case 337.5...360.0:
            return .N
        default:
            return nil
        }
    }

    func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager) -> Bool {
        return false
    }
}
