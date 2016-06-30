//
//  PropertyImage.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/5/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation

enum Visibility: String {
    case Published = "PUBLISHED"
    case Private = "PRIVATE"

    func opposite() -> Visibility {
        switch self {
        case Published:
            return Private
        default:
            return Published
        }
    }

    static func opposite(visibility: Visibility) -> Visibility! {
        return visibility.opposite()
    }
}

protocol SWBPropertyImage:class {
    var data: String { get set }
    var visibility: Visibility! { get set }
    var image: UIImage! { get set }
}

class PropertyImage: NSObject, SWBPropertyImage, NSCopying {
    var data: String = ""
    var visibility: Visibility!
    var image: UIImage!

    init(data: String, visibility: Visibility = .Private, image: UIImage?) {
        self.data = data
        self.visibility = visibility
        self.image = image
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        return PropertyImage(data: self.data, visibility: self.visibility, image: self.image)
    }

    func equalsTo(pImage: PropertyImage) -> Bool {
        return (self.data == pImage.data) && (self.visibility == pImage.visibility) && (self.image == pImage.image)
    }

}
