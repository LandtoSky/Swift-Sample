//
//  SWBAddPlanViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/12/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SWBAddPlanViewController: UIViewController {

    @IBOutlet weak var planImageView: UIImageView!

    dynamic var imagePlan: UIImage!
    var plan: SWBPlan!

    @IBOutlet weak var addSurfaceButton: UIButton!
    var addPlanView: SWBAddPlanView {
        get {
            return self.view as! SWBAddPlanView
        }
    }

    lazy var imagePicker: SWBImagePickerAddPlan = SWBImagePickerAddPlan()
    var selectedRoom: SWBRoom! {
        didSet {
            self.addSurfaceButton.hidden = !(self.selectedRoom == nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectedRoom" {
            (segue.destinationViewController as! SWBSelectRoomTableViewController).backDelegate = self
        }
        super.prepareForSegue(segue, sender: sender)
    }

    func addObservers() {

        //Binding imagePlan and planImageView
        self.rac_observeKeyPath("imagePlan", options: .New, observer: self, block: {
            _, _, _, _ in
            self.planImageView.image = self.imagePlan
        })

        //Observing planImageView changes
        self.planImageView.rac_observeKeyPath("image", options: .New, observer: self, block: {
            _, _, _, _ in

            self.planImageView.hidden = false
            self.plan.image = self.planImageView.image

            //add visual surfaces
            self.addPlanView.plan = self.plan
            self.addPlanView.renderSurfaces()
        })

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addObservers()

        //First load
        if let editPlan = self.plan {
            self.addPlanView.plan = self.plan
            self.planImageView.image = editPlan.image
        } else {
            self.plan = SWBPlanClass()
            self.planImageView.hidden = true
            self.imagePicker.delegate = self

            let actionSheet = SweepBrightActionSheet()
            actionSheet.addDefaultAction("Take a picture", handler: {
                _ in

                self.imagePicker.selectCamera()
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            })
            actionSheet.addDefaultAction("Select from gallery", handler: {
                _ in

                self.imagePicker.selectFromLibrary()
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            })
            actionSheet.addDestructiveAction("Cancel", handler: {
                _ in
                self.navigationController?.popViewControllerAnimated(true)
            })

            actionSheet.show(self)
        }


    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = self.selectedRoom {

            //Get the touch
            let touch = touches.first!

            //get position on the screen
            let location = touch.locationInView(self.planImageView)


            let surface = SWBSurfaceClass(position: location)
            surface.room = self.selectedRoom

            //add surface register
            self.addPlanView.addSurface(surface)

            self.selectedRoom = nil
        }
    }

}
//MARK: UIImagePickerControllerDelegate
extension SWBAddPlanViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.imagePlan = info[UIImagePickerControllerOriginalImage] as! UIImage
        SWBFloorPlanCollectionDatasource.addPlan(self.plan)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: {
            self.navigationController?.popViewControllerAnimated(true)
        })
    }

}

//MARK: BackInformationDelegate
extension SWBAddPlanViewController:BackInformationDelegate {
    func returnInformation(viewController: UIViewController, info: [String : Any]) {
        self.selectedRoom = info[SWBSelectRoomTableViewControllerBackInfo] as! SWBRoom
    }
}
