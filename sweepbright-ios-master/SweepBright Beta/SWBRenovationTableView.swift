//
//  SWBRenovationTableView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/1/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

class SWBRenovationTableView: UITableView {
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
        self.registerNib(UINib(nibName: "SWBRenovatedCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: SWBRenovatedCellIdentifier)
        self.registerNib(UINib(nibName: "SWBEditTextCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: SWBEditTextCellIdentifier)
        self.estimatedRowHeight = UITableViewAutomaticDimension
        self.dataSource = self
        self.delegate = self
    }
}

extension SWBRenovationTableView: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let numberOfEditTextRow = 1

        switch indexPath.row {
        case numberOfEditTextRow:
            return 88.0
        default:
            return 44.0
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension SWBRenovationTableView: UITableViewDataSource {
    var items: [String] {
        return [SWBRenovatedCellIdentifier, SWBEditTextCellIdentifier]
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
