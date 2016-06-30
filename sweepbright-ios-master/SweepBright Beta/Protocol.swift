//
//  Protocol.swift
//  SweepBright
//
//  Created by Kaio Henrique on 12/21/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import Foundation
let reuseIdentifier = "ImageCell"
protocol SWBPropertyImageCollectionDatasource: UICollectionViewDataSource, PropertyDependent {
    var sections: [Visibility] {get}
    var imagesSelected: [NSIndexPath] {get set}

    var filteredSection: Visibility? {get set}
}

extension SWBPropertyImageCollectionDatasource {
    func getFilteredSection() -> Visibility! {
        return self.filteredSection
    }

    func changeSelectedsVisibility(collectionView: UICollectionView) {
        let section = self.getFilteredSection().opposite()

        let itemsSelected = self.getImagesSelected()

        for item in itemsSelected {
            item.visibility = section
        }
    }

    func deselectAll(collectionView: UICollectionView) {
        //Remove filter and enable interaction for all cells
        self.filteredSection = nil
        self.imagesSelected.removeAll()
        collectionView.reloadData()
    }

    func getImagesSelected() -> [SWBPropertyImage] {
        guard let _ = self.filteredSection else {
            return []
        }

        let imagesPerVisibility = property.getImagesByVisibility(self.filteredSection!)
        if imagesPerVisibility.count == 0 {
            return []
        }

        var images: [SWBPropertyImage] = []
        for selected in self.imagesSelected {
            images.append(imagesPerVisibility[selected.row])
        }
        return images
    }

    func getImageFromIndexPath(indexPath: NSIndexPath) -> SWBPropertyImage {
        //Prevent to be an empty section, required from drag and drop gesture
        let imagePerSection = property.getImagesByVisibility(sections[indexPath.section])
        if imagePerSection.count == 0 {
            return PropertyImage(data: "Click and hold thumbs to drag here", visibility: sections[indexPath.section], image: nil)
        }
        return imagePerSection[indexPath.row]
    }

    func selectAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) {
        //If this is the first cell to be selected, the filteredSection has to be set and the collectionView reloaded
        if self.imagesSelected.count == 0 {
            self.filteredSection = sections[indexPath.section]
            collectionView.reloadData()
        } else {
            //If the index is in the list, deselect it
            if self.imagesSelected.indexOf(indexPath) > -1 {
                self.deselectedAtIndexPath(collectionView, indexPath: indexPath)
                return
            }
        }
        //Add cell in the selected list of cells and reload only this cell
        imagesSelected.append(indexPath)
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }

    func deselectedAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) {
        //Remove a cell, if there is in the list
        let index = self.imagesSelected.indexOf(indexPath)
        if index > -1 {
            self.imagesSelected.removeAtIndex(index!)
        }

        //Check if the deselected cell was the last and update the whole collectionView or only the cell
        (self.imagesSelected.count == 0) ?
            self.deselectAll(collectionView):
            collectionView.reloadItemsAtIndexPaths([indexPath])
    }
}
