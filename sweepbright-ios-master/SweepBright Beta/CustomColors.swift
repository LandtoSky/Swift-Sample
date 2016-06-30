//
//  CustomColors.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 24/11/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

//add colors used on the project
extension UIColor {
    /** #17A8E6
     - returns: The UIColor equivalent of #17A8E6
     */
    class func navigationBarColor() -> UIColor {
        return UIColor(red:0.09, green:0.659, blue:0.902, alpha:1.0)
    }
    /** #47C9AD
     - returns: The UIColor equivalent of #47C9AD
     */
    class func navigationBarProject() -> UIColor {
        return UIColor(red:0.28, green:0.79, blue:0.68, alpha:1.00)
    }
    /** #044059
     - returns: The UIColor equivalent of #044059
     */
    class func navigationBarShadowColor() -> UIColor {
        return UIColor(red:0.016, green:0.251, blue:0.349, alpha:1.0)
    }

    class func greenProgressBar() -> UIColor {
        return UIColor(red:0.34, green:0.75, blue:0.61, alpha:1.0)
    }

    class func blueProgressBar() -> UIColor {
        return UIColor(red:0.25, green:0.56, blue:0.93, alpha:1.0)
    }

    class func searchBarColor() -> UIColor {
        return UIColor(red:0.94, green:0.95, blue:0.95, alpha:1.00)
    }

    class func switchOnTintColor() -> UIColor {
        return UIColor(red: 0.278, green: 0.788, blue: 0.678, alpha: 1.0)
    }

    class func switchOffTintColor() -> UIColor {
        return UIColor(red: 0.941, green: 0.945, blue: 0.949, alpha: 1.0)
    }

    class func getPlanBackground() -> UIColor {
        return UIColor(red:0.941, green:0.945, blue:0.949, alpha:1.0) //#f0f1f2
    }

    class func get706a7c() -> UIColor {
        return UIColor(red:0.439, green:0.416, blue:0.486, alpha:1.0) /*#706a7c*/
    }

    class func getAAA7b0() -> UIColor {
        return UIColor(red:0.667, green:0.655, blue:0.69, alpha:1.0) /*#aaa7b0*/
    }

    class func getSliderArrayOfColours() -> [UIColor] {
        return [
            UIColor(red: 0.929, green: 0, blue: 0.345, alpha: 1.0),
            UIColor(red: 0.929, green: 0.176, blue: 0.596, alpha: 1.0),
            UIColor(red: 0.09, green: 0.659, blue: 0.902, alpha: 1.0),
            UIColor(red: 0.278, green: 0.725, blue: 0.788, alpha: 1.0),
            UIColor(red: 0.278, green: 0.788, blue: 0.678, alpha: 1.0)
        ]
    }
    class func getStepperColor() -> UIColor {
        return UIColor(red:0.34, green:0.33, blue:0.36, alpha:1.00)
    }
    /** #D7D8D9
     - returns: The UIColor equivalent of D7D8D9
     */
    class func getBorderColor() -> UIColor {
        return UIColor(red:0.84, green:0.85, blue:0.85, alpha:1.00)
    }
}
