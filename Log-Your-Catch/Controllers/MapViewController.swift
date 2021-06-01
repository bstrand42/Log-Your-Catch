//
//  MapViewController.swift
//  Log Your catch
//
//  Created by Brad Strand on 26/7/20
//  Copyright © 2020-2021 Strand. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
  
    var location: CLLocation?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //Setting Region
        
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
