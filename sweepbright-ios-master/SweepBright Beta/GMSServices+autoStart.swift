//
//  GMSServices+autoStart.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import GoogleMaps

extension GMSServices {
    class func provideAPI() {
        NSLog("GMSServices:provideAPI")
        GMSServices.provideAPIKey("AIzaSyB8-Uawv7TrtYNaesQgLiX0xlafSCHVycQ")
    }
}
