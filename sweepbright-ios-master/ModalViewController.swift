//
//  ModalViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/2/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
    /// The image that will be showed on the center of the screen
    var image: UIImage?

    ///When the user press the update button this method will be called
    var positiveFeedback: (() -> Void)?

    @IBOutlet var centeredView: ProfilePictureView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.centeredView.imageView.image = self.image
    }
    /**
     Update button action.

     When the user press the update button, this method and the `positiveFeedback` will be called.

     - parameter sender: The object who sent the action
     */
    @IBAction func aprovePhoto(sender: AnyObject) {
        self.positiveFeedback?()
        self.dismissViewController(self)
    }
}
