//
//  SWBLocationFormView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/20/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SWBLocationFormView: UIView {
    var location: SWBPropertyLocation? {
        didSet {
            self.streetTextField?.text = self.location?.street
            self.street2TextField?.text = self.location?.street2
            self.addrTextField?.text = self.location?.add
            self.nrTextField?.text = self.location?.nr
            self.boxTextField?.text = self.location?.box
            self.floorTextField?.text = self.location?.floor
            self.postcodeTextField?.text = self.location?.postcode
            self.cityTextField?.text = self.location?.city
            self.provinceTextField?.text = self.location?.province
            self.countryTextField?.text = self.location?.country

            self.addReactiveCocoaSignals()
        }
    }
    @IBOutlet weak var streetTextField: SWBFloatLabelTextField!
    @IBOutlet weak var street2TextField: SWBFloatLabelTextField!
    @IBOutlet weak var nrTextField: SWBFloatLabelTextField!
    @IBOutlet weak var addrTextField: SWBFloatLabelTextField!
    @IBOutlet weak var boxTextField: SWBFloatLabelTextField!
    @IBOutlet weak var floorTextField: SWBFloatLabelTextField!
    @IBOutlet weak var postcodeTextField: SWBFloatLabelTextField!
    @IBOutlet weak var cityTextField: SWBFloatLabelTextField!
    @IBOutlet weak var provinceTextField: SWBFloatLabelTextField!
    @IBOutlet weak var countryTextField: SWBFloatLabelTextField!

    var changed: Bool = false
    var view: UIView!

    override var bounds: CGRect {
        didSet {
            self.view?.frame = self.bounds
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    /// Add binding
    private func addReactiveCocoaSignals() {
        self.streetTextField.rac_textSignal().subscribeNext({text in self.location?.street = text as? String})
        self.street2TextField.rac_textSignal().subscribeNext({text in self.location?.street2 = text as? String})
        self.addrTextField.rac_textSignal().subscribeNext({text in self.location?.add = text as? String})
        self.nrTextField.rac_textSignal().subscribeNext({text in self.location?.nr = text as? String})
        self.boxTextField.rac_textSignal().subscribeNext({text in self.location?.box = text as? String})
        self.floorTextField.rac_textSignal().subscribeNext({text in self.location?.floor = text as? String})
        self.postcodeTextField.rac_textSignal().subscribeNext({text in self.location?.postcode = text as? String})
        self.cityTextField.rac_textSignal().subscribeNext({text in self.location?.city = text as? String})
        self.provinceTextField.rac_textSignal().subscribeNext({text in self.location?.province = text as? String})
        self.countryTextField.rac_textSignal().subscribeNext({text in self.location?.country = text as? String})

        RACSignal.merge([
            self.streetTextField.rac_textSignal(),
            self.street2TextField.rac_textSignal(),
            self.addrTextField.rac_textSignal(),
            self.nrTextField.rac_textSignal(),
            self.boxTextField.rac_textSignal(),
            self.floorTextField.rac_textSignal(),
            self.postcodeTextField.rac_textSignal(),
            self.cityTextField.rac_textSignal(),
            self.postcodeTextField.rac_textSignal(),
            self.cityTextField.rac_textSignal(),
            self.provinceTextField.rac_textSignal(),
            self.countryTextField.rac_textSignal()
            ])
            .subscribeNext({ _ in
                self.changed = true
            })
        self.changed = false
    }

    func initialize() {
        self.view = NSBundle.mainBundle().loadNibNamed("SWBLocation", owner: self, options: nil).first as! UIView
        self.view.frame = self.bounds
        self.addSubview(view)
    }
}
