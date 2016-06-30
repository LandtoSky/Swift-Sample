//
//  AppDelegate.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 24/11/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import KeychainSwift
import RealmSwift
import GoogleMaps
import JDStatusBarNotification


let SWBStyle = "SWBStyle"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func configureAppearence() {
        NSLog("Setting Appearance")
        UIProgressView.appearance().tintColor = UIColor.greenProgressBar()

        //Bar items color
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //Bar color
        UINavigationBar.appearance().barTintColor = UIColor.navigationBarColor()
        //Bar text style
        let font = UIFont(name: "LFTEtica-Light", size: 12.0)!
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSKernAttributeName:CGFloat(12.0)
        ]

        let image = UIImage(named: "back-spaced")?.imageWithAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -4.5, right: 0))

        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image

        //tab bar color
        UITabBar.appearance().tintColor = UIColor.navigationBarColor()

        //Font of labels on table view sections
        UILabel.appearanceWhenContainedInInstancesOfClasses([UITableViewHeaderFooterView.self]).font = UIFont(name: "LFT Etica", size: 11.0)

        UISwitch.appearance().onTintColor = UIColor.switchOnTintColor()
        UISearchBar.appearance().barTintColor = UIColor.searchBarColor()
        UISegmentedControl.appearance().tintColor = UIColor.navigationBarColor()

        UISegmentedControl.appearance().tintColor = UIColor.lightGrayColor()
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.navigationBarColor()], forState: .Normal)
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?.imageWithRenderingMode(.AlwaysOriginal).resizableImageWithCapInsets(UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        let controlNormalBackground = UIImage(named: "controlNormalBackground")?.imageWithRenderingMode(.AlwaysOriginal).resizableImageWithCapInsets(UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, forState: .Selected, barMetrics: .Default)
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, forState: .Highlighted, barMetrics: .Default)
        UISegmentedControl.appearance().setBackgroundImage(controlNormalBackground, forState: .Normal, barMetrics: .Default)
        UISegmentedControl.appearance().setDividerImage(UIImage(named: "controlRightSelected"), forLeftSegmentState: .Normal, rightSegmentState: .Selected, barMetrics: .Default)
        UISegmentedControl.appearance().setDividerImage(UIImage(named: "controlLeftSelected"), forLeftSegmentState: .Selected, rightSegmentState: .Normal, barMetrics: .Default)
        UISegmentedControl.appearance().setDividerImage(UIImage(named: "controlNoneSelected"), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)

        //Add a custom style to be used on AlertFactory class
        JDStatusBarNotification.addStyleNamed(SWBStyle, prepare: {
            style in
            style.barColor = UIColor.navigationBarColor()
            style.textColor = UIColor.whiteColor()
            return style
        })

        NSLog("Setting Appearance: finished")
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.configureAppearence()

        Fabric.with([Crashlytics.self])
        GMSServices.provideAPI()
        self.dbMigration()

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            NSLog("persistence")

            let clearDB = NSUserDefaults.standardUserDefaults().objectForKey("clear_db") as? Bool ?? false
            if clearDB {
                NSLog("persistence: Clear database")
                let realm = try! Realm()
                try! realm.write({
                    realm.deleteAll()
                })
                NSUserDefaults.standardUserDefaults().setValue(false, forKey: "clear_db")
                NSLog("persistence: Clear database: finished")
            }

            NSLog("persistence: finished")
        })

        self.clearCredentials()

        return true
    }

    func clearCredentials() {
        let clearCredentials = NSUserDefaults.standardUserDefaults().objectForKey("clear_data") as? Bool ?? false
        let forceToClearCredentials = NSUserDefaults.standardUserDefaults().objectForKey("force_clear_data") as? Bool ?? true
        if clearCredentials || forceToClearCredentials {
            NSLog("persistence: Clear credentials")
            SWBKeychain.clear()
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "force_clear_data")
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "clear_data")
            NSLog("persistence: Clear credentials: finished")
        }
    }

    func dbMigration() {
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 28,
            deleteRealmIfMigrationNeeded: true,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in

                migration.enumerate(SWBOfflineRequest.className()) { oldObject, newObject in

                    if oldSchemaVersion < 3 {
                        newObject!["method"] = "POST"
                    }
                }
                migration.enumerate(SWBFeaturesModel.className(), {
                    oldObject, newObject in
                    if oldSchemaVersion < 24 {
                        newObject!["id"] = NSUUID().UUIDString.lowercaseString
                    }
                })
                migration.enumerate(SWBLegalDocsModel.className(), {
                    oldObject, newObject in
                    if oldSchemaVersion < 24 {
                        newObject!["id"] = NSUUID().UUIDString.lowercaseString
                    }
                })
                migration.enumerate(SWBPropertyLocationModel.className(), {
                    oldObject, newObject in
                    if oldSchemaVersion < 24 {
                        newObject!["id"] = NSUUID().UUIDString.lowercaseString
                    }
                })
                migration.enumerate(SWBPropertyRoomClass.className()) { oldObject, newObject in

                    if oldSchemaVersion < 7 {
                        newObject!["floors"] = 0
                    }
                    if oldSchemaVersion < 24 {
                        newObject!["id"] = NSUUID().UUIDString.lowercaseString
                    }
                }

                migration.enumerate(Price.className()) { oldObject, newObject in

                    if oldSchemaVersion < 11 {
                        newObject!["id"] = NSUUID().UUIDString.lowercaseString
                    }
                    if oldSchemaVersion < 24 {
                        newObject!["id"] = NSUUID().UUIDString.lowercaseString
                    }
                }
        })
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if let queryItems = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)?.queryItems {
            if let accessToken = queryItems.filter({$0.name == "access_token"}).first?.value,
                let refreshToken = queryItems.filter({$0.name == "refresh_token"}).first?.value,
                let expiresIn = queryItems.filter({$0.name == "expires_in"}).first?.value {
                SWBKeychain.set(accessToken, forKey: .AccessToken)
                SWBKeychain.set(refreshToken, forKey: .RefreshToken)
                SWBKeychain.set(expiresIn, forKey: .ExpiresIn)
                SWBKeychain.set(NSDate(), forKey: .TokenUpdatedAt)

                NSUserDefaults.standardUserDefaults().setValue(false, forKey: "force_clear_data")
                NSUserDefaults.standardUserDefaults().setValue(false, forKey: "clear_data")
            }
        }
        return true
    }

    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if let index = Int(shortcutItem.type) {
            SWBCounterSingleton.sharedIndex = index
        }
    }
}
