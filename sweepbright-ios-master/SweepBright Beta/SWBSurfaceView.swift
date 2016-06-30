//
//  SWBSurfaceView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/13/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBSurfaceView: UIView {
    var surface: SWBSurface! {
        didSet {
            guard let room = self.surface.room else {
                return
            }

            //Creating an StackView
            let stackView = UIStackView(frame: self.bounds)
            stackView.alignment = .Center
            stackView.distribution = .FillEqually
            stackView.axis = .Vertical

            //Adding description label
            self.descriptionLabel = UILabel()
            self.descriptionLabel.text = "\(room.structure.rawValue)"
            self.descriptionLabel.font = UIFont(name: "LFT Etica", size: 13.0)
            self.descriptionLabel.textAlignment = .Center
            self.descriptionLabel.textColor = UIColor.get706a7c()
            stackView.addArrangedSubview(self.descriptionLabel)

            //add area label
            self.areaLabel = UILabel()
            self.areaLabel.text = "\(room.area) sqft"
            self.areaLabel.font = UIFont(name: "LFT Etica", size: 13.0)
            self.areaLabel.textAlignment = .Center
            self.areaLabel.textColor = UIColor.getAAA7b0()
            stackView.addArrangedSubview(self.areaLabel)

            self.addSubview(stackView)

        }
    }

    var descriptionLabel: UILabel!
    var areaLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.getPlanBackground()
        self.alpha = 0.8

        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
