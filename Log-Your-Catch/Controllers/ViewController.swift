//
//  ViewController.swift
//  Log Your Catch
//
//  Created by Brad Strand on 26/7/20.
//  Copyright © 2020 Strand. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController {

//MARK: - Managers
    
    var locationManager = CLLocationManager()
    var localDataManager = LocalDataManager()
    var cloudDataManager = CloudDataManager()
    
//MARK: - IBOutlets
    
    @IBOutlet weak var lenLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var localRecords: UILabel!
    @IBOutlet weak var topLogLabel: UILabel!
    @IBOutlet weak var bottomLogLabel: UILabel!
    @IBOutlet weak var striperButton: UIButton!
    @IBOutlet weak var bluefishButton: UIButton!
    
//MARK: - Global Variables
    
    //set to true to print debug logs
    let debugPrint = false
    
    var len: Float = 30.0
    var fishType: String = "none"
    var released = true
    var locLogging = true
    var currentLocation: CLLocation?
    
//singleton of current running context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        localDataManager.context = context
        cloudDataManager.context = context
        
        if debugPrint { print(FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)) }
        
        localRecords.text = localDataManager.readFish()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

    }
    
//MARK:- IBActions
    
    //temporary function and button to test Login and Register
    @IBAction func forceLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLoginView", sender: self)
    }

    @IBAction func showCurrentLocationOnMap(_ sender: AnyObject) {
        locationManager.requestLocation()
        performSegue(withIdentifier: "goToMapView", sender: self)
    }
    
    @IBAction func striperPressed(_ sender: Any) {
        if debugPrint { print("Striper pressed") }
        self.fishType = "Striper"
        setAlphas(stripers: 1.0, bluefish: 0.3)
    }

    @IBAction func bluefishPressed(_ sender: Any) {
        if debugPrint { print("Bluefish pressed") }
        self.fishType = "Bluefish"
        setAlphas(stripers: 0.3, bluefish: 1.0)
    }
    
    // toggle whether location logging is desired
    @IBAction func loggingButton(_ sender: Any) {
        locLogging = !locLogging
        if debugPrint { print("logging set to \(locLogging)") }
    }
    
    // toggle released value
    @IBAction func releasedButton(_ sender: Any) {
        released = !released
        if debugPrint { print("released set to \(released)") }
    }
    
    @IBAction func lenSlider(_ sender: Any) {
        len = roundToHalf(input: slider.value)
        lenLabel.text = "\(len) inches"
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if (self.fishType == "none") {
            self.topLogLabel.text = "Please select species!"
            self.bottomLogLabel.text = ""
            return
        } else {
            if debugPrint { print("fishtype = \(self.fishType)") }
        }
        
        if locLogging { locationManager.requestLocation() }
        
        localDataManager.createRecord(released, fishType, len, locLogging, (currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!)
            localDataManager.saveFish()
        
        setAlphas(stripers: 1.0, bluefish: 1.0)
        fishType = "none"
        
        localRecords.text = localDataManager.readFish()
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        var count = 0
        localRecords.text = localDataManager.readFish()
        count = localDataManager.fishArray.count
        if debugPrint { print("\(count) local records found") }
        cloudDataManager.uploadToCloud(array: localDataManager.fishArray, saveFunc: localDataManager.saveFish)
        localRecords.text = localDataManager.readFish()
    }
    
//MARK: - Other Functions
    
    func roundToHalf(input: Float) -> Float {
        var output: Float
    
        let intPart:Int = Int(input)
        var otherPart: Float

        otherPart = input - Float(intPart)
        if (otherPart<0.5) {
            otherPart = 0.0
        } else {
            otherPart = 0.5
        }
        output = Float(intPart) + otherPart
        return(output)
    }
    
    func setAlphas (stripers striperAlpha: CGFloat, bluefish bluefishAlpha: CGFloat) {
        striperButton.alpha = striperAlpha
        bluefishButton.alpha = bluefishAlpha
    }

//MARK: - Prepare for Segues
    
    // shouldPerformSegue is called before a segue is performed to determine if it should be performed.
    // It passes in the segue's identifier, which is used in a switch statement to decide what should happen.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "goToMapView":
            if currentLocation == nil {
                return false
            } else {
                return true
            }
        case "goToLoginView":
            return true
        case "goToRegisterView":
            return true
        default:
            return true
        }
    }
    
    // prepare is called before a segue is performed, but only if shouldPerformSegue returns true.
    // It passes in the segue object, which is used in a switch statement to decide what should happen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToMapView":
            let mapVC = segue.destination as! MapViewController
            mapVC.location = currentLocation
        case "goToLoginView":
            return
        case "goToRegisterView":
            return
        default:
            return
        }
    }
}

//MARK: - LocationManager Delegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            // Update currentLocation for use in the MapView
            currentLocation = location
            
            if debugPrint { print("location in locationManager = \(String(describing: currentLocation))") }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
