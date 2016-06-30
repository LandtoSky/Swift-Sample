//
//  protocols.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 11/27/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import Foundation


protocol BackInformationDelegate {
    func returnInformation(viewController: UIViewController, info: [String:Any])
}

protocol PropertyDependent: class {
    var property: SWBProperty! {get set}
    func propertyDependent(property: SWBProperty)
}

extension PropertyDependent {
    func propertyDependent(property: SWBProperty) {
        self.property = property
    }
}

protocol SWBSelectAndEditPhoto {
    func selectPhotoFromLibrary()
    func selectPhotoFromCamera()
    func takePhoto()
    func cancelPhotoFromPicker()
    func setCameraOverlay(view: UIView)
}


protocol PhotoEditorDelegate {
    func photoEditor(editor: PhotoEditorFacade!, finishedWithImage image: UIImage!)
    func photoEditorCanceled(editor: PhotoEditorFacade!)
}
