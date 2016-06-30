//
//  SWBPropertyLocation.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/22/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit
import CoreLocation
import JVFloatLabeledTextField
import ReactiveCocoa
import MapKit
import JDStatusBarNotification
import GoogleMaps

class SWBPropertyLocationViewController: UIViewController, PropertyDependent {

    var property: SWBProperty!
    var propertyLocation: SWBPropertyLocationModel! {
        didSet {
            self.locationForm.location = self.propertyLocation
            self.locationForm.floorTextField.hidden = (self.property.type == .House)
            //add new an annotation on user location
            self.mapView.addAnnotationAndCenter(self.propertyLocation.coordinate)
        }
    }

    var locationService: SWBLocationServiceProtocol = SWBLocationService()
    var locationManager: CLLocationManager!
    var mostAccurateLocation: CLLocation! {
        didSet {
            let hasLocation = (self.mostAccurateLocation == nil)
            self.getCurrentLocationButton.hidden = hasLocation
            self.gettingLocationView.hidden = !hasLocation
            self.askingPermissionLabel.hidden = true
            self.permissionDeniedLabel.hidden = true
        }
    }

    @IBOutlet weak var permissionDeniedLabel: UILabel!
    @IBOutlet weak var askingPermissionLabel: UILabel!
    @IBOutlet weak var getCurrentLocationButton: UIButton!
    @IBOutlet weak var gettingLocationView: UIView!

    @IBOutlet weak var mapView: SWBMapView!

    @IBOutlet var backButton: SWBBackButton!

    //Form IBOutlet
    @IBOutlet var locationForm: SWBLocationFormView!

    //Lazy instantiation, CircleCI cannot call the method GMSServices.provideAPI() so this attribute should never be called in the tests
    var geocoder: SWBGeocoderService {
        return GMSGeocoder()
    }

    internal var mapUI: SWBMapUIElement?

    var defaultMapUI: SWBMapUIElement? {
        get {
            if self.mapUI == nil {
                self.mapUI = GMSMapView()
            }
            return self.mapUI
        }
        set (newValue) {
            self.mapUI = newValue
        }
    }
    var changed: Bool {
        return self.locationForm.changed
    }
    func propertyDependent(property: SWBProperty) {
        self.property = property
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Hidding buttons
        self.askingPermissionLabel.hidden = false
        self.getCurrentLocationButton.hidden = true
        self.gettingLocationView.hidden = true

        self.mapView.mapView = self.defaultMapUI

        //Setting locationManager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        //Copying property location
        if let location = self.property.location {
            self.propertyLocation = SWBPropertyLocationModel(value:location)
        } else {
            self.propertyLocation = SWBPropertyLocationModel()
        }

        self.backButton.backButtonDelegate = self
        self.backButton.confirmBeforeSave = false
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //Requesting location permission
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    @IBAction func getCurrentLocation(sender: AnyObject) {

        //Create an Operation queue
        let queue = NSOperationQueue()
        queue.name = "Get Current Location"
        queue.maxConcurrentOperationCount = 1

        AlertFactory.gettingAddressInformation(self)

        //Create a location operation
        let locationOp = SWBLocationOperations(location: self.mostAccurateLocation, completionHandler: self.geoCodeCompletionHandler)
        locationOp.geoCoder = self.geocoder

        //Start operation
        queue.addOperation(locationOp)
    }

    func geoCodeCompletionHandler(response: GMSReverseGeocodeResponse?, error: NSError?) -> Void {
        self.dismissViewControllerAnimated(false, completion: nil)

        debugPrint(response?.results())

        if error == nil && response?.results()?.count > 0 {
            let address = response!.firstResult()!
            debugPrint(address)


            let thoroughfare = (extractGoogleThoroughfare(address.thoroughfare ?? ""))

            self.propertyLocation.coordinate = self.mostAccurateLocation.coordinate

            //Fill the form
            self.locationForm.cityTextField.setValue(address.locality, forKey: "text")
            self.locationForm.cityTextField.sendActionsForControlEvents(.EditingChanged)
//
            self.locationForm.streetTextField.setValue(thoroughfare[1], forKey: "text")
            self.locationForm.streetTextField.sendActionsForControlEvents(.EditingChanged)
//
//            self.countryTextField.text = locationPlacemark.ISOcountryCode
//            self.countryTextField.sendActionsForControlEvents(.EditingChanged)
//
            self.locationForm.postcodeTextField.text = address.postalCode
            self.locationForm.postcodeTextField.sendActionsForControlEvents(.EditingChanged)
//
            self.locationForm.nrTextField.text = thoroughfare[0]
            self.locationForm.nrTextField.sendActionsForControlEvents(.EditingChanged)
//
            self.locationForm.provinceTextField.text = address.administrativeArea
            self.locationForm.provinceTextField.sendActionsForControlEvents(.EditingChanged)

            //clear the annotations
            self.mapView.clearAnnotations()

            //add new an annotation on user location
            self.mapView.addAnnotationAndCenter(self.mostAccurateLocation.coordinate)
        }
    }

}

extension SWBPropertyLocationViewController: CLLocationManagerDelegate {

    //MARK:CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //Handling UI based on authorization status
        switch status {
        case .AuthorizedWhenInUse:
            self.gettingLocationView.hidden = false
            self.permissionDeniedLabel.hidden = true
            self.askingPermissionLabel.hidden = true
            break
        case .Denied:
            self.gettingLocationView.hidden = true
            self.askingPermissionLabel.hidden = true
            self.permissionDeniedLabel.hidden = false
            break
        default:
            break
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        //In case of error during updatelocation, abort the execution
        if locations.count == 0 {
            return
        }
        for location in locations {
            //Update moreAcurateCoordinate with the most accurate coordinate found
            if self.mostAccurateLocation == nil {
                self.mostAccurateLocation = location
            } else if location.horizontalAccuracy <= self.mostAccurateLocation.horizontalAccuracy {
                self.mostAccurateLocation = location
            }
        }
    }

    func extractGoogleThoroughfare(thoroughfare: String) -> [String] {

        let thoroughfarePattern = "([0-9-]+)?\\s?([A-Za-z0-9. ]+)$"

        do {
            //Create and regex with thoroughfarePattern
            let regex = try NSRegularExpression(pattern: thoroughfarePattern, options: .CaseInsensitive)
            let range = NSRange(location: 0, length: thoroughfare.characters.count)

            //use the regex and replace the groups for :
            let string = regex.stringByReplacingMatchesInString(thoroughfare, options: .Anchored, range: range, withTemplate: "$1:$2")

            //separe groups
            let groups = string.componentsSeparatedByString(":")

            //In case of only one group was found, return the original thoroughfare
            if groups.count < 2 {
                return ["", thoroughfare]
            }
            //On the other hand, return the groups
            return groups

        } catch {
            return ["", thoroughfare]
        }
    }
}

//MARK:SWBBackButtonDelegate
extension SWBPropertyLocationViewController:SWBBackButtonDelegate {
    func updateData() {
        JDStatusBarNotification.showWithStatus("Updating location")
        self.locationService.updateLocation(self.property.id, location: self.propertyLocation, completionBlock: nil)
    }

    var viewController: UIViewController {
        get {
            return self
        }
    }

    func validated() -> Bool {
        return true
    }
    func hasChanged() -> Bool {
        return self.changed
    }
}
