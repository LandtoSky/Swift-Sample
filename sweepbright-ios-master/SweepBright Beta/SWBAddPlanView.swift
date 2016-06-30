//
//  SWBAddPlanView.swift
//  SweepBright
//
//  Created by Kaio Henrique on 1/19/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import UIKit

class SWBAddPlanView: UIView {
    var plan: SWBPlan!
    private var surfaces: [SWBSurface] {
        get {
            return self.plan.surfaces
        }
    }
    dynamic var surfaceViews: [SWBSurfaceView] = []

    //render the surfaces
    func renderSurfaces() {
        //Removing surfaceviews from uiview
        for surfaceView in self.surfaceViews {
            surfaceView.removeFromSuperview()

            let index = self.surfaceViews.indexOf(surfaceView)
            self.surfaceViews.removeAtIndex(index!)
        }

        //Add surfaces on uiview
        for surface in self.surfaces {
            self.addBox(surface)
        }
    }

    func addSurface(surface: SWBSurface) {
        var surface = surface

        //convert the surface point to iPhone 4S resolution
        surface.position = convertPointToSave(surface.position, fromResolution: self.frame)
        //Insert surface on surface array
        plan.surfaces.append(surface)
        //render surface
        self.addBox(surface)
    }

    func addBox(surface: SWBSurface) {
        //Convert the position from iPhone 4S to current device
        let frame = convertPoint(CGSize(width: 75.0, height: 65), position: surface.position, viewResolution: self.frame.size)
        //create a surface view
        let box = SWBSurfaceView(frame: frame)
        box.surface = surface
        box.center = frame.origin
        //add surface view on the screen
        self.addSubview(box)
        //insert surface view in the surface view array
        surfaceViews.append(box)
    }


    private func convertPointToSave(position: CGPoint, fromResolution resolution: CGRect) -> CGPoint {
        let x_diff: CGFloat = 320.0/resolution.width
        let y_diff: CGFloat = 480.0/resolution.height

        //Getting the correct size and position
        let x = position.x * x_diff
        let y = position.y * y_diff

        return CGPointMake(x, y)
    }

    private func convertPoint(size: CGSize, position: CGPoint, viewResolution: CGSize, originalSize: CGSize = CGSize(width: 320.0, height: 480.0)) -> CGRect {

        //Calculate the resolytion diff
        let originalWidth  = originalSize.width
        let originalHeight = originalSize.height

        let x_diff: CGFloat = viewResolution.width/originalWidth
        let y_diff: CGFloat = viewResolution.height/originalHeight

        //Getting the correct size and position
        let x = position.x * x_diff
        let y = position.y * y_diff

        let width  = size.width * x_diff
        let height = size.height * y_diff

        //Return the correct CGRect
        let point = CGPointMake(x, y)
        let size = CGSize(width: width, height: height)

        return CGRect(origin: point, size: size)
    }
}
