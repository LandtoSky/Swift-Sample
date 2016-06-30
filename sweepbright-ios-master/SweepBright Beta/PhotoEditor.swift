//
//  PhotoEditor.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 12/3/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import Foundation

class PhotoEditorFacade: NSObject, AVYPhotoEditorControllerDelegate {

    private var context: UInt8 = 1
    private var token: dispatch_once_t = 0
    var delegate: PhotoEditorDelegate!

    override init() {
        super.init()


        dispatch_once(&token, {
            dispatch_async(dispatch_get_main_queue(), {
                AVYPhotoEditorController.setAPIKey("87e886d0328546c5ae4655d42e2613ae", secret: "b1ddca87-7252-4f60-b7a4-ac1744b78a6e")

                AVYPhotoEditorController.setPremiumAddOns([.WhiteLabel, .None])
                AVYPhotoEditorCustomization.setRightNavigationBarButtonTitle("Save & next")

                //ORDER: Rotate, Crop, Warmth, Brightness, Contrast, Focus, Vignette
                //            AVYPhotoEditorCustomization.setToolOrder([kAVYOrientation,kAVYCrop, kAVYColorAdjust,kAVYLightingAdjust,kAVYFocus, kAVYVignette])
            })
        })
    }

    func getPhotoEditor(withImage image: UIImage) -> UIViewController {
        let aviary = AVYPhotoEditorController(image: image)
        aviary.delegate = self

        //Changing icons bar background
        let toolbar = (aviary.view.subviews[aviary.view.subviews.count-2])
        toolbar.backgroundColor = UIColor.navigationBarColor()

        //Chaging photo background
        aviary.view.backgroundColor = UIColor.whiteColor()
        aviary.view.tintColor = UIColor.blackColor()

        //Changing Navigation itens font color
        let attributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]


        for righItem in aviary.navigationItem.rightBarButtonItems! {
            righItem.setTitleTextAttributes(attributes, forState: .Normal)
        }

        //Change navigationTitem background color
        let navigation = (aviary.view.subviews.filter({view in return view.isKindOfClass(UINavigationBar)}))

        if let navigationBar: UINavigationBar = navigation.first as? UINavigationBar {
            navigationBar.barTintColor = UIColor.navigationBarColor()
        }
        return aviary
    }

    func photoEditor(editor: AVYPhotoEditorController!, finishedWithImage image: UIImage!) {
        self.delegate.photoEditor(self, finishedWithImage: image)
    }

    func photoEditorCanceled(editor: AVYPhotoEditorController!) {
        self.delegate.photoEditorCanceled(self)
    }
}
