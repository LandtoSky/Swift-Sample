//
//  PropertySearchController.swift
//  This class has all UISearchController settings required to be used in PropertyTableViewController
//
//  Created by Kaio Henrique on 11/25/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//
//

import UIKit

class PropertySearchController: UISearchController {


    //initializer with searchResultsUpdater
    init(searchResultsController: UIViewController?, searchResultsUpdater: UISearchResultsUpdating) {
        super.init(searchResultsController: searchResultsController)
        self.searchResultsUpdater = searchResultsUpdater

        self.dimsBackgroundDuringPresentation = false

        //Painting the searchBar
        self.searchBar.barTintColor = UIColor.navigationBarColor()
        self.searchBar.tintColor = UIColor.whiteColor()

        //Setting scope titles
        self.searchBar.scopeButtonTitles = ["My Properties", "All properties"]
        self.searchBar.sizeToFit()
    }

    //required initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
}
