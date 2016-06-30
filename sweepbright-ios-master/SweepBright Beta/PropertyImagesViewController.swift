//
//  PropertyImagesViewController.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 11/25/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

enum State {
    case Selecting, Selected, Adding, Default, Dragging, Editting
}

class PropertyImagesViewController: UIViewController {
    @IBOutlet var cameraOverlayView: UIView!
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var makeAsButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!

    @IBOutlet weak var takePictureView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var makeAsView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var dragedCell: SWBDraggableView?

    @IBOutlet weak var dropView: UIView!
    var photoSelectorController: SWBSelectAndEditPhoto!
    var datasource: SWBPropertyImageCollectionDatasource!
    var property: SWBProperty! {
        didSet {
            if let dtsource = self.datasource {
                (dtsource as! PropertyImageCollectionDatasource).property = property
            }
        }
    }
    var selectedImage: SWBPropertyImage!

    var state: State = .Default {
        didSet {
            switch state {
            case .Default:
                self.selectMultipleMenuAppears = false
                break
            case .Selecting:
                self.navigationItem.rightBarButtonItem = self.doneButton
                self.selectMultipleMenuAppears = true
                self.makeAsView.hidden = true
                self.deleteView.hidden = true
                break
            case .Selected:
                self.makeAsView.hidden = false
                self.deleteView.hidden = false
                break
            default:
                break
            }
        }
    }

    var selectMultipleMenuAppears: Bool = false {
        didSet {
            //Showing the button based on app status
            UIView.animateWithDuration(0.2, animations: {
                self.deleteView.hidden = !self.selectMultipleMenuAppears
                self.makeAsView.hidden = !self.selectMultipleMenuAppears

                self.takePictureView.hidden = self.selectMultipleMenuAppears
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.state = .Default
        self.dragedCell = NSBundle.mainBundle().loadNibNamed("SWBDraggableView", owner: SWBDraggableView.self, options: nil).first as? SWBDraggableView
        self.collectionView.allowsMultipleSelection = true

        //Creating the photo collection datasource
        let collectionDataSource = PropertyImageCollectionDatasource()
        collectionDataSource.property = property
        self.datasource = collectionDataSource
        self.collectionView.dataSource = self.datasource

        //Configurating photo editting
        self.takePictureButton.setTitle("\u{f10c}", forState: .Normal)

        let selectAndEditPhoto = SelectAndEditPhotoController(viewController: self)
        selectAndEditPhoto.backDelegate = self

        self.photoSelectorController = selectAndEditPhoto
        self.photoSelectorController.setCameraOverlay(self.cameraOverlayView)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()

        //Aviary hides the status bar when appears
        UIView.animateWithDuration(0.3, animations: {
            //Unhide status bar when show this view controller
            UIApplication.sharedApplication().statusBarHidden = false
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailImage" {
            let destinationController = segue.destinationViewController as! PropertyImageDetailViewController
            destinationController.propertyImage = selectedImage
            destinationController.property = self.property
        }
        super.prepareForSegue(segue, sender: sender)
    }

    //Handles drag and drop events
    @IBAction func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        let touchPosition = gesture.locationInView(self.view)

        switch gesture.state {
            case UIGestureRecognizerState.Began:
                //show the published/private labels when starts the gesture on the collection view
                guard let selectedIndexPath = self.collectionView.indexPathForItemAtPoint(gesture.locationInView(self.collectionView)) else {
                    break
                }

                //Show a view on the touch position
                let cell = self.collectionView.cellForItemAtIndexPath(selectedIndexPath) as! PropertyImageViewCell

                if cell.image.image == nil {
                    break
                }

                AlertFactory.loadingTopBarMessage("Select a folder")
                self.dropView.hidden = false

                self.dragedCell?.image = cell.image
                self.view.addSubview(self.dragedCell!)
                self.dragedCell?.center = touchPosition
            case .Changed:
                //Move the view
                self.dragedCell?.center = touchPosition
            case .Ended:
                //When the user release the touch, try to select one of the folders (published or private)
                if let button = self.dropView.hitTest(touchPosition, withEvent: nil) as? SWBVisibilityButton {
                    //Execute backend task
                    button.sendActionsForControlEvents(.TouchUpInside)
                } else {
                    //ignore the action if the use release in a different place
                    self.removeDropView()
                }
            default:
                //ignore the action if the use release in a different place
                self.removeDropView()
            }
    }

    func removeDropView() {
        self.dragedCell?.removeFromSuperview()
        self.dragedCell?.image = nil
        self.collectionView.reloadData()
        self.dropView.hidden = true
        AlertFactory.dismissTopBarMessage()
    }

    @IBAction func imageDropped(sender: SWBVisibilityButton) {
        dragedCell?.image!.visibility = sender.visibility

        AlertFactory.loadingAlert(withTitle: "Moving", onController: self, animated: true, completionHandler: {
            self.removeDropView()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}

//MARK: PropertyDependent
extension PropertyImagesViewController:PropertyDependent {

}

//MARK:BackInformationDelegate
extension PropertyImagesViewController:BackInformationDelegate {
    func returnInformation(viewController: UIViewController, info: [String : Any]) {
        if let image = info[SWBAvyBackDelegate] {

            self.property.addImage(PropertyImage(data:"", visibility: .Private, image:image as? UIImage))
            AlertFactory.loadingTopBarMessage("A new picture has been added", dismissAfter: 1.0)
        }
    }
}
