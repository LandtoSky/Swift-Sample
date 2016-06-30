//
//  SWBFeaturesTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/29/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import SweepBright

class SWBFeaturesTestCase: XCTestCase {

    func testDeserialize() {
        let featureJSON = [
            "conditions": [
                "kitchen" : "mint",
                "bathroom": "new",
            ],
            "features": [
                "comfort": [
                    "home_automation": true, "fireplace": false
                ],
                "ecology": [
                    "solar_panels": true, "rainwater_harvesting": true
                ],
                "heating_cooling": [
                    "central_heating": true
                ],
                "security": [
                    "concierge": true
                ]
            ]
        ]
        let feature = SWBFeaturesModel()
        feature.initWithJSON(JSON(featureJSON))

        XCTAssertEqual(feature.bathroom, SWBGeneralCondition.New)
        XCTAssertEqual(feature.kitchen, SWBGeneralCondition.Mint)

        let featureList = feature.listOfFeatures
        XCTAssertEqual(featureList.count, 5)
        XCTAssert(featureList.indexOf(SWBFeature.HomeAutomation) > -1)
        XCTAssertNil(featureList.indexOf(SWBFeature.Fireplace))
        XCTAssert(featureList.indexOf(SWBFeature.SolarPanels) > -1)
        XCTAssert(featureList.indexOf(SWBFeature.RainwaterHarvesting) > -1)

        XCTAssert(featureList.indexOf(SWBFeature.CentralHeating) > -1)
        XCTAssert(featureList.indexOf(SWBFeature.Concierge) > -1)
    }

    func testAddOrRemove() {
        let feature = SWBFeaturesModel()
        XCTAssertEqual(feature.listOfFeatures.count, 0)

        feature.addOrRemove(SWBFeature.Fireplace)
        XCTAssertEqual(feature.listOfFeatures.count, 1)

        feature.addOrRemove(SWBFeature.Fireplace)
        XCTAssertEqual(feature.listOfFeatures.count, 0)
    }
}
