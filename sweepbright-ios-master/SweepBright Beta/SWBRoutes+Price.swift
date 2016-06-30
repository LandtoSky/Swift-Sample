//
//  SWBRoutes+Price.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

extension SWBRoutes {

    class func updatePrice(params: SWBPrice) -> NSOperation {
        return NSBlockOperation {
            NSLog("updatePrice: started")
            let price = Price(value: params as! Price)

            //create the parameters
            let parameters = [
                [
                    "op":"add",
                    "path":"/price",
                    "value":[
                        "costs" : price.costs,
                        "taxes" : price.taxes,
                        "published_price" : [
                            "amount":price.value,
                            "currency": price.currency.rawValue
                        ]
                    ]
                ]
            ]

            self.updatePropertyRequest(price.id, parameters: parameters, completionHandler: {
                response in

            })

            NSLog("updatePrice: finished")
        }
    }
}
