//
//  PropertyImagesViewController+CollectionDelegate.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/12/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

//MARK: CollectionView delegate
extension PropertyImagesViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //Fix the item's size to always show 3 item per row
        let size = (collectionView.frame.size.width-4)/3.0
        return CGSize(width: size, height: size)
    }

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        //Changing alpha after long pressing
        collectionView.cellForItemAtIndexPath(indexPath)?.alpha = 0.5
    }

    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        //Changing alpha after long pressing be released
        collectionView.cellForItemAtIndexPath(indexPath)?.alpha = 1.0
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Avoiding a 'no entries' cell be edited
        let propertyimage = self.datasource.getImageFromIndexPath(indexPath)
        guard let _ = propertyimage.image else {
            return
        }

        //Check if the app is in a select multiple state or not
        if self.state == .Default {
            self.selectedImage = propertyimage
            self.performSegueWithIdentifier("detailImage", sender: self)
        } else {
            self.datasource.selectAtIndexPath(collectionView, indexPath: indexPath)

            if let section = self.datasource.getFilteredSection() {
                self.makeAsButton.setTitle("Make \(Visibility.opposite(section).rawValue.capitalizedString)", forState: .Normal)

                self.state = .Selected
            } else {
                self.state = .Selecting
            }
        }
    }
}
