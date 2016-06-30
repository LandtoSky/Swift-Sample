//
//  SWBNavigationBar.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/11/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBNavigationItem: UINavigationItem {
    let titleLabel = UILabel()
    override var backBarButtonItem: UIBarButtonItem? {
        get {
            let barButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
            barButton.image = UIImage()
            return barButton
        } set {

        }
    }
    override var title: String? {
        didSet {
            self.updateTitleView()
        }
    }

    override init(title: String) {
        super.init(title: title)
        self.updateTitleView()
        titleLabel.sizeToFit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.updateTitleView()
        titleLabel.sizeToFit()
    }

    func updateTitleView() {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center

        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "LFT Etica", size: 12.0)!,
            NSKernAttributeName: CGFloat(1.71),
            NSParagraphStyleAttributeName: paragraphStyle
        ]

        titleLabel.attributedText = NSAttributedString(string: (self.title?.uppercaseString) ?? "", attributes: attributes)

        self.titleView = titleLabel
    }
}
