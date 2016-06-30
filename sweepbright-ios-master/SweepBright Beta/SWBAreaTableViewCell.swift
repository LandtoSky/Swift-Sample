//
//  SWBAreaTableViewCell.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

protocol SWBRoomServiceDelegate {
    var service: SWBRoomServiceProtocol {get }
    var serviceProperty: SWBProperty { get}
}

class SWBAreaTableViewCell: UITableViewCell {

    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!

    var cellDelegate: SWBRoomServiceDelegate!

    var room: SWBRoom! {
        didSet {

            self.descriptionLabel?.text = "\(room.structure.rawValue.capitalizedString)"

            if let areaLabel = self.areaLabel {
                areaLabel.text = "\(room.area) sqft"
            }

            if let areaTextField = self.areaTextField {
                areaTextField.text = "\(room.area)"
                areaTextField.rac_signalForControlEvents(.EditingDidEnd).subscribeNext({
                    _ in
                    self.cellDelegate?.service.setValueForProperty( self.cellDelegate!.serviceProperty.id, op:"replace", path: "/structure/rooms/\(self.room.id)/size", value: self.areaTextField.text!, completionHandler: {
                        _ in

                    })
                })
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.areaTextField.delegate = self
        self.areaTextField.rac_signalForControlEvents(.EditingDidBegin).filter({_ in self.areaTextField.text == "0.0"}).subscribeNext({
            _ in
            self.areaTextField.text = ""
        })
    }
}

extension SWBAreaTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
