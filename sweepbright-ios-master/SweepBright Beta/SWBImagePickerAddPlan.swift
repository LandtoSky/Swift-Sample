//
//  SWBImagePickerAddPlan.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBImagePickerAddPlan: UIImagePickerController {

    var cameraOverlay: SWBCameraOverlay!

    func selectCamera() {
        self.sourceType = .Camera
        self.cameraDevice = .Rear
        self.allowsEditing = false

        self.cameraOverlay = SWBCameraOverlay(frame: (self.cameraOverlayView?.bounds)!)
        self.cameraOverlay.pickerController = self
        self.cameraOverlayView = cameraOverlay
    }


    func selectFromLibrary() {
        self.sourceType = .PhotoLibrary
    }

    override func takePicture() {
        self.showsCameraControls = false
        super.takePicture()
    }
}
