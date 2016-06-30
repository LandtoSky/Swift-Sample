//
//  PropertyImagesViewController+PhotoImport.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/12/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

extension PropertyImagesViewController {
    //MARK: Connecting the IBAction to photoSelectorController actions
    @IBAction func takePhoto(sender: AnyObject) {
        let customAlert = SweepBrightActionSheet()
        customAlert.addDefaultAction("Ask Photographer", handler: nil)
        customAlert.addDefaultAction("Open Library", handler: {
            _ in
            self.photoSelectorController.selectPhotoFromLibrary()
        })
        customAlert.addDefaultAction("Use Camera", handler: {
            _ in
            self.photoSelectorController.selectPhotoFromCamera()
        })
        customAlert.addDestructiveAction("Cancel", handler: nil)
        customAlert.show(self)
    }

    @IBAction func takePicture(sender: AnyObject) {
        self.photoSelectorController.takePhoto()
    }

    @IBAction func cancelPhoto(sender: AnyObject) {
        self.photoSelectorController.cancelPhotoFromPicker()
    }
}
