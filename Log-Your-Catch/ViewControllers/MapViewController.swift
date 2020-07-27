//
//  MapViewController.swift
//  LocationManagerDemo
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var location:CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("after viewdidappear")
        //Setting Region
        print(location!)
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        print("center set")
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        print("before setregion")
        self.mapView.setRegion(region, animated: true)
        
        //Adding Pin, no longer necessary, pin added in storyboard
        /*
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "My Location"
        self.mapView.addAnnotation(objectAnnotation)
        
        */
    }
}
