//
//  PropertyImageDetailViewController.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 11/26/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit
import JDStatusBarNotification
let SWPDESCRIPTION = "description"

class PropertyImageDetailViewController: UIViewController {

    @IBOutlet weak var backButton: SWBBackButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!

    @IBOutlet weak var makeAsButton: UIButton!

    var property: SWBProperty!
    var propertyImage: SWBPropertyImage! {
        didSet {
            self.propertyImageEdit = (self.propertyImage as! PropertyImage).copy() as! PropertyImage
        }
    }
    var propertyImageEdit: SWBPropertyImage! {
        didSet {
            guard let _ = self.view else {
                return
            }
            //Copying property image object
            self.imageView.image = self.propertyImageEdit.image
            self.descriptionText.text = (self.propertyImageEdit.data)
            self.updateUI()
        }
    }
    var photoEditor: PhotoEditorFacade!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.photoEditor = PhotoEditorFacade()
        self.photoEditor.delegate = self

        //Copying property image object
        self.imageView.image = self.propertyImageEdit.image
        self.descriptionText.text = (self.propertyImageEdit.data)
        self.backButton.backButtonDelegate = self
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDescription" {
            let destination = segue.destinationViewController as! EditPropertyDescriptionViewController
            destination.backInfoDelegate = self
            destination.descriptionValue = self.descriptionText.text
        }
        super.prepareForSegue(segue, sender: sender)
    }

    private func updateUI() {
        (self.navigationItem.titleView as! UILabel).text = self.propertyImageEdit.visibility.rawValue

        //Disable the savebutton with object has no changes
        self.makeAsButton.setTitle("Make \(Visibility.opposite(self.propertyImageEdit.visibility).rawValue.capitalizedString)", forState: .Normal)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateUI()
    }

    @IBAction func markAs(sender: AnyObject) {
        self.propertyImageEdit.visibility = Visibility.opposite(self.propertyImageEdit.visibility)
        self.updateUI()
    }

    @IBAction func editPhoto(sender: AnyObject) {

        //Open the Aviary with a copy of the image
        let image: UIImage = (self.propertyImageEdit.image?.copy())! as! UIImage

        self.presentViewController(photoEditor.getPhotoEditor(withImage: image), animated: true, completion: nil)
    }

    @IBAction func deletePicture(sender: AnyObject) {
        //Confirm alert before delete
        let alert = SweepBrightActionSheet(initWithTitle: "Do you want to delete this picture?")
        alert.addRedAction("Delete picture", handler: {
            _ in
            AlertFactory.loadingAlert(withTitle: "Removing", onController: self, animated: false, completionHandler: {
                self.property.removeImage(self.propertyImage)
                JDStatusBarNotification.showWithStatus("Picture removed sucessfully", dismissAfter: 1.0)
                self.dismissViewControllerAnimated(false, completion: {
                    self.navigationController?.popViewControllerAnimated(true)
                })
            })
        })
        alert.addDestructiveAction("No", handler: nil)
        alert.show(self)

    }

}

//MARK: PhotoEditorDelegate
extension PropertyImageDetailViewController:PhotoEditorDelegate {

    func photoEditor(editor: PhotoEditorFacade!, finishedWithImage image: UIImage!) {
        //Update the image from the property editable object
        self.propertyImageEdit.image = image
        self.imageView.image = self.propertyImageEdit.image

        JDStatusBarNotification.showWithStatus("The picture has been edited", dismissAfter: 1.0)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func photoEditorCanceled(editor: PhotoEditorFacade!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: BackInformationDelegate
extension PropertyImageDetailViewController:BackInformationDelegate {

    func returnInformation(viewController: UIViewController, info: [String : Any]) {
        self.propertyImageEdit.data = (info[SWPDESCRIPTION] as! String)
        self.descriptionText.text = self.propertyImageEdit.data
    }
}

//MARK: UITextViewDelegate
extension PropertyImageDetailViewController:UITextViewDelegate {

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.performSegueWithIdentifier("editDescription", sender: self)
        return false
    }
}

//MARK: SWBBackButtonDelegate
extension PropertyImageDetailViewController:SWBBackButtonDelegate {

    var viewController: UIViewController {
        get {
            return self
        }
    }

    func updateData() {

        //Updating property image attributes
        self.propertyImage.data = self.propertyImageEdit.data
        self.propertyImage.image = self.propertyImageEdit.image
        self.propertyImage.visibility = self.propertyImageEdit.visibility

        //Back to the previous screen
        JDStatusBarNotification.showWithStatus("Image has been saved", dismissAfter: 1.0)
    }

    func hasChanged() -> Bool {
        return !(self.propertyImage as! PropertyImage).equalsTo(self.propertyImageEdit as! PropertyImage)
    }

    func validated() -> Bool {
        return true
    }
}
