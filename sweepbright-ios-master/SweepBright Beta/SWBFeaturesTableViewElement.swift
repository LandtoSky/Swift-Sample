//
//  SWBFeaturesTableViewElement.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/29/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBFeaturesTableView: UITableView {
    var service: SWBFeaturesServiceDelegate? {
        didSet {
            if let ds = self.dataSource as? SWBFeaturesDatasourceProtocol {
                ds.service = self.service
            }
        }
    }

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
        let nib = UINib(nibName: "SWBFeaturesCell", bundle: NSBundle.mainBundle())
        self.registerNib(nib, forCellReuseIdentifier: "featureCell")
        self.delegate = self
    }
}

extension SWBFeaturesTableView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
