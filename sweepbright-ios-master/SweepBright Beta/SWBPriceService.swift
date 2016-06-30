//
//  SWBPriceService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift

protocol SWBPriceServiceProtocol: SWBService {
    func updatePrice(price: Price, completionBlock: (()->())?)
}

class SWBPriceService: SWBPriceServiceProtocol {
    var queue: NSOperationQueue! = NSOperationQueue()

    init() {
        self.queue.name = "SWBPriceService"
    }

    func updatePrice(price: Price, completionBlock: (()->())? = nil) {
        AlertFactory.loadingTopBarMessage("Updating price", dismissAfter: 0.5)

        let realm = try! Realm()

        let updateObject = NSBlockOperation {
            NSLog("updatePrice: save object: started")
            let price = Price(value: price)

            //Avoid problems in thread an Realm
            dispatch_async(dispatch_get_main_queue(), {
                try! realm.write {
                    realm.add(price, update: true)
                }
            })
            NSLog("updatePrice: save object: finished")
        }

        let accessTokenOP = SWBRoutes.getAccessToken()
        let syncOp = SWBRoutes.updatePrice(price)

        //Add dependencies
        syncOp.addDependency(accessTokenOP)
        syncOp.completionBlock = completionBlock

        self.queue.addOperations([accessTokenOP, syncOp, updateObject], waitUntilFinished: false)
    }
}
