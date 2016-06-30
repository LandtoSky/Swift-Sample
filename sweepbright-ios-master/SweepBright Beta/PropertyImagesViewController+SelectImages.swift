//
//  PropertyImagesViewController+SelectImages.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/12/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

extension PropertyImagesViewController {

    //MARK: Navigation Item IBActions
    @IBAction func selectMultiples(sender: AnyObject) {
        self.state = .Selecting
    }

    @IBAction func doneSelectMultiple(sender: AnyObject) {
        self.datasource.deselectAll(self.collectionView)
        self.state = .Default
    }

    @IBAction func makeAsAction(sender: AnyObject) {
        AlertFactory.loadingAlert(withTitle: "Moving", onController: self, animated: false, completionHandler: {
            self.makeSelectedsAs(sender)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }

    func makeSelectedsAs(sender: AnyObject) {
        let section = self.datasource.getFilteredSection().opposite()
        self.datasource.changeSelectedsVisibility(self.collectionView)
        self.doneSelectMultiple(sender)
        AlertFactory.loadingTopBarMessage("The pictures were moved to \(section.rawValue.capitalizedString)", dismissAfter: 1.0)
    }

    @IBAction func deleteImagesSelected(sender: AnyObject) {
        //Show a delete confirm alert before remove property's images
        let images = self.datasource.getImagesSelected()

        if images.count > 0 {
            let customAlert = SweepBrightActionSheet(initWithTitle:"Are you sure you want to delete?")
            customAlert.addRedAction("Delete selected", handler: {
                _ in
                AlertFactory.loadingAlert(withTitle: "Deleting", onController: self, animated: false, completionHandler: {
                    self.confirmExclusionImagesSelecteds(sender)
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            })
            customAlert.addDestructiveAction("Cancel", handler: nil)
            customAlert.show(self)

        } else {
            AlertFactory.loadingTopBarMessage("Select at least one picture", dismissAfter: 1.0)
        }

    }

    func confirmExclusionImagesSelecteds(sender: AnyObject) {
        self.property.removeImages(self.datasource.getImagesSelected())
        self.doneSelectMultiple(sender)
        AlertFactory.loadingTopBarMessage("The pictures were removed succefully", dismissAfter: 1.0)
    }

}
