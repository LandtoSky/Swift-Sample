//
//  SweepBrightActionSheet.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 12/3/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import Foundation
import FloatingActionSheetController

protocol CustomActionSheet {
    func addDefaultAction(title: String, handler: (((AnyObject)) -> Void)?)
    func addDestructiveAction(title: String, handler: (((AnyObject)) -> Void)?)
    func addRedAction(title: String, handler: (((AnyObject)) -> Void)?)
    func show(viewController: UIViewController)
}

class SweepBrightActionSheet: NSObject, CustomActionSheet {

    var title: String!
    var groups: [FloatingActionGroup] = []
    var actions: [FloatingAction] = []
    var destructiveActions: [FloatingAction] = []

    override init() {
        super.init()
    }

    init(initWithTitle title: String?) {
        super.init()
        self.title = title
    }

    func addDefaultAction(title: String, handler: (((AnyObject)) -> Void)?) {
        self.actions.append(FloatingAction(title: title, handler: handler))
    }

    func addDestructiveAction(title: String, handler: (((AnyObject)) -> Void)?) {
        let action = FloatingAction(title: title, handler: handler)
        action.customTextColor = UIColor.redColor()
        action.customTintColor = UIColor.whiteColor()

        self.actions.append(action)
    }
    func addRedAction(title: String, handler: (((AnyObject)) -> Void)?) {
        let action = FloatingAction(title: title, handler: handler)
        action.customTextColor = UIColor.whiteColor()
        action.customTintColor = UIColor.redColor()

        self.actions.append(action)
    }

    private func getDestructiveGroup() -> FloatingActionGroup {
        return FloatingActionGroup(actions: self.destructiveActions)
    }
    private func getDefaultGroup() -> FloatingActionGroup {
        return FloatingActionGroup(actions: self.actions)
    }

    func show(viewController: UIViewController) {
        let controller = FloatingActionSheetController(actionGroups: [self.getDefaultGroup(), self.getDestructiveGroup()])
        controller.font = UIFont(name: "LFT Etica", size: 17.0)!
        if let title = self.title {
            controller.title = title
        }
        controller.itemTintColor = UIColor.navigationBarColor()
        controller.present(viewController)
    }

}
