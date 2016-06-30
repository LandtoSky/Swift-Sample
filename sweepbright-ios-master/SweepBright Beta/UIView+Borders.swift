//
//  UIView+Borders.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/9/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

public extension UIView {
    func topLine(withRect rect: CGRect) -> CGRect {
        return CGRect(x: 0.0, y: 0.0, width: rect.size.width, height: 1.0)
    }
    func bottomLine(withRect rect: CGRect) -> CGRect {
        return CGRect(x: -1.0, y: rect.size.height - 1.0, width: rect.size.width + 1, height: 1.0)
    }
    func add(line: CGRect, color: CGColor) {
        let border = CALayer()
        border.frame = line
        border.backgroundColor = color
        layer.addSublayer(border)
    }
}
