//
//  SWBLegalDocService.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/21/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

enum SWBTenantDates: String {
    case StartDate = "start_date"
    case EndDate = "end_date"
}

protocol SWBLegalDocServiceProtocol: SWBService {
    func syncLegalDocs(legalDocs: SWBLegalDocs)
    func syncTenantContractDate(legalDocs: SWBLegalDocs, path: SWBTenantDates, value: NSDate)
}

class SWBLegalDocsService: SWBLegalDocServiceProtocol {
    var queue: NSOperationQueue! = NSOperationQueue()
    var completionHandler: (Response<AnyObject, NSError> -> Void)? = nil

    func syncTenantContractDate(legalDocs: SWBLegalDocs, path: SWBTenantDates, value: NSDate) {
        AlertFactory.loadingTopBarMessage("Syncing contract date", dismissAfter: 0.5)
        self.saveLegalAndDocs(legalDocs as! SWBLegalDocsModel)

        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let dateStr = formatter.stringFromDate(value)

        self.setValueForProperty(legalDocs.id, op: "add", path: "/tenant_contract/\(path.rawValue)", value: dateStr, completionHandler: self.completionHandler)
    }

    func syncLegalDocs(legalDocs: SWBLegalDocs) {
        AlertFactory.loadingTopBarMessage("Syncing Legal & Docs", dismissAfter: 1.0)
        NSLog("syncLegalDocs: started")

        self.saveLegalAndDocs(legalDocs as! SWBLegalDocsModel)

        let parameters = legalDocs.toJSON()
        self.setValueForProperty(legalDocs.id, op: "add", path: "/energy", value: parameters, completionHandler: self.completionHandler)
        NSLog("syncLegalDocs: finished")
    }

    private func saveLegalAndDocs(legalDocs: SWBLegalDocsModel) {
        let legalAndDocs = SWBLegalDocsModel(value:legalDocs)

        let realm = try! Realm()
        try! realm.write({
            realm.add(legalAndDocs, update: true)
        })
    }
}
