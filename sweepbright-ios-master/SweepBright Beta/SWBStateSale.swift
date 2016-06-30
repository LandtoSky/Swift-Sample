//
//  SWBStateSale.swift
//  SweepBright
//
//  Created by Kaio Henrique on 4/26/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import ReactiveCocoa

struct SWBProgressStatusColor {
    var startWithColor: UIColor = UIColor.whiteColor()
    var endWithColor: UIColor = UIColor.blackColor()
    var selectedColor: UIColor? = nil

    func getColor(atPosition position: CGFloat) -> UIColor {
        //prevent a position not in the 0..1.0 range
        var position = min(position, 1.0)
        position = max(position, 0)

        //Get RGB colors from the startWithColor
        var redColor: CGFloat = 0.0
        var greenColor: CGFloat = 0.0
        var blueColor: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        self.startWithColor.getRed(&redColor, green: &greenColor, blue: &blueColor, alpha: &alpha)

        //Get RGB colors from the endWithColor
        var redColorFinal: CGFloat = 0.0
        var greenColorFinal: CGFloat = 0.0
        var blueColorFinal: CGFloat = 0.0
        self.endWithColor.getRed(&redColorFinal, green: &greenColorFinal, blue: &blueColorFinal, alpha: &alpha)

        //Get RGB colors at the position
        let positionRedColor = redColor + (position * (redColorFinal - redColor))
        let positionGreenColor = greenColor + (position * (greenColorFinal - greenColor))
        let positionBlueColor = blueColor + (position * (blueColorFinal - blueColor))

        return UIColor(red: positionRedColor, green: positionGreenColor, blue:positionBlueColor, alpha:1.00)
    }
}

protocol SWBElementWithIndex {
    var index: Int {get set}
}
@IBDesignable class SWBStateSale: UIStackView, PropertyDependent {
    dynamic var index: Int = 0 {
        didSet {
            self.updateStatus()
        }
    }
    var property: SWBProperty! {
        didSet {
            for arrangedView in self.arrangedSubviews {
                self.removeArrangedSubview(arrangedView)
            }
            self.insertBars()
            self.updateStatus()
        }
    }
    var stateSale: SWBPropertyStatusSettings {
        get {
            return self.status[self.index]
        } set (newValue) {
            self.index = self.status.indexOf(newValue) ?? 0
        }
    }

    private var status: [SWBPropertyStatusSettings] {
        return self.property?.status == .ForSale ? [.Available, .Option, .Bid, .Sold, .Closed] : [.Available, .Option, .Bid, .Rented]
    }

    var colors: [SWBProgressStatusColor] {
        //Base to the whole gradient
        let initialColor = UIColor(red:0.09, green:0.66, blue:0.90, alpha:1.00)
        let finalColor = UIColor(red:0.20, green:0.83, blue:0.96, alpha:1.00)

        //Create a base gradient, it's going to be helpfull to get the color at the position of the gradient
        let baseColor = SWBProgressStatusColor(startWithColor: initialColor, endWithColor: finalColor, selectedColor: nil)

        //Getting the number of states based on the status attribute
        let totalOfSteps: CGFloat = CGFloat(self.status.count)
        let increaser: CGFloat = 1.0/totalOfSteps

        let clearColor = UIColor.whiteColor()
        var listOfColors: [SWBProgressStatusColor] = []

        for i in 0..<Int(totalOfSteps) {
            //Get current color and next based on the position
            let position: CGFloat = CGFloat(i)*increaser
            let color = baseColor.getColor(atPosition: position)
            let nextColor = baseColor.getColor(atPosition: CGFloat(i+1)*increaser)

            //The SWBProgressStatus creates a gradient on the left side of the element, so the first one must be empty
            var statusColor: SWBProgressStatusColor!
            switch i {
            case 0:
                statusColor = SWBProgressStatusColor(startWithColor: clearColor, endWithColor: clearColor, selectedColor: color)
            default:
                statusColor = SWBProgressStatusColor(startWithColor: color, endWithColor: nextColor, selectedColor: nextColor)
            }
            listOfColors.append(statusColor)
        }

        return listOfColors
    }
    var rac_valueChanged: RACSignal {
        return self.rac_valuesAndChangesForKeyPath("index", options: .New, observer: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.axis = .Horizontal
        self.insertBars()
    }

    @IBAction func selectStatus(indexButton: SWBIndexButton) {
        self.selectStatus(indexButton as SWBElementWithIndex)
    }

    func selectStatus(elementWithIndex: SWBElementWithIndex) {
        self.index = elementWithIndex.index
    }

    func updateStatus() {
        //Select the elements on the left of the selected index
        for selectedStatusView in self.arrangedSubviews.prefix(self.index+1).map({$0 as! SWBProgressStatus}) {
            selectedStatusView.selected = true
        }
        //Unselecting the elements on the right of the selected index
        let suffixCount = max(self.arrangedSubviews.count - self.index-1, 0)
        for unselectedStatusView in self.arrangedSubviews.suffix(suffixCount).map({$0 as! SWBProgressStatus}) {
            unselectedStatusView.selected = false
        }
    }

    func insertBars() {
        let colorsCount = self.colors.count

        for i in 0..<colorsCount {
            let color = colors[i]
            let progress: SWBProgressStatus = SWBProgressStatus(colours: color)
            progress.index = i
            self.addArrangedSubview(progress)
        }
    }
}

@IBDesignable class SWBProgressStatus: UIView, SWBElementWithIndex {
    //A view with a gradient color, a circle icon and the option of selecting
    var startWithColor: UIColor {
        return self.colours?.startWithColor ?? UIColor.whiteColor()
    }

    var endWithColor: UIColor {
        return self.colours?.endWithColor ?? UIColor.blackColor()
    }

    var selectedColor: UIColor {
        return self.colours?.selectedColor ?? UIColor.blackColor()
    }
    var colours: SWBProgressStatusColor?

    @IBOutlet var progressView: SWBProgressViewGradient!
    @IBOutlet var ovalImage: UIButton!
    @IBOutlet weak var lineView: UIView!
    var index: Int = -1

    @IBInspectable var image: UIImage = UIImage(named: "oval")!

    var selected: Bool = true {
        didSet {
            //Show the gradientLine if the view is selected
            self.progressView.hidden = !self.selected
            self.lineView.hidden = self.selected

            //Show the normal oval image if the view is not selected
            self.ovalImage.setImage(self.getOvalImage(), forState: .Normal)
            self.ovalImage.tintColor = self.selected ? self.selectedColor : UIColor.whiteColor()
        }
    }

    private func getOvalImage() -> UIImage {
        //Change rendering mode of the image to be able to change the color
        return self.selected ? image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate) : image
    }

    init(colours: SWBProgressStatusColor) {
        super.init(frame: CGRect.zero)
        self.colours = colours
        self.addProgressView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addProgressView()
    }

    private func addProgressView() {
        //Load view from a Nib file
        let view = NSBundle.mainBundle().loadNibNamed("SWBStateSale", owner: self, options: nil).first as? UIView
        view?.frame = self.bounds

        self.progressView.startWithColor = self.startWithColor
        self.progressView.endWithColor   = self.endWithColor

        //Force to unselected the view
        self.selected = false
        self.addSubview(view!)
    }
    @IBAction func select() {
        if let stateSaleView = self.superview as? SWBStateSale {
            stateSaleView.selectStatus(self)
        }
    }
}

@IBDesignable class SWBProgressViewGradient: UIView {
    //This is just a view with a gradient background
    @IBInspectable var startWithColor: UIColor = UIColor.whiteColor()
    @IBInspectable var endWithColor: UIColor   = UIColor.blackColor()

    var colors: [CGColor] {
        return [startWithColor, endWithColor].map({$0.CGColor})
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        //Add a gradient layer with 2 colours
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = self.colors
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.startPoint = CGPointMake(0, 0.5)
        gradientLayer.endPoint = CGPointMake(1.0, 0.5)
        self.layer.addSublayer(gradientLayer)
    }
}
