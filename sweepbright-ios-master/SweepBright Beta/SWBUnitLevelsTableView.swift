//
//  SWBUnitLevelsTableView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBUnitLevelsTableView: UITableView, UITableViewDataSource {
    let reuseIdentifier = "UnitLevelCell"
    var listOfUnits: [SWBProjectProtocol] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataSource = self
    }

    //MARK: Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfUnits.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SWBUnitCell
        let unit = self.listOfUnits[indexPath.row]

        cell.levelLabel.text = unit.level
        cell.priceLabel.text = "\(unit.price)"
        cell.totalOfRooms.text = "\(unit.totalOfRooms)"
        return cell
    }
}
