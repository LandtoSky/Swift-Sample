//
//  SWBFeaturesDatasources.swift
//  SweepBright
//
//  Created by Kaio Henrique on 3/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

protocol SWBFeaturesDatasourceProtocol: UITableViewDataSource {
    var service: SWBFeaturesServiceDelegate? {get set}
    var items: [SWBFeature] {get}
    var group: SWBFeatureGroup {get}
}

internal class SWBFeatureDatasource: NSObject, SWBFeaturesDatasourceProtocol {
    var service: SWBFeaturesServiceDelegate?
    var group: SWBFeatureGroup {
        return .None
    }

    //Group the feature per category (Comfort, Eco, HC, Energy ...)
    var items: [SWBFeature] {
        return []
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //The cell view will be loaded from SWBFeatureCell.nib
        let cell = tableView.dequeueReusableCellWithIdentifier("featureCell", forIndexPath: indexPath) as! SWBFeatureSwitchCell
        let feature = items[indexPath.row]
        cell.service = self.service
        cell.parameter = SWBFeatureParameter(property: self.service?.property, feature: feature, group: self.group)
        return cell
    }
}

class SWBComfortDatasource: SWBFeatureDatasource {
    override var group: SWBFeatureGroup {
        return .Comfort
    }

    override var items: [SWBFeature] {
        return [.HomeAutomation, .WaterSoftener, .Fireplace, .WalkInCloset, .HomeCinema, .WineCellar, .Sauna, .FitnessRoom]
    }
}

class SWBEcoDatasource: SWBFeatureDatasource {
    override var group: SWBFeatureGroup {
        return .Eco
    }

    override var items: [SWBFeature] {
        return [.DoubleGlazing, .SolarPanels, .SolarBoiler, .RainwaterHarvesting]
    }
}

class SWBHCSystemDatasource: SWBFeatureDatasource {
    override var group: SWBFeatureGroup {
        return .HC
    }

    override var items: [SWBFeature] {
        return [.CentralHeating, .FloorHeating, .AirConditioning]
    }
}

class SWBEnergySourceDatasource: SWBFeatureDatasource {
    override var group: SWBFeatureGroup {
        return .EnergySource
    }

    override var items: [SWBFeature] {
        return [.Gas, .Fuel, .Electricity]
    }
}

class SWBSecurityDatasource: SWBFeatureDatasource {
    override var group: SWBFeatureGroup {
        return .Security
    }

    override var items: [SWBFeature] {
        return [.Alarm, .Concierge, .VideoSurveillance]
    }
}

//Only for Land properties
class SWBPermissionsDatasource: SWBFeatureDatasource {
    override var group: SWBFeatureGroup {
        return .Permissions
    }

    override var items: [SWBFeature] {
        return [.Construction, .Planning, .Farming, .Fishing]
    }
}
