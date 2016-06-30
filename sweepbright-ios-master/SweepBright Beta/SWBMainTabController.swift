//
//  SWBMainTabController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 2/2/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SWBCounterSingleton: NSObject {
    static let indexChangedNotification: String = "indexChangedNotification"
    private static var index: Int = 0

    static var sharedIndex: Int {
        get {
            return index
        } set (newIndex) {
            self.index = newIndex
            NSNotificationCenter.defaultCenter().postNotificationName(indexChangedNotification, object: self.index)
        }
    }
}

class SynchronizedTabDelegate: NSObject, UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        SWBCounterSingleton.sharedIndex = tabBarController.viewControllers?.indexOf(viewController) ?? 0
    }
}

class SWBMainTabController: UITabBarController, CRMContactService {
    var propertyService: SWBPropertyServiceProtocol = SWBPropertyService()
    var queue: NSOperationQueue! = NSOperationQueue()
    var tabDelegate = SynchronizedTabDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self.tabDelegate
        self.updateContactsList()

        self.propertyService.updateListOfProperties({
            SWBOfflineQueue.sharedInstance.start()
        })

        NSNotificationCenter.defaultCenter().rac_addObserverForName(SWBCounterSingleton.indexChangedNotification, object: nil).subscribeNext({ _ in
//            self.selectedIndex = min(SWBCounterSingleton.sharedIndex, self.viewControllers?.count ?? 0)
        })
    }
}
