//
//  CustomMapView.swift
//  GeoCoder Sample
//
//  Created by Kaio Henrique on 18/11/15.
//  Copyright © 2015 madewithlove. All rights reserved.
//

import MapKit
import GoogleMaps

protocol SWBMapUIElement {
    var view: UIView {get}
    func clear()
    func center(onCoordinate coordinate: CLLocationCoordinate2D)
    func addAnnotationAndCenter(coordinate: CLLocationCoordinate2D)
}

class SWBMapView: UIView {
    override var bounds: CGRect {
        didSet {
            self.subviews.first?.frame = self.bounds
        }
    }
    var mapView: SWBMapUIElement! {
        didSet {
            self.showMap()
        }
    }

    private func getMapUIView() -> SWBMapUIElement {
        //Use google maps as map view default
        if self.mapView == nil {
            self.mapView = GMSMapView()
        }
        return self.mapView
    }

    func showMap() {
        //Get the mapView
        if let view = self.mapView?.view {
            view.userInteractionEnabled = false
            view.frame = self.bounds

            //Add the map to the view
            self.addSubview(view)
        }
    }

    /**
     Center the map based on the coordinate informed.

     - parameter coordinate: coordinate where the map will centered
     */
    func center(onCoordinate coordinate: CLLocationCoordinate2D) {
        let mapView = self.getMapUIView()
        mapView.center(onCoordinate: coordinate)
    }

    /**
     Will get the location based on the address using MapKit and show the location on the map.

     - parameter address: Address that will be displayed. E.g `1 Infinite Loop, Cupertino, CA USA`
     */
    func center(fromAddress address: String) {
        self.hidden = true
        CLGeocoder().geocodeAddressString(address, completionHandler: { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                self.center(onCoordinate: location.coordinate)
                self.hidden = false
            }
            debugPrint(error)
        })
    }

    func clearAnnotations() {
        self.mapView?.clear()
    }

    func addAnnotationAndCenter(coordinate: CLLocationCoordinate2D) {
        let mapView = self.getMapUIView()
        mapView.addAnnotationAndCenter(coordinate)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension MKMapView:SWBMapUIElement {

    var view: UIView {
        return self
    }

    //Clear all annotations on MapView
    func clear() {
        self.removeAnnotations(self.annotations)
    }
    func center(onCoordinate coordinate: CLLocationCoordinate2D) {
        //add annotation region
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        self.setRegion(region, animated: true)
    }

    //Add an annotation and zoom to it's area
    func addAnnotationAndCenter(coordinate: CLLocationCoordinate2D) {

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        //add annotation
        self.addAnnotation(annotation)
        self.center(onCoordinate: coordinate)
    }
}


extension GMSMapView:SWBMapUIElement {
    var view: UIView {
        return self
    }

    func center(onCoordinate coordinate: CLLocationCoordinate2D) {
        //Centerized camera
        let camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 15)
        self.camera = camera
    }

    func addAnnotationAndCenter(coordinate: CLLocationCoordinate2D) {
        self.center(onCoordinate: coordinate)

        //Add marker with a custom icon
        let marker = GMSMarker(position: coordinate)
        marker.icon = UIImage(named: "iconfill")
        marker.map = self
    }
}
