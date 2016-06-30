//
//  NSDate+formatter.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

extension NSDate {
    func inShortFormat() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.stringFromDate(self)
    }
}
