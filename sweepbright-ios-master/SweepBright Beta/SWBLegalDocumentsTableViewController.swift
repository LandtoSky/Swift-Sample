//
//  SWBLegalDocumentsTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/8/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class Section {
    var title: String?
    var cells: [String]!

    init(title: String? = "", cells: [String] = []) {
        self.title = title
        self.cells = cells
    }

    var count: Int {
        return self.cells.count
    }
}

/**
 This class will show the cells based on the property negotiation.
 The cells on the table view should be all a kind of LegalDocsDependentCell, which contains a legal docs object and service.
 Whenever the cells content changes, the legalAndDocs attribute will change as well by reference.

 The controller don't know the cells content, to get this information use the legalAndDocs attribute. In a nutsheel, the cells have access to the legalAndDocs object on the controller but not the opposite.

 */
class SWBLegalDocumentsTableViewController: UITableViewController {
    var legalAndDocs: SWBLegalDocsModel!
    var changed: Bool = false
    var property: SWBProperty!
    var service: SWBLegalDocServiceProtocol = SWBLegalDocsService()
    var sections: [Section]! = []

    @IBOutlet weak var backButton: SWBBackButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.calculateSection()
        self.backButton.backButtonDelegate = self
        self.legalAndDocs = SWBLegalDocsModel(value: property.legalDocs ?? SWBLegalDocsModel())

    }
    /**
     Fill the sections based on the property negotiation.

     The `sections` attribute is an array of Section objects, which contains the title of the section and the reusedIdentifiers of each one

     Property ToLet:
        * Tenant contract
        * 2x EPC Value
        * Documents

     Property ForSale:
        * Legal Notes
        * 2x EPC Value
        * Year purchased
        * Documents
     */
    func calculateSection() {
        var sections: [Section] = []

        if self.property.status == .ToLet {
            sections.append(Section(title: "TENANT CONTRACT", cells: ["tenantContractCell"]))
            sections.append(Section(title: "", cells: ["epcValue", "epcCategory"]))
        } else {
            sections.append(Section(title: "INTERNAL LEGAL NOTES", cells: ["legalNotes"]))
            sections.append(Section(title: "", cells: ["epcValue", "epcCategory", "publishedCell"]))
        }

        sections.append(Section(title: "DOCUMENTS", cells: []))
        sections.append(Section(title: "", cells: ["buttonCell"]))
        self.sections = sections
    }
}


//MARK: Datasource

extension SWBLegalDocumentsTableViewController {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Fill the object data and call the bind method
        if var legalDocsCell = cell as? LegalDocsDependentCell {
            legalDocsCell.legalDocs = self.legalAndDocs
            legalDocsCell.service = self.service
            legalDocsCell.bind()
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].cells.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = self.sections[indexPath.section].cells[indexPath.row]
        return tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
    }
    @IBAction func requestFile(sender: AnyObject) {
        let customAlert = SweepBrightActionSheet(initWithTitle:"Are you sure you want to delete?")
        customAlert.addDefaultAction("Request Via E-mail", handler: nil)
        customAlert.addDefaultAction("Pick File", handler: nil)
        customAlert.addDestructiveAction("Cancel", handler: nil)
        customAlert.show(self)

    }
}

//MARK: PropertyDepedent
extension SWBLegalDocumentsTableViewController: PropertyDependent {
    func propertyDependent(property: SWBProperty) {
        self.property = property
        self.legalAndDocs = property.legalDocs
    }
}

//MARK: Back button
extension SWBLegalDocumentsTableViewController: SWBBackButtonDelegate {

    func hasChanged() -> Bool {
        //Always update the data after leave the screen
        return true
    }
    func updateData() {
        self.service.syncLegalDocs(self.legalAndDocs)
    }
    var viewController: UIViewController { return self }

}
