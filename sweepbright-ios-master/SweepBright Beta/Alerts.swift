//
//  Alerts.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 12/3/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import Foundation
import SCLAlertView
import JDStatusBarNotification

enum AlertType: String {
    case Default = "SWBStyle"
    case Error   = "JDStatusBarStyleError"
}

class AlertFactory: NSObject {

    class func loadingAlert(withTitle title: String, onController controller: UIViewController, animated: Bool, completionHandler:(() -> Void)?) {
        controller.presentViewController(loadingAlert(withTitle: title), animated: animated, completion: completionHandler)
    }

    class func loadingAlert(withTitle title: String?) -> UIAlertController {
        //Instance an Alert with connecting message
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .Alert)

        //Instance an UIActivityIndicatorView
        //create an activity indicator

        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: alert.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray

        //Add UIActivityIndicatorView to alert
        alert.view.addSubview(loadingIndicator)

        //starts UIActivityIndicatorView animation
        loadingIndicator.userInteractionEnabled = false
        loadingIndicator.startAnimating()

        return alert

    }

    class func errorNotification(viewController: UIViewController, message: String) {
        JDStatusBarNotification.showWithStatus(message, dismissAfter: 1.0, styleName: JDStatusBarStyleError)
    }

    class func saveAndDiscardChanges(viewController: UIViewController, saveChangesHandler:(() -> Void)?) {

        //Prevent leave without save the object
        let alert = SweepBrightActionSheet(initWithTitle: "Are you sure you want to ignore the changes?")
        alert.addDefaultAction("Save changes", handler: {
            _ in
            saveChangesHandler!()
            viewController.navigationController?.popViewControllerAnimated(true)
        })
        alert.addRedAction("Discard changes", handler: {
            _ in
            viewController.navigationController?.popViewControllerAnimated(true)
        })
        alert.addDestructiveAction("Cancel", handler: nil)
        alert.show(viewController)
    }

    class func gettingAddressInformation(viewController: UIViewController) {
        let alert = UIAlertController(title: "Getting Address information", message: nil, preferredStyle: .Alert)
        alert.modalPresentationStyle = .PageSheet
        viewController.presentViewController(alert, animated: true, completion: nil)
    }

    class func loadingTopBarMessage(status: String!, dismissAfter: NSTimeInterval = 0.0, style: AlertType = .Default) {
        dismissAfter > 0.0 ?
            JDStatusBarNotification.showWithStatus(status, dismissAfter: dismissAfter, styleName: style.rawValue)
            : JDStatusBarNotification.showWithStatus(status, styleName: style.rawValue)
    }
    class func showProgres(progress: CGFloat) {
        JDStatusBarNotification.showProgress(progress)
    }
    class func dismissTopBarMessage() {
        JDStatusBarNotification.dismiss()
    }
}
