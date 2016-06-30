//
//  SWBFeatureTableViewTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/29/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import UIKit
@testable import SweepBright

class SWBFeatureTableViewTestCase: XCTestCase {
    var tableView: SWBFeaturesTableView!
    var service: MockFeaturesService!

    override func setUp() {
        super.setUp()
        self.tableView = SWBFeaturesTableView()
        self.service = MockFeaturesService()

    }

    func setDatasource(datasource: SWBFeatureDatasource) {
        tableView.dataSource = datasource
        tableView.service = service

        tableView.reloadData()

    }

    func testDatasource() {
        let comfortDatasource = SWBComfortDatasource()
        self.setDatasource(comfortDatasource)

        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SWBFeatureSwitchCell
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.service)
        XCTAssertEqual(cell.parameter.feature, SWBFeature.HomeAutomation)
        XCTAssertEqual(cell.titleLabel.text, SWBFeature.HomeAutomation.title())
    }

    func testService() {
        let comfortDatasource = SWBComfortDatasource()
        comfortDatasource.service = self.service
        self.setDatasource(comfortDatasource)

        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SWBFeatureSwitchCell

        self.service.syncedFeatures = false
        cell.toggle.setOn(!cell.toggle.on)
        XCTAssert(self.service.syncedFeatures)
    }
}
