//
//  CRMFilterViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/14/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMFilterViewController: UIViewController {

    @IBOutlet weak var interestLevelFilter: SWBSwitch!
    @IBOutlet weak var interestLevelFilterSliderView: UIView!
    @IBOutlet weak var interestLevelFilterSlider: SWBColouredUISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide slider if the toggle is not checked
        self.interestLevelFilter.rac_valueChanged().subscribeNext({
            _ in
            UIView.animateWithDuration(0.4, animations: {
                self.interestLevelFilterSlider.sliderLabels?.hidden = !self.interestLevelFilter.checked
                self.interestLevelFilterSlider.hidden = !self.interestLevelFilter.checked
                self.interestLevelFilterSliderView.hidden = !self.interestLevelFilter.checked
            })
        })
    }

}
