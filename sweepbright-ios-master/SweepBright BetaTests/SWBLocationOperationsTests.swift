//
//  SWBLocationOperationsTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/23/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import XCTest
import CoreLocation
import GoogleMaps
@testable import SweepBright

class SWBLocationOperationsTests: XCTestCase {
    class MockGeoCoder: SWBGeocoderService {
        var reversedGeocodeLocation = false

        func revertCoordinateToLocation(coordinate: CLLocationCoordinate2D, completionHandler: GMSReverseGeocodeCallback) {
            self.reversedGeocodeLocation = true
        }
    }

    var token = 0
    override func setUp() {
        super.setUp()
    }

    func testLocalOperationCallsGeocoder() {

        let operation = SWBLocationOperations(location: CLLocation(latitude: -10, longitude: -10), completionHandler: {
            _, _ in
        })

        let geoCoder = MockGeoCoder()
        operation.geoCoder = geoCoder

        XCTAssertFalse(geoCoder.reversedGeocodeLocation)
        operation.main()
        XCTAssert(geoCoder.reversedGeocodeLocation)
    }


}
