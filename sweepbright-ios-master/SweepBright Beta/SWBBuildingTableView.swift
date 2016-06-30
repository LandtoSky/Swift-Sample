//
//  SWBBuildingTableView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBBuildingTableView: UITableView {
    var service: SWBFeaturesServiceDelegate?

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    func initialize() {
        //The cells will be loaded from SWBFeaturesCell nib file on UI/SWBEdit/SWBFeatures
        let nib = UINib(nibName: "SWBBuilding", bundle: NSBundle.mainBundle())
        self.registerNib(nib, forCellReuseIdentifier: SWBYearBuiltCellIdentifier)

        self.registerNib(UINib(nibName: "SWBArchitect", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: SWBArchitectCellIdentifier)
        self.delegate = self
        self.dataSource = self
    }
}

extension SWBBuildingTableView: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension SWBBuildingTableView: UITableViewDataSource {
    var items: [String] {
        return [SWBArchitectCellIdentifier, SWBYearBuiltCellIdentifier]
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(items[indexPath.row], forIndexPath: indexPath) as! SWBFeatureCell
        cell.service = self.service
        return cell
    }

}
