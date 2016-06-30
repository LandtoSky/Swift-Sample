//
//  SWBOfflineQueue.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/4/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

protocol SWBOfflineService {
    func sync(request: String) -> NSOperation
    func getAccessToken() -> NSOperation
}

class SWBOfflineServiceClass: SWBOfflineService {
    func sync(request: String) -> NSOperation {
        return NSBlockOperation {
            let realm = try! Realm()

            guard let request = realm.objects(SWBOfflineRequest).filter("id == %@", request).first else {
                return
            }

            //get the header
            var headers: [String:String] = [:]
            for header in (request.headers) {
                headers[header.key!] = header.value
            }

            headers["Authorization"] = "Bearer \(SWBKeychain.get(.AccessToken) ?? "")"

            var response: NSHTTPURLResponse?

            NSLog("Offline sync \(request.id): started")
            SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(Alamofire.Method(rawValue:request.method)!, url: (request.url)!, body: request.body!, headers: headers, completionHandler: {
                resp in
                response = resp.response
                debugPrint(resp.response?.statusCode)
            })

            //Not still offline
            if response != nil {

                NSLog("Offline sync \(request.id): removed")
                try! realm.write({
                    realm.delete(request)
                })
            } else {
                NSLog("Offline sync \(request.id): finished")
            }
        }
    }

    func getAccessToken() -> NSOperation {
        return SWBRoutes.getAccessToken()
    }
}

class SWBParameter: Object {
    dynamic var key: String?
    dynamic var value: String?
}

class SWBOfflineRequest: Object {
    private(set) dynamic var id = NSUUID().UUIDString
    dynamic var method: String = "POST"
    dynamic var url: String?
    dynamic var body: NSData? = nil
    let headers = List<SWBParameter>()
    dynamic var createdAt = NSDate()

    override class func primaryKey() -> String {
        return "id"
    }
}

class SWBOfflineQueue: NSObject {
    var offlineService: SWBOfflineService = SWBOfflineServiceClass()

    static let sharedInstance = SWBOfflineQueue()
    let queue = NSOperationQueue()
    private let realm = try! Realm()

    internal var listOfRequests: Results<SWBOfflineRequest>!
    internal var notificationToken: NotificationToken!
    let interval: Double = 60*5 //5 minutes
    var timer: NSTimer!

    internal override init() {
        super.init()
        queue.qualityOfService = .Background

        timer = NSTimer.scheduledTimerWithTimeInterval(self.interval, target: self, selector: #selector(SWBOfflineQueue.startTimer), userInfo: nil, repeats: true)

    }

    func addRequest(request: SWBOfflineRequest, waitUntilFinished: Bool = false) {
        //This method may be execute in a different thread, that's why there is a new realm variable
        try! realm.write({
            realm.add(request)
            self.start(waitUntilFinished)
        })
    }
    internal func startTimer() {
        self.start()
    }

    private func getOperations() -> [NSOperation] {

        let accessTokenOp = self.offlineService.getAccessToken()

        //Create a queue of requests
        var operations: [NSOperation] = [accessTokenOp]
        for request in self.requests {
            let offlineOp = self.offlineService.sync(request.id)
            offlineOp.addDependency(accessTokenOp)
            operations.append(offlineOp)
        }
        return operations
    }


    func start(waitUntilFinished: Bool = false) {
        if queue.operationCount < 0 {
            NSLog("The queue is running")
            return
        }

        let operations = self.getOperations()
        self.queue.addOperations(operations, waitUntilFinished: waitUntilFinished)

    }

    //List of requests pendents (read-only)
    var requests: Results<SWBOfflineRequest>! {
        get {
            //get que list only once
            if let request = self.listOfRequests {
                return request
            } else {
                self.listOfRequests = self.realm.objects(SWBOfflineRequest).sorted("createdAt")
                return self.listOfRequests
            }
        }
    }
}
