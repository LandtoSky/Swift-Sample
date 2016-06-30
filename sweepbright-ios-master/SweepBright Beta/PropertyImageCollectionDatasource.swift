//
//  PropertyImageCollectionDatasource.swift
//  SweepBright Beta
//
//  Created by Kaio Henrique on 11/26/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import UIKit

class PropertyImageCollectionDatasource: NSObject, SWBPropertyImageCollectionDatasource {
    let sections = [Visibility.Published, Visibility.Private]
    var property: SWBProperty!
    var imagesSelected: [NSIndexPath] = []
    private let reuseIdentifier = "ImageCell"
    var filteredSection: Visibility?
}

//MARK: UICollectionViewDataSource
extension PropertyImageCollectionDatasource {

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        //Deque the View and set the title's value
        if kind == UICollectionElementKindSectionHeader {

            let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionHeader", forIndexPath: indexPath) as! PropertyImageHeaderView
            let section = sections[indexPath.section]
            reusableView.title.text = "\((section == Visibility.Private) ? "\u{f023} ":"")\(section.rawValue)"

            return reusableView
        } else {
            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "FooterView", forIndexPath: indexPath)

            return footer
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //Hidde collectionView if there is no data
        UIView.animateWithDuration(0.2, animations: {
            collectionView.hidden = (self.property.images.count == 0)
        })
        return self.sections.count
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.property.getImagesByVisibility(sections[section]).count
        return (count > 0) ? count : 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //deque ReusableCell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PropertyImageViewCell

        //populate the cell
        let image = self.getImageFromIndexPath(indexPath)

        cell.image = image

        //when the user select multiple cells, only pictures from one folder should be available
        if let visibility = self.filteredSection {
            //disable cell and change alpha if cell is from another folder
            let sameFolder = visibility == image.visibility
            cell.alpha = sameFolder ? 1.0 : 0.5
            cell.userInteractionEnabled = sameFolder
        } else {
            //In case that there is no filteredSection all cell should be able to interact
            cell.userInteractionEnabled = true
        }

        //Show a check-circle from FontAwesome if the cell is selected
        cell.checkLabel.text = (self.imagesSelected.indexOf(indexPath) > -1) ? "\u{f058}" : ""
        return cell
    }

    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        //Prevent move last when there are images selected
        return false
    }
}
