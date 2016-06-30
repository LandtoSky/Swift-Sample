//
//  SweepBrightIntegrationTests.swift
//  SweepBrightIntegrationTests
//
//  Created by Kaio Henrique on 4/22/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
import Alamofire
@testable import SweepBright

class SweepBrightIntegrationTests: XCTestCase, UIApplicationDelegate {
    var queue: NSOperationQueue! = NSOperationQueue()

    let username = "kaio@madewithlove.be"
    let accessToken = "22xX43GXjTOtPK0XnpbYzNbZCkGmAaxW9LDCxRRw"
    let refreshToken = "dzdPtn0d7Wd3UUrNfKdgSyBSwyLK0N1rM9DDz6nl"

    override func setUp() {
        super.setUp()
        self.insertTokens()

        self.queue = NSOperationQueue()
        SWBSynchronousRequestFactory.globalResponserHandler = nil
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func insertTokens() {
        SWBKeychain.set(accessToken, forKey: .AccessToken)
        SWBKeychain.set(refreshToken, forKey: .RefreshToken)
        SWBKeychain.set(NSDate(), forKey: .TokenUpdatedAt)
        SWBKeychain.set("64000", forKey: .ExpiresIn)
    }
    func updateProperty(withId id: String) {
        let getObjectBlock = NSBlockOperation {
            SWBRoutes.getProperty(withId: id, completionHandler: { _ in })
        }
        getObjectBlock.addDependency(SWBRoutes.getAccessToken())
        self.runAsyncTest(getObjectBlock)
    }

    func runAsyncTest(operation: NSOperation) {

        let asyncExpectation = expectationWithDescription(self.name!)
        operation.completionBlock = {
            asyncExpectation.fulfill()
        }
        self.queue.addOperation(operation)
        self.queue.addOperations(operation.dependencies, waitUntilFinished: false)

        self.waitForExpectationsWithTimeout(30, handler: nil)
    }

    func updateProperties(handler: XCWaitCompletionHandler? = nil) {
        let service = SWBPropertyService()
        let asyncExpectation = expectationWithDescription(self.name!)
        service.updateListOfProperties({
            asyncExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(30, handler: handler)
    }

    func expecting(statusCode status: Int) {
        SWBSynchronousRequestFactory.globalResponserHandler = { response in
            XCTAssertNotNil(response.response)
            XCTAssertEqual((response.response!.statusCode), status)
        }
    }
}
