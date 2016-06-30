//
//  SelectAndEditPhotoController.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 11/30/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

//Key used on the BackDelegate call
let SWBAvyBackDelegate = "AVYIMAGE"

class SelectAndEditPhotoController: NSObject, SWBSelectAndEditPhoto {

    var pickerController: UIImagePickerController!
    var viewController: UIViewController!
    var cameraOverlayView: UIView!
    var backDelegate: BackInformationDelegate!

    var photoEditor: PhotoEditorFacade!

    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        self.pickerController = UIImagePickerController()
        self.pickerController.delegate = self

        self.photoEditor = PhotoEditorFacade()
        self.photoEditor.delegate = self
    }

    //MARK: SWBSelectAndEditPhoto
    func selectPhotoFromLibrary() {
        //setting the sourcetype and present the pickerController
        self.pickerController.sourceType = .PhotoLibrary
        self.viewController.presentViewController(pickerController, animated: true, completion: nil)
    }

    func selectPhotoFromCamera() {
        //setting picker controller things
        self.pickerController.sourceType = .Camera
        self.pickerController.extendedLayoutIncludesOpaqueBars = true

        //Override cameraOverlayView
        if let overlayView = self.cameraOverlayView {
            overlayView.frame = (self.pickerController.cameraOverlayView?.bounds)!
            self.pickerController.cameraOverlayView = overlayView
        }
        self.pickerController.cameraDevice = .Rear
        self.pickerController.showsCameraControls = true

        //present the pickerController
        self.viewController.presentViewController(pickerController, animated: true, completion: nil)
    }

    func setCameraOverlay(view: UIView) {
        self.cameraOverlayView = view
    }

    func takePhoto() {
        self.pickerController.showsCameraControls = false
        self.pickerController.takePicture()
    }

    func cancelPhotoFromPicker() {
        self.imagePickerControllerDidCancel(pickerController)
    }

}

//MARK: UIImagePickerControllerDelegate
extension SelectAndEditPhotoController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    internal func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        //After select a picture from the Photo library or take a new one, show the Aviary Photo Editor
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage

        if self.pickerController.sourceType == .Camera {
            self.pickerController.showsCameraControls = true
            self.pickerController.pushViewController(photoEditor.getPhotoEditor(withImage: image), animated: true)
        } else {
            self.pickerController.presentViewController(photoEditor.getPhotoEditor(withImage: image), animated: true, completion:nil)
        }
    }

    internal func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.viewController.dismissViewControllerAnimated(true, completion: {})
    }

}

//MARK: Photo Editor Delegate
extension SelectAndEditPhotoController:PhotoEditorDelegate {

    internal func photoEditor(editor: PhotoEditorFacade!, finishedWithImage image: UIImage!) {
        if let backDelegate = self.backDelegate {
            backDelegate.returnInformation(viewController, info: [SWBAvyBackDelegate:image])
        }

        if self.pickerController.sourceType == .Camera {
            self.pickerController.popViewControllerAnimated(true)
        } else {
            self.pickerController.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    internal func photoEditorCanceled(editor: PhotoEditorFacade!) {
        if self.pickerController.sourceType == .Camera {
            self.pickerController.popViewControllerAnimated(true)
        } else {
            self.pickerController.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}
