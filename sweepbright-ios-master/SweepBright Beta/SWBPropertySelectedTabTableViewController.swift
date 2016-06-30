//
//  SWBPropertySelectedTabTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBPropertySelectedTabTableViewController: UITabBarController, PropertyDependent {
    var property: SWBProperty!
    let maxPositionOfTabItems = 4
    var tabDelegate = SynchronizedTabDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self.tabDelegate
        for viewController in self.viewControllers! {
            if let propertyDependent = viewController as? PropertyDependent {
                propertyDependent.propertyDependent(self.property)
            }
        }
        if let _ = property.project {
            self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarProject()
        }
        //Select the same view controller than home tab bar controller (Visit -> Visit, not Visit -> Properties)
        self.selectedIndex = min(SWBCounterSingleton.sharedIndex, maxPositionOfTabItems)
    }
}

//MARK: Delegate
class SWBPropertySelectedNavigationController: UINavigationController, PropertyDependent {
    var property: SWBProperty!

    override var navigationController: UINavigationController? {
        return self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for viewController in self.viewControllers {
            if let propertyDependent = viewController as? PropertyDependent {
                propertyDependent.propertyDependent(self.property)
            }
        }
    }
}
