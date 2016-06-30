//
//  SWBOfflineQueueTestCase.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/4/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import XCTest
import RealmSwift
@testable import SweepBright

class SWBOfflineQueueTestCase: XCTestCase {

    class SWBOfflineServiceMock: SWBOfflineService {
        var executed: Bool = false
        func sync(request: String) -> NSOperation {
            return NSBlockOperation {
                self.executed = true
            }
        }

        func getAccessToken() -> NSOperation {
            return NSBlockOperation {

            }
        }
    }
    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        let realm = try! Realm()
        realm.beginWrite()
        realm.deleteAll()
        try! realm.commitWrite()
    }

    func testStartQueue() {
        let offlineQueue = SWBOfflineQueue.sharedInstance

        let offlineService = SWBOfflineServiceMock()

        offlineQueue.offlineService = offlineService
        offlineQueue.start(true)
        XCTAssertFalse(offlineService.executed)

        let realm = try! Realm()
        try! realm.write({
            realm.create(SWBOfflineRequest.self, value:["url":"http://google.com"])
        })

        XCTAssertFalse(offlineService.executed)
        offlineQueue.start(true)
        XCTAssert(offlineService.executed)
    }


    func testStartQueueAfterInsertNewRequest() {
        let offlineQueue = SWBOfflineQueue.sharedInstance
        let offlineService = SWBOfflineServiceMock()
        offlineQueue.offlineService = offlineService
        offlineQueue.start(true)
        XCTAssertFalse(offlineService.executed)

        offlineQueue.addRequest(SWBOfflineRequest(value:["url":"http://google.com"]), waitUntilFinished: true)

        XCTAssert(offlineService.executed)
    }
}
