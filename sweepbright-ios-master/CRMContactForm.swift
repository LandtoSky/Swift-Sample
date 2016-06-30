//
//  CRMContactForm.swift
//  SweepBright
//
//  Created by Kaio Henrique on 5/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SwiftValidator

private let WhatsappSectionChanged = "WhatsappSectionChanged"

class CRMContactForm: NSObject {
    let validator = Validator()
    let validatorPhoneEmail = Validator()

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var whatsappSection: UIView!
    @IBOutlet weak var whatsappSwitch: SWBSwitch!

    dynamic var formIsValid: Bool = false
    ///Inform if some field was editted
    dynamic var changed: Bool = false

    var contact: CRMContact! {
        didSet {
            self.fillForm()
            //Bind UI elements after set a contact
            self.firstNameTextField.rac_textSignal().subscribeNext({ _ in
                self.contact?.first_name = self.firstNameTextField.text
            })

            self.surnameTextField.rac_textSignal().subscribeNext({ _ in
                self.contact?.last_name = self.surnameTextField.text
            })

            self.phoneTextField.rac_textSignal().subscribeNext({ _ in
                self.contact?.phone = self.phoneTextField.text
            })

            self.emailTextField.rac_textSignal().subscribeNext({ _ in
                self.contact?.email = self.emailTextField.text
            })
            self.whatsappSwitch.rac_valueChanged().subscribeNext({ _ in
                self.contact?.is_whatsapp_user = self.whatsappSwitch.checked
            })
        }
    }
    /// Populates the form based on the contact object
    private func fillForm() {
        self.firstNameTextField.text = self.contact?.first_name
        self.surnameTextField.text = self.contact?.last_name
        self.phoneTextField.text = self.contact?.phone
        self.emailTextField.text = self.contact?.email
        self.whatsappSwitch.checked = self.contact?.is_whatsapp_user ?? false
    }
    private func addValidations() {
        validator.registerField(firstNameTextField, rules: [RequiredRule()])
        validator.registerField(surnameTextField, rules: [RequiredRule()])

        validatorPhoneEmail.registerField(phoneTextField, rules: [RequiredRule()])
        validatorPhoneEmail.registerField(emailTextField, rules: [EmailRule()])
    }

    /// Adds form validations and whatsapp listener
    func addReactions() {
        self.addValidations()
        RACSignal.merge([self.firstNameTextField.rac_textSignal(),
            self.surnameTextField.rac_textSignal(),
            self.emailTextField?.rac_textSignal(),
            self.whatsappSwitch.rac_valueChanged(),
            self.phoneTextField.rac_textSignal()
            ]).subscribeNext({ _ in
            self.changed = true
        })
        self.changed = false
        //Call validate the form whenever first name, surname or email has changed. At the moment, they're the only required on the API
        RACSignal.merge([self.firstNameTextField.rac_textSignal(),
            self.surnameTextField.rac_textSignal(),
            self.phoneTextField?.rac_textSignal(),
            self.emailTextField?.rac_textSignal()
            ])
            .subscribeNext({ _ in
            self.validate()
        })

        //Hide the whatsapp sectio if there is no phone number
        self.phoneTextField?.rac_textSignal().subscribeNext({ _ in
            let phoneNumberIsNotValid = self.phoneTextField.text!.isEmpty
            self.phoneButton?.hidden = phoneNumberIsNotValid
            if self.whatsappSection.hidden != phoneNumberIsNotValid {
                NSNotificationCenter.defaultCenter().postNotificationName(WhatsappSectionChanged, object: nil)
            }
            self.whatsappSection.hidden = phoneNumberIsNotValid
        })

        //Hide the email button if the email is not valid
        self.emailTextField?.rac_textSignal().subscribeNext({ _ in
            let notValidEmail = !EmailRule().validate(self.emailTextField.text!)
            self.emailButton?.hidden = notValidEmail
        })
    }
    func validate() {
        var firstNameAndSurnameValids = false
        self.validator.validate({ errors in
            firstNameAndSurnameValids = errors.keys.count == 0
        })

        var phoneOrEmailAreValid = false
        self.validatorPhoneEmail.validate({ errors in
            phoneOrEmailAreValid = errors.keys.count < 2
        })

        self.formIsValid = firstNameAndSurnameValids && phoneOrEmailAreValid
    }
    //MARK: Signals
    func rac_whatsappIsHidden() -> RACSignal {
        return NSNotificationCenter.defaultCenter().rac_addObserverForName(WhatsappSectionChanged, object: nil)
    }

    func rac_formIsValid() -> RACSignal {
        return self.rac_valuesAndChangesForKeyPath("formIsValid", options: .New, observer: nil)
    }
}
