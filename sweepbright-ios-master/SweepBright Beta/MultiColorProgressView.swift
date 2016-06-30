//
//  MultiColorProgressView.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 11/24/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

class MultiColorProgressView: UIProgressView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }

    override func setProgress(progress: Float, animated: Bool) {
        super.setProgress(progress, animated: animated)

        if progress >= 1.0 {
            self.progressTintColor = UIColor.greenProgressBar()
        } else {
            self.progressTintColor = UIColor.blueProgressBar()
        }
    }
}
