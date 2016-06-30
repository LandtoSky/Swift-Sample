//
//  SWBYearStepper.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/6/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit
import ReactiveCocoa

class BorderedTextField: UITextField {
    var linesColor: UIColor = UIColor.getBorderColor()

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let linesWidth: CGFloat = 1.0

        let topLine = CGRect(x: 0.0, y: 0.0, width: rect.size.width, height: linesWidth)

        let bottomLine = CGRect(x: -1.0, y: rect.size.height - linesWidth, width: rect.size.width + 1, height: linesWidth)
        self.add(bottomLine, color: self.linesColor.CGColor)
        self.add(topLine, color: self.linesColor.CGColor)
    }
}

class SWBYearStepper: UIView {
    internal var countTextField: UITextField!
    internal var incrementButton: UIButton!
    internal var decrementButton: UIButton!

    private dynamic var currentValue: Int = 0
    var value: Int! {
        set(newValue) {
            if newValue == nil {
                self.currentValue = 0
            //Preventing current value to be outside minValue and maxValue
            } else if (newValue >= self.minValue) && (newValue <= self.maxValue) {
                self.currentValue = newValue
            }

            self.countTextField.text = "\(self.value)"
        }
        get {
            return self.currentValue
        }
    }

    var valueChangeBlock:(()->()) = {}

    //Creating IBInspectable variables
    @IBInspectable var maxValue: Int = 2999
    @IBInspectable var minValue: Int = 0

    @IBInspectable var hidesDecrementWhenMinimum: Bool = false// default: NO
    @IBInspectable var hidesIncrementWhenMaximum: Bool = false// default: NO
    @IBInspectable var elementsTintColor: UIColor = UIColor.getStepperColor()
    var stackView = UIStackView(frame: CGRect.zero)
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.createComponents()
    }

    //Initialize the classe populating the data as desired
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.createComponents()
    }

    /**
     Create a button on the style of the stepper

     - parameter image: Image that will be on the background of the button
     - parameter action: Target executed on the TouchUpInside action of the button
     - returns: A button object
     */
    private func createButton(image: UIImage, action: Selector) -> UIButton {
        let button = UIButton(type: .Custom)
        button.setImage(image, forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)

        return button
    }

    /**
     Create edit text on the middle of the stepper with correct style.
     - returns: text field object
     */
    private func createCountLabel() -> UITextField {

        let font = UIFont(name: "LFT Etica", size: 14.0)!

        let countTextField = BorderedTextField(frame: CGRect.zero)

        countTextField.textAlignment = .Center
        countTextField.textColor = self.elementsTintColor
        countTextField.backgroundColor = UIColor.whiteColor()
        countTextField.keyboardType = .NumberPad
        countTextField.font = font
        countTextField.rac_signalForControlEvents([.EditingDidEnd])
            .subscribeNext({
                value in
                self.value = Int(countTextField.text!)
                self.valueChangeBlock()
            })
        return countTextField
    }

    private func createComponents() {
        self.layer.cornerRadius = 2.0

        self.backgroundColor = UIColor.whiteColor()

        //Creating an UIStackView
        self.stackView = UIStackView()
        self.stackView.alignment = .Fill
        self.stackView.distribution = .FillEqually
        self.stackView.axis = .Horizontal
        self.stackView.spacing = 0.0
        self.stackView.backgroundColor = UIColor.whiteColor()
        self.stackView.translatesAutoresizingMaskIntoConstraints = false

        //Creating decrement button
        self.decrementButton = self.createButton(UIImage(named: "decrease")!, action: #selector(SWBYearStepper.decrementValue(_:)))
        stackView.addArrangedSubview(self.decrementButton)

        //creating countLabel
        self.countTextField = self.createCountLabel()
        stackView.addArrangedSubview(self.countTextField)

        //Creating increment button
        self.incrementButton = self.createButton(UIImage(named: "Increase")!, action: #selector(SWBYearStepper.incrementValue(_:)))
        stackView.addArrangedSubview(self.incrementButton)

        self.addSubview(stackView)

        //Add contrainsts to stackView
        let centerY = NSLayoutConstraint(item: self.stackView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        let leading = NSLayoutConstraint(item: self.stackView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: self.stackView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
        let equalHeight = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: self.stackView, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let height = NSLayoutConstraint(item: self.stackView, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 29.0)
        self.addConstraints([leading, trailing, centerY, equalHeight, height])

        self.countTextField.text = "\(self.value)"

    }

    //MARK: ReactiveCocoa
    func rac_valueChanged() -> RACSignal {
        return self.rac_valuesAndChangesForKeyPath("currentValue", options: .New, observer: self)
    }

    func getCountTextFieldAsInt() -> Int {
        return (Int(countTextField.text!) ?? 0)
    }

    //MARK: Targets
    internal func decrementValue(sender: UIButton?) {
        let newValue = self.getCountTextFieldAsInt() - 1
        //Prevent value to be small than the minimun value
        self.value = max(newValue, self.minValue)
        self.valueChangeBlock()
    }

    internal func incrementValue(sender: UIButton?) {
        let newValue = self.getCountTextFieldAsInt() + 1
        //Prevent the value to be bigger than the maximun value
        self.value = min(newValue, self.maxValue)
        self.valueChangeBlock()
    }
}
