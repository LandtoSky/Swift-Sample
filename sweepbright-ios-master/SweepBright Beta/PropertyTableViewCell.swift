//
//  PropertyTableViewCell.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 24/11/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

class PropertyTableViewCell: UITableViewCell {

    private var timer: NSTimer!
    private let formatter = NSDateFormatter()

    var property: SWBProperty! {
        didSet {
            if let _ = self.property.project {
                let lightGray = UIColor.navigationBarColor()
                self.backgroundColor = lightGray.colorWithAlphaComponent(0.1)
            } else {
                self.backgroundColor = UIColor.whiteColor()
            }
        }
    }

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var imageProperty: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.formatter.dateStyle = .ShortStyle
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
