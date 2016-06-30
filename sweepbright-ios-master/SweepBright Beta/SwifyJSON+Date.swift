//
//  SwifyJSON+Date.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/9/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {

    public var date: NSDate? {
        get {
            switch self.type {
            case .String:
                return Formatter.jsonDateFormatter.dateFromString(self.object as! String)
            default:
                return nil
            }
        }
    }

    public var dateTime: NSDate? {
        get {
            switch self.type {
            case .String:
                return Formatter.jsonDateTimeFormatter.dateFromString(self.object as! String)
            default:
                return nil
            }
        }
    }

}

class Formatter {

    private static var internalJsonDateFormatter: NSDateFormatter?
    private static var internalJsonDateTimeFormatter: NSDateFormatter?

    static var jsonDateFormatter: NSDateFormatter {
        if internalJsonDateFormatter == nil {
            internalJsonDateFormatter = NSDateFormatter()
            internalJsonDateFormatter!.dateFormat = "yyyy-MM-dd"
        }
        return internalJsonDateFormatter!
    }

    static var jsonDateTimeFormatter: NSDateFormatter {
        if internalJsonDateTimeFormatter == nil {
            internalJsonDateTimeFormatter = NSDateFormatter()
            internalJsonDateTimeFormatter!.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        return internalJsonDateTimeFormatter!
    }

}
