//
//  SWBMatchPropertiesTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/6/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBMatchPropertiesTableViewController: UITableViewController, PropertyDependent {
    var property: SWBProperty!
    @IBOutlet var filterBarButton: UIBarButtonItem!
    @IBOutlet weak var mailButton: SWBAddButton!
    let reuseIdentifier = "matchClient"
    @IBOutlet var noData: UILabel!
    var showTabBarNavigation: Bool = true

    var matchesMailed: Bool = false {
        didSet {
            self.mailButton.titleText = (self.matchesMailed ? "Spam Again" : "Mail All Matches")
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "SWBMatchClientTableViewCell", bundle:  nil), forCellReuseIdentifier: reuseIdentifier)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showFeedBack), name: SWBClientViewCellCallNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserverForName(SWBClientViewCellNewMailNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            _ in
            self.performSegueWithIdentifier("mailSegue", sender: nil)
        })
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func showFeedBack() {
        self.performSegueWithIdentifier("feedbackSegue", sender: nil)
    }
    @IBAction func mailAllMatches(sender: AnyObject) {
        self.matchesMailed = !self.matchesMailed
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationItem.setRightBarButtonItem(self.filterBarButton, animated: true)
        self.tabBarController?.navigationItem.title = self.property.address
    }

    func showNoDataMessage() {
        self.noData.frame = self.tableView.bounds
        self.view.addSubview(self.noData)
        self.tableView.userInteractionEnabled = false
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        self.tabBarController?.navigationItem.setRightBarButtonItem(nil, animated: true)
    }
}

//MARK: Delegate
extension SWBMatchPropertiesTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("leadMatch", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

//MARK: Datasource
extension SWBMatchPropertiesTableViewController {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "MATCHES"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Only for UI FR on issue #148
        //Show the message when count is 0
        if property.status == .ToLet {
            self.showNoDataMessage()
        }
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! SWBMatchClientTableViewCell
        cell.mailed = self.matchesMailed
        return cell
    }
}
