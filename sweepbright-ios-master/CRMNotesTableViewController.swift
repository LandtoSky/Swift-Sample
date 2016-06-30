//
//  CRMNotesTableViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class CRMNotesTableViewController: UITableViewController, CRMContactDependent, CRMContactNotesService {
    var contact: CRMContact!
    var queue: NSOperationQueue!

    @IBOutlet weak var notesTextView: UITextView!

    var service: CRMContactNotesService!
    var changed: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.service = self
        self.queue = NSOperationQueue()
        self.bindData()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Only update the notes if the user editted the content
        if self.changed {
            self.updateNotes(self.notesTextView.text)
            AlertFactory.loadingTopBarMessage("Updating notes", dismissAfter: 0.5)
        }
    }
    /**
     Populates the UI elements and adds reactions.
     */
    func bindData() {
        self.notesTextView.text = self.contact.note

        self.notesTextView.rac_textSignal().subscribeNext({ _ in
            self.changed = true
        })
        self.changed = false
    }
}
