//
//  SWBLegalDocsCells.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/25/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

protocol LegalDocsDependentCell {
    var legalDocs: SWBLegalDocsModel! {get set}
    var service: SWBLegalDocServiceProtocol? {get set}
    func bind()
}
class LegalDocsCell: UITableViewCell, LegalDocsDependentCell {
    var legalDocs: SWBLegalDocsModel!
    var service: SWBLegalDocServiceProtocol?

    /**
     Sync the data between the legalDocs object and the UI elements.
     */
    func bind() {}
}

class SWBLegalNotesCell: LegalDocsCell {
    @IBOutlet weak var notesTextView: UITextView!

    override func bind() {
        self.notesTextView.text = self.legalDocs.notes
        self.notesTextView?.rac_textSignal().subscribeNext({
            text in
            self.legalDocs.notes = self.notesTextView.text
        })
    }
}

class SWBTenantContractCell: LegalDocsCell {
    @IBOutlet weak var startDate: SWBDateButton!
    @IBOutlet weak var endDate: SWBDateButton!

    override func bind() {
        self.startDate.date = self.legalDocs.startDate
        self.endDate.date = self.legalDocs.endDate

        self.startDate.rac_dateChanged.subscribeNext({
            _ in
            self.legalDocs.startDate = self.startDate.date
            self.service?.syncTenantContractDate(self.legalDocs, path: .StartDate, value: self.startDate.date!)
        })

        self.endDate.rac_dateChanged.subscribeNext({
            _ in
            self.legalDocs.endDate = self.endDate.date
            self.service?.syncTenantContractDate(self.legalDocs, path: .EndDate, value: self.endDate.date!)
        })
    }
}

class SWBEpcValueCell: LegalDocsCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!

    override func bind() {
        self.textField.text = "\(self.legalDocs.epcValue ?? 0)"
        self.textField.rac_textSignal().subscribeNext({ _ in
            self.legalDocs.epcValue = Int(self.textField.text!)
        })
    }
}

class SWBEpcCategoryCell: LegalDocsCell {
    @IBOutlet var categoryButton: SWBEPCCategory!
    override func bind() {
        self.categoryButton.category = self.legalDocs.epcCategory ?? ""
        self.categoryButton.rac_newCategory.subscribeNext({ _ in
            self.legalDocs.epcCategory = self.categoryButton.category
        })
    }
}

class SWBPurchasedYearCell: SWBTableViewCellWithStepper, LegalDocsDependentCell {
    var legalDocs: SWBLegalDocsModel!
    var service: SWBLegalDocServiceProtocol?

    func bind() {
         self.stepper.value = self.legalDocs.purchasedYear
        self.stepper.rac_valueChanged().subscribeNext({ _ in
            self.legalDocs?.purchasedYear = self.stepper.value
        })
    }
}
