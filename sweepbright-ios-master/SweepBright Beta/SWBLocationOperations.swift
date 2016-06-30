//
//  SWBLocationOperations.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/22/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

protocol  SWBGeocoderService {
    func revertCoordinateToLocation(coordinate: CLLocationCoordinate2D, completionHandler: GMSReverseGeocodeCallback)
}

class SWBLocationOperations: NSOperation {
    var location: CLLocation!
    var completionHandler: GMSReverseGeocodeCallback!
    var geoCoder: SWBGeocoderService!

    init(location: CLLocation, completionHandler: GMSReverseGeocodeCallback!) {
        self.location = location
        self.completionHandler = completionHandler
    }

    override func main() {
        self.geoCoder?.revertCoordinateToLocation(location.coordinate, completionHandler: completionHandler!)
    }
}

extension GMSGeocoder:SWBGeocoderService {
    func revertCoordinateToLocation(coordinate: CLLocationCoordinate2D, completionHandler: GMSReverseGeocodeCallback) {
        self.reverseGeocodeCoordinate(coordinate, completionHandler: completionHandler)
    }
}
