//
//  SWBDescriptionServiceTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/13/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest

@testable import SweepBright
import RealmSwift
import SwiftyJSON
class SWBDescriptionServiceTestCase: SweepBrightIntegrationTests {

    var token: dispatch_once_t = 0

    override func setUp() {
        super.setUp()

        dispatch_once(&token, {
            self.updateProperties()
        })
    }

    func runTestOn(property: SWBPropertyModel) {

        //Generate an UUID as new title as description
        let newTitle = NSUUID().UUIDString
        let newDescription = NSUUID().UUIDString

        //Update description
        self.runAsyncTest(SWBRoutes.updateDescription(SWBDescriptionParameter(id: property.id, title: newTitle, desc: newDescription), completionHandler: {
            response in
            XCTAssertEqual(200, response.response!.statusCode)
        }))

        //Get latest data from the server
        self.updateProperty(withId: property.id)

        XCTAssertEqual(newTitle, property.title)
        XCTAssertEqual(newDescription, property.desc)
    }

    func testUpdatePropertyDescription() {
        //Get property
        let realm = try! Realm()
        let property = realm.objects(SWBPropertyModel.self).first!

        self.runTestOn(property)
    }

    func testUpdateProjectDescription() {
        //Get property
        let realm = try! Realm()
        let project = realm.objects(SWBProjectModel.self).first!

        self.runTestOn(project.property!)
    }
}
