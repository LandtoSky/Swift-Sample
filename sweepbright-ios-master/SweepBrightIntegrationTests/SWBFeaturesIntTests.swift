//
//  SWBFeaturesIntTests.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/18/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
import Alamofire
@testable import SweepBright
class SWBFeaturesIntTests: SweepBrightIntegrationTests, SWBFeaturesServiceProtocol {
    var realm: Realm!
    var completionHandler: (Response<AnyObject, NSError> -> Void)?
    var token: dispatch_once_t = 0
    override func setUp() {
        super.setUp()
        self.realm = try! Realm()

        dispatch_once(&token, {
            self.updateProperties()
        })
    }
    func runBathroomCondition(onFeature feature: SWBFeaturesModel) {
        let asyncExpectation = expectationWithDescription(self.name!)
        self.completionHandler = {
            _ in
            asyncExpectation.fulfill()
        }
        self.setCondition(onProperty: feature.property!, condition: .Bathroom, value: .Good)
        self.waitForExpectationsWithTimeout(30, handler: nil)
        XCTAssertEqual(feature.bathroom, SWBGeneralCondition.Good)
    }

    func testSetBathroomCondition() {
        let feature = realm.objects(SWBFeaturesModel.self).first!
        self.runBathroomCondition(onFeature: feature)
    }
    func testSetProjectBathroomCondition() {
        let project = realm.objects(SWBProjectModel.self).first!
        self.runBathroomCondition(onFeature: project.property!.features!)
    }
}
