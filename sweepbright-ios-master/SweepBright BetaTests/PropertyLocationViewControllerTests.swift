//
//  PropertyLocationViewControllerTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/22/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
import CoreLocation
import MapKit
import RealmSwift
import GoogleMaps

@testable import SweepBright

class MockLocationService: SWBLocationServiceProtocol {
    var executed: Bool = false
    func updateLocation(propertyId: String, location: SWBPropertyLocationModel, completionBlock: (() -> ())?) {
        self.executed = true
        completionBlock?()
    }
}

class MockCLLocationManager: CLLocationManager {
    var requestedWhenInUseAuthorization = false
    var startedUpdatingLocation = false
    override func requestWhenInUseAuthorization() {
        super.requestWhenInUseAuthorization()
        self.requestedWhenInUseAuthorization = true
    }

    override func startUpdatingLocation() {
        super.startUpdatingLocation()
        self.startedUpdatingLocation = true
    }
}

class SWBPropertyLocationViewControllerTests: XCTestCase {
    var viewController: SWBPropertyLocationViewController!

    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name

        let storyboard = UIStoryboard(name: "SWBLocation", bundle: nil)
        self.viewController = storyboard.instantiateViewControllerWithIdentifier("SWBPropertyLocationViewController") as! SWBPropertyLocationViewController
        self.viewController.property = SWBPropertyModel(value:["title":"Property Model"])
        self.viewController.defaultMapUI = MKMapView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPropertyDependent() {
        // This is an example of a functional test case.
        (self.viewController as PropertyDependent).propertyDependent(SWBPropertyModel(value:["title":""]))
    }

    func testGetCurrentLocationButtonIsHidden() {
        let _ = self.viewController.view

        XCTAssertFalse(self.viewController.askingPermissionLabel.hidden)
        XCTAssert(self.viewController.getCurrentLocationButton.hidden)
        XCTAssert(self.viewController.permissionDeniedLabel.hidden)
    }

    func testRequestLocationOnViewDidAppear() {
        let locationManager = MockCLLocationManager()
        let _ = self.viewController.view
        self.viewController.locationManager = locationManager
        XCTAssertFalse(locationManager.requestedWhenInUseAuthorization)
        self.viewController.viewDidAppear(false)
        XCTAssert(locationManager.requestedWhenInUseAuthorization)
        XCTAssert(locationManager.startedUpdatingLocation)
    }

    func testAuthorizationStatusWasDenied() {
        let _ = self.viewController.view

        let clLocationManager: CLLocationManager = viewController.locationManager
        self.viewController.locationManager(clLocationManager, didChangeAuthorizationStatus: CLAuthorizationStatus.Denied)

        XCTAssert(self.viewController.askingPermissionLabel.hidden)
        XCTAssert(self.viewController.getCurrentLocationButton.hidden)
        XCTAssertFalse(self.viewController.permissionDeniedLabel.hidden)
    }

    func testAuthorizationStatusHasChanged() {
        let _ = self.viewController.view
        let clLocationManager: CLLocationManager = viewController.locationManager
        self.viewController.locationManager(clLocationManager, didChangeAuthorizationStatus: CLAuthorizationStatus.AuthorizedWhenInUse)

        XCTAssertFalse(self.viewController.gettingLocationView.hidden)
        XCTAssert(self.viewController.getCurrentLocationButton.hidden)
        XCTAssert(self.viewController.permissionDeniedLabel.hidden)
        XCTAssert(self.viewController.askingPermissionLabel.hidden)
    }

    func testMostAccurateLocationHasChanged() {
        let _ = self.viewController.view
        self.viewController.viewDidAppear(false)
        self.viewController.mostAccurateLocation = CLLocation(latitude: -10, longitude: -10)
        XCTAssert(self.viewController.gettingLocationView.hidden)
        XCTAssertFalse(self.viewController.getCurrentLocationButton.hidden)
        XCTAssert(self.viewController.permissionDeniedLabel.hidden)
        XCTAssert(self.viewController.askingPermissionLabel.hidden)
    }

    func testPopulateOnViewDidLoad() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        property.location = SWBPropertyLocationModel()

        self.viewController.propertyDependent(property)
        let _ = self.viewController.view

        XCTAssertNotEqual(unsafeAddressOf(self.viewController.propertyLocation), unsafeAddressOf(property.location!))
    }

    func testReactiveIBOutlets() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        property.location = SWBPropertyLocationModel()
        property.location!.street = "Condado street"
        property.location!.nr = "123A"
        property.location!.add = "Add"
        property.location!.box = "Box"
        property.location!.floor = "Floor"
        property.location!.province = "Province"
        property.location!.country = "County"
        property.location!.postcode = "PostCode"
        property.location!.city = "city"

        self.viewController.property = property
        let _ = self.viewController.view

        XCTAssertEqual(self.viewController.locationForm.streetTextField.text, self.viewController.propertyLocation.street)
        XCTAssertEqual(self.viewController.locationForm.nrTextField.text, self.viewController.propertyLocation.nr)
        XCTAssertEqual(self.viewController.locationForm.addrTextField.text, self.viewController.propertyLocation.add)
        XCTAssertEqual(self.viewController.locationForm.boxTextField.text, self.viewController.propertyLocation.box)
        XCTAssertEqual(self.viewController.locationForm.floorTextField.text, self.viewController.propertyLocation.floor)
        XCTAssertEqual(self.viewController.locationForm.provinceTextField.text, self.viewController.propertyLocation.province)
        XCTAssertEqual(self.viewController.locationForm.countryTextField.text, self.viewController.propertyLocation.country)
        XCTAssertEqual(self.viewController.locationForm.postcodeTextField.text, self.viewController.propertyLocation.postcode)
        XCTAssertEqual(self.viewController.locationForm.cityTextField.text, self.viewController.propertyLocation.city)
    }

    func testGettingMostAccurateLocation() {
        let _ = self.viewController.view
        self.viewController.viewDidAppear(false)

        //When no location where informed, do not update most accurate variable
        XCTAssertNil(self.viewController.mostAccurateLocation)
        self.viewController.locationManager(self.viewController.locationManager, didUpdateLocations: [])
        XCTAssertNil(self.viewController.mostAccurateLocation)

        //If the first location were added, update the most accurate location
        let firstLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: -10, longitude: -10), altitude: 0, horizontalAccuracy: 100, verticalAccuracy: 100, course: 10, speed: 0, timestamp: NSDate())
        self.viewController.locationManager(self.viewController.locationManager, didUpdateLocations: [firstLocation])
        XCTAssertEqual(self.viewController.mostAccurateLocation, firstLocation)

        //If the new location has a horizontal accuracy bigger than most accurate, do not update
        self.viewController.locationManager(self.viewController.locationManager, didUpdateLocations: [CLLocation(coordinate: CLLocationCoordinate2D(latitude: -10, longitude: -10), altitude: 0, horizontalAccuracy: 101, verticalAccuracy: 100, course: 10, speed: 0, timestamp: NSDate())])
        XCTAssertEqual(self.viewController.mostAccurateLocation, firstLocation)

        //If the new location has a horizontal accuracy not bigger than most accurate, update
        let mostAccurate = CLLocation(coordinate: CLLocationCoordinate2D(latitude: -10, longitude: -10), altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 100, course: 10, speed: 0, timestamp: NSDate())
        self.viewController.locationManager(self.viewController.locationManager, didUpdateLocations: [mostAccurate])
        XCTAssertEqual(self.viewController.mostAccurateLocation, mostAccurate)
    }

    func testBackButtonDelegate() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        property.location = SWBPropertyLocationModel()
        property.location!.street = "Condado street"
        property.location!.nr = "123A"
        property.location!.add = "Add"
        property.location!.box = "Box"
        property.location!.floor = "Floor"
        property.location!.province = "Province"
        property.location!.country = "County"
        property.location!.postcode = "PostCode"
        property.location!.city = "city"
        property.location!.coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)

        self.viewController.property = property
        let _ = self.viewController.view

        XCTAssertFalse(self.viewController.hasChanged())
        self.viewController.locationForm.streetTextField.text = "Condado street 2"
        self.viewController.locationForm.streetTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssert(self.viewController.hasChanged())

    }

    func testBackButtonDelegateWithNilData() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        property.location = SWBPropertyLocationModel()

        self.viewController.property = property
        let _ = self.viewController.view

        XCTAssertFalse(self.viewController.hasChanged())
        self.viewController.locationForm.streetTextField.text = "Condado street 2"
        self.viewController.locationForm.streetTextField.sendActionsForControlEvents(.AllEditingEvents)
        XCTAssert(self.viewController.hasChanged())
    }

    func testLocationService() {
        let property = SWBPropertyModel(value:["title":"Property Model"])
        property.location = SWBPropertyLocationModel()

        self.viewController.property = property
        let _ = self.viewController.view

        let locationService = MockLocationService()
        self.viewController.locationService = locationService

        XCTAssertFalse(locationService.executed)
        self.viewController.updateData()
        XCTAssert(locationService.executed)
    }

    func testGeoCodeCompletionHandlerWithEmptyResponse() {
        let response = GMSReverseGeocodeResponse()

        let property = SWBPropertyModel(value:["title":"Property Model"])
        let streetName = "Not nil"

        property.location = SWBPropertyLocationModel()
        property.location?.street = streetName

        self.viewController.property = property
        let _ = self.viewController.view

        self.viewController.geoCodeCompletionHandler(response, error: nil)
        XCTAssertEqual(property.location!.street, streetName)
    }

}
