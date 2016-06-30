//
//  SectionDatasource.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

protocol SectionDatasource: UITableViewDataSource {
    var sections: [Section] {get set}
}

extension SectionDatasource {
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = self.sections[indexPath.section].cells[indexPath.row]
        return tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
}
