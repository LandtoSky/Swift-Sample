//
//  SWBRoutes+settings.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

extension SWBRoutes {
    class func archive(propertyWithId propertyId: String) -> NSOperation {
        return NSBlockOperation {
            //Populate the header
            let header = [
                "Content-Type": "application/json-patch+json",
                "Authorization": "Bearer \(SWBKeychain.get(.AccessToken) ?? "")"
            ]

            SWBSynchronousRequestFactory.sharedInstance.requestSynchronous(.POST, url: "\(self.SWBSERVERURL)/properties/\(propertyId)/archive", parameters: nil, headers: header, completionHandler: {
                _ in

            })
        }
    }
}
