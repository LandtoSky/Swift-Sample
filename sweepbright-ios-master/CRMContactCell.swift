//
//  CRMContactCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMContactCell: UITableViewCell {
    @IBOutlet weak var contactName: UIButton!

    @IBOutlet weak var typeOfContactStackView: UIStackView!
    @IBOutlet weak var typeOfContact: UILabel!
    @IBOutlet weak var typeOfContactIcon: UIImageView!

    @IBOutlet weak var statusContact: UIButton!
    @IBOutlet var profilePicture: ProfilePictureView!
    var contact: CRMContact! {
        didSet {
            self.contactName.setTitle(contact.fullName, forState: .Normal)
            self.profilePicture?.profile = self.contact
            if self.contact.contactType == .Lead {
                if let preferences = self.contact.preferences {
                    self.typeOfContactIcon.image = UIImage(named: "crm-investor")
                    self.typeOfContact.text = "Investor"
                    self.typeOfContactStackView.hidden = !preferences.is_investor
                }
            } else {
                self.typeOfContactStackView.hidden = false
                self.typeOfContactIcon.image = UIImage(named: "crm-vendor")
                self.typeOfContact.text = "Vendor"
            }
        }
    }
}
