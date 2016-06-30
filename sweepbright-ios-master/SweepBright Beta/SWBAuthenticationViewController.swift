//
//  SWBAuthenticationViewController.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JDStatusBarNotification
import SwiftValidator
import ReactiveCocoa

class SWBAuthenticationViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var formStackView: UIStackView!
    @IBOutlet weak var alertLabel: UILabel!

    let validator = Validator()

    var formValid: Bool = false {
        didSet {
            self.signInButton.hidden = !self.formValid
            self.alertLabel.hidden = self.formValid
        }
    }

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var authService: SWBAuthenticationService = SWBAuthService()
    var authDelegate: SWBAuthenticationServiceDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.authDelegate = self.authDelegate ?? self
        self.authService.delegate = self.authDelegate

        //Add Validation
        validator.registerField(self.usernameTextField, errorLabel: self.alertLabel, rules: [RequiredRule()])

        //Validate textFields whenever there changes
        RACSignal.merge([self.usernameTextField.rac_newTextChannel()]).subscribeNext({
            _ in
            self.validator.validate(self)
        })

        //The user will put the app in background, open the mail client and open the link.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleAuthenticatedUser), name: UIApplicationDidBecomeActiveNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SWBAuthenticationViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SWBAuthenticationViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        UIView.animateWithDuration(0.5, animations: {
            self.bottomConstraint.constant = 250.0
        })
    }

    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.5, animations: {
            self.bottomConstraint.constant = 15.0
        })
    }

    //Dismiss keyboard when touch on the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func signIn(sender: AnyObject) {
        AlertFactory.loadingAlert(withTitle: "Sign In", onController: self, animated: true, completionHandler: {
            self.authService.signIn(withEmail: self.usernameTextField.text!)
        })
    }

    func handleAuthenticatedUser() {
        self.formStackView.hidden = true
        //Offline authentication
        if self.authService.userIsAuthenticated() {
            self.showMainScreen()
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.formStackView.hidden = false
            })
        }
    }
    func showMainScreen() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.performSegueWithIdentifier("signInSegue", sender: self)
    }
}

extension SWBAuthenticationViewController: ValidationDelegate {
    func validationSuccessful() {
        self.formValid = true
    }

    func validationFailed(errors: [UITextField : ValidationError]) {
        let (_, error) = errors.first!
        self.alertLabel.text = error.errorMessage
        self.formValid = false
    }
}

extension SWBAuthenticationViewController:SWBAuthenticationServiceDelegate {
    func successfulSignIn() {
        self.dismissViewControllerAnimated(false, completion: {
            //Instance an Alert with connecting message
            let alert = UIAlertController(title: "Check your email to proceed", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }

    func unsuccessfulSignIn(error: NSError?) {
        var errorDescription = "Invalid credentials"
        if let _ = error {
            errorDescription = error!.domain
        }

        JDStatusBarNotification.showWithStatus(errorDescription, dismissAfter: 3.0, styleName: JDStatusBarStyleError)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
