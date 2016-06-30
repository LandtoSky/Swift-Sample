//
//  SWBFeaturesTableView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

struct SWBFeatureParameter {
    var property: SWBProperty?
    var feature: SWBFeature
    var group: SWBFeatureGroup
}

class SWBFeatureCell: UITableViewCell {
    var service: SWBFeaturesServiceDelegate?
}

extension SWBFeatureCell {
    var property: SWBProperty? {
        return self.service?.property
    }
}
