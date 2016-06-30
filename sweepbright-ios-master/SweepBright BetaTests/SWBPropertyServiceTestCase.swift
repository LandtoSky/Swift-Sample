//
//  SWBPropertyServiceTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/4/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
import SwiftyJSON
@testable import SweepBright
class SWBPropertyServiceTestCase: XCTestCase {

    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

        let realm = try! Realm()
        try! realm.write({
            realm.deleteAll()
        })
    }

    func testAddNewProperty() {
        let realm = try! Realm()

        var properties = realm.objects(SWBPropertyModel)
        XCTAssertEqual(properties.count, 0)
        let property = SWBPropertyModel(value: ["propertyType": "house", "negotiation": "sale"])
        realm.add(property: property)
        properties = realm.objects(SWBPropertyModel)
        XCTAssertEqual(properties.count, 1)
    }

    func testCreateNewHouse() {
        let realm = try! Realm()
        var property = SWBPropertyModel(value: ["propertyType": "house", "negotiation": "let"])
        realm.add(property: property)

        property = realm.objects(SWBPropertyModel).first!

        XCTAssertEqual(property.type, SWBPropertyType.House)
        XCTAssertEqual(property.status, SWBPropertyNegotiation.ToLet)
    }

    func testCreateNewProject() {
        let realm = try! Realm()
        var property = SWBPropertyModel(value: ["propertyType": "house", "negotiation": "sale"])
        realm.add(project: property)

        property = realm.objects(SWBPropertyModel).first!

        XCTAssertEqual(property.type, SWBPropertyType.House)
        XCTAssertEqual(property.status, SWBPropertyNegotiation.ForSale)
        XCTAssertNotNil(property.project)
    }

    func getJson(fromFileName fileName: String) -> JSON {
        //Read a JSON file from the resources
        let jsonPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")!
        let data = NSData(contentsOfFile: jsonPath)!
        return JSON(data: data)
    }

    func testImportAProject() {

        //Create a wrapper with the json samples
        let wrapper = SWBPropertiesJSONWrapper()
        wrapper.projectsJSON = self.getJson(fromFileName: "project-response")
        wrapper.json = self.getJson(fromFileName: "property-response")

        let update = SWBUpdatePropertiesData(json: wrapper)

        let realm = try! Realm()
        let projects = realm.objects(SWBProjectModel.self)
        XCTAssertEqual(projects.count, 0)
        update.start()
        XCTAssertEqual(projects.count, 1)

    }
}
