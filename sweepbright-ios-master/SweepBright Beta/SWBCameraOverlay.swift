//
//  SWBCameraOverlay.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/18/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBContentViewOverlay: UIView {
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var cancel: UIButton!
}

class SWBCameraOverlay: UIView {

    var contentView: SWBContentViewOverlay!
    var pickerController: UIImagePickerController!

    override var frame: CGRect {
        didSet {
            self.contentView?.frame = self.bounds
        }
    }

    var takePicture:(()->()) = {_ in }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setUI()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setUI()
    }

    internal func shutterButtonTarget(sender: UIButton) {
        self.pickerController?.takePicture()
    }

    internal func cancelButtonTarget(sender: UIButton) {
        self.pickerController?.delegate?.imagePickerControllerDidCancel!(self.pickerController)
    }

    private func setUI() {
        if let view = NSBundle.mainBundle().loadNibNamed("SWBCameraOverlay", owner: self, options: nil).first as? SWBContentViewOverlay {
            view.frame = self.bounds
            view.shutterButton.setTitle("\u{f10c}", forState: .Normal)
            view.shutterButton.addTarget(self, action: #selector(SWBCameraOverlay.shutterButtonTarget(_:)), forControlEvents: .TouchUpInside)
            view.cancel.addTarget(self, action: #selector(SWBCameraOverlay.cancelButtonTarget(_:)), forControlEvents: .TouchUpInside)
            self.addSubview(view)
            self.contentView = view

            //Add ShutterButton constraints

            self.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0))
            self.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            self.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))

        }
    }
}
