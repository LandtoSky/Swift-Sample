//
//  SWBClientViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/6/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import Haneke

let SWBClientViewCellCallNotification = "negotiatorCalledSomeone"

let SWBClientViewCellNewMailNotification = "negotiatorWantsToSendAMail"
class SWBClientViewCell: UIView, CRMContactDependent {
    var contact: CRMContact! {
        didSet {
            self.profilePicture.profile = self.contact
            self.clientNameLabel.text = self.contact?.fullName
            self.whatsappButton.enabled = self.contact.is_whatsapp_user
            self.phoneButton.enabled = !(self.contact.phone?.isEmpty ?? true)
        }
    }
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var whatsappButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet var profilePicture: ProfilePictureView!

    var phoneNumber: String {
        return self.contact?.phone ?? ""
    }

    @IBAction func phoneCall(sender: AnyObject) {
        if let url = NSURL(string: "tel://\(self.phoneNumber)") {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)

                // Delay 1 seconds
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(SWBClientViewCellCallNotification, object: nil)
                }
            }
        }
    }

    @IBAction func sendMail(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(SWBClientViewCellNewMailNotification, object: nil)
    }
    class func loadFromNib() -> SWBClientViewCell {
        let nib = UINib(nibName: "SWBMatchClientView", bundle: nil)
        return nib.instantiateWithOwner(SWBClientViewCell.self, options: nil)[0] as! SWBClientViewCell
    }
}
