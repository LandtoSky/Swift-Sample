//
//  CRMContactInfoTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/20/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMContactInfoTableViewController: UITableViewController, CRMContactDependent, CRMContactAddressService, CRMContactService {
    @IBOutlet var contactForm: CRMContactForm!
    @IBOutlet weak var contactImageCell: CRMContactImageCell!
    var contact: CRMContact!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var locationForm: SWBLocationFormView!
    var queue: NSOperationQueue!
    var addressService: CRMContactAddressService!

    /// Instance attributes
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0

        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self

        self.queue = NSOperationQueue()
        self.addressService = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let contact = self.contact {
            self.contactForm.contact = CRMContact(value: contact)
            self.locationForm.location = CRMContactAddress(value: contact.address!)
        }
        self.contactForm.addReactions()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if self.contactForm.changed {
            self.saveContactInfo(self.contactForm.contact)
        }
        if self.locationForm.changed {
            self.addressService.update(address: self.locationForm.location as! CRMContactAddress)
        }
        AlertFactory.loadingTopBarMessage("Updating contact", dismissAfter: 0.5)
    }

    // Show an alert to confirm the photo exclusion
    @IBAction func removePhoto() {
        let alert = UIAlertController(title: "Remove the photo", message: "Are you sure?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .Default, handler: { _ in
            self.contactImageCell.removePhoto()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    /// Show an action sheet for the user selects the source where he/she will get the photo
    @IBAction func addPhoto() {
        let customAlert = SweepBrightActionSheet()
        customAlert.addDefaultAction("Open Library", handler: { _ in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        customAlert.addDefaultAction("Use Camera", handler: { _ in
            self.imagePicker.sourceType = .Camera
            self.imagePicker.cameraDevice = .Rear
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        customAlert.addDestructiveAction("Cancel", handler: nil)
        customAlert.show(self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let modalView = segue.destinationViewController as? ModalViewController, let image = sender as? UIImage {
            modalView.image = image
            modalView.positiveFeedback = {
                let contactId = self.contact.id
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                    let progress = self.uploadPhoto(image, forContactId: contactId)
                    self.contactImageCell.uploadProgress = progress
                })
            }
        }
        super.prepareForSegue(segue, sender: sender)
    }
}

extension CRMContactInfoTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: {
            // Show the modal profile that will confirm the new picture or not
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.performSegueWithIdentifier("modalProfile", sender: image)
            }
        })
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: Datasource
extension CRMContactInfoTableViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if var propertyDependent = cell as? CRMContactDependent {
            propertyDependent.contact = self.contact
        }
        return cell
    }
}

//MARK: Delegate
extension CRMContactInfoTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
