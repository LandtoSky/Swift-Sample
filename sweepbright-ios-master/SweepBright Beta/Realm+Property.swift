//
//  Realm+Property.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/16/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    func add(property property: SWBPropertyModel) {
        NSLog("addNewProperty: started")
        self.beginWrite()
        self.add(property)
        try! self.commitWrite()
        NSLog("addNewProperty: finished")
    }

    func add(project project: SWBPropertyModel) {
        NSLog("addNewProject: started")

        self.beginWrite()
        project.project = SWBProjectModel(value: ["id": project.id])
        self.add(project)

        try! self.commitWrite()
        NSLog("addNewProject: finished")
    }
}
