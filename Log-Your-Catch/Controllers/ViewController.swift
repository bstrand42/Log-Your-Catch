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
import Firebase

func getDate() -> String {
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = K.dateFormat
    let formattedDate = format.string(from: date)
    // print(formattedDate)
    return(formattedDate)
}

class ViewController: UIViewController {

//MARK: - Managers
    
    let locationManager = CLLocationManager()
    let localDataManager = LocalDataManager()
    let cloudDataManager = CloudDataManager()
    
//MARK: - IBOutlets
    
    @IBOutlet weak var lenLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var localRecords: UILabel!
    @IBOutlet weak var logLabel: UILabel!
    @IBOutlet weak var striperButton: UIButton!
    @IBOutlet weak var bluefishButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    
//MARK: - Global Variables
    
    var len: Float = 30.0
    var fishType = K.FishType.nilFish
    var released = true
    var locLogging = true
    var currentLocation: CLLocation?
    
//singleton of current running context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapButton.isHidden = true
        
        locationManager.delegate = self
        localDataManager.context = context
        cloudDataManager.context = context
        
        if coreDataDebug { print(FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)) }
        
        localRecords.text = localDataManager.readFish()
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()

    }
    
//MARK:- IBActions

    @IBAction func showCurrentLocationOnMap(_ sender: AnyObject) {
        locationManager.requestLocation()
        performSegue(withIdentifier: K.Segue.goToMapView, sender: self)
    }
    
    @IBAction func striperPressed(_ sender: Any) {
        if UIDebug { print("Striper pressed") }
        self.fishType = K.FishType.striper
        setAlphas(stripers: 1.0, bluefish: 0.3)
        // clear any messages that may be lingering
        self.logLabel.text = ""
    }

    @IBAction func bluefishPressed(_ sender: Any) {
        if UIDebug { print("Bluefish pressed") }
        self.fishType = K.FishType.bluefish
        setAlphas(stripers: 0.3, bluefish: 1.0)
        // clear any messages that may be lingering
        self.logLabel.text = ""
    }
    
    // toggle whether location logging is desired
    @IBAction func loggingButton(_ sender: Any) {
        locLogging = !locLogging
        if UIDebug { print("logging set to \(locLogging)") }
    }
    
    // toggle released value
    @IBAction func releasedButton(_ sender: Any) {
        released = !released
        if UIDebug { print("released set to \(released)") }
    }
    
    @IBAction func lenSlider(_ sender: Any) {
        len = roundToHalf(input: slider.value)
        lenLabel.text = "\(len) inches"
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        let date = getDate()
        var rstring = ""
        var latitude = 0.0
        var longitude = 0.0
        
        if (self.fishType == K.FishType.nilFish) {
            self.logLabel.text = "Please select species!"
            return
        } else {
            if UIDebug { print("fishtype = \(self.fishType)") }
        }
        
        /*
        if locLogging { locationManager.requestLocation() }
        
        localDataManager.createRecord(released, fishType, len, locLogging, (currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!)
            localDataManager.saveFish()
        */
        
        if locLogging {
            locationManager.requestLocation()
            latitude = (currentLocation?.coordinate.latitude)!
            longitude = (currentLocation?.coordinate.longitude)!
        } else {
            latitude = 0.0
            longitude = 0.0
        }
        localDataManager.createRecord(released, fishType, len, locLogging, latitude, longitude)
        localDataManager.saveFish()
        
        if released == true {
            rstring = "released"
        } else {
            rstring = "kept"
        }
        
        if locLogging {
            self.logLabel.text = "\(len)\u{22} \(fishType) \(rstring) at \(date) \nLocation (\(latitude), \(longitude))"
        } else {
            self.logLabel.text = "\(len)\u{22} \(fishType) \(rstring) at \(date)"
        }

        // TODO: I think the following two lines of code should be removed.  Nice not to have to select fish type every time...
        setAlphas(stripers: 1.0, bluefish: 1.0)
        fishType = K.FishType.nilFish
        
        // updates the count of locally stored records
        localRecords.text = localDataManager.readFish()
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        var count = 0
        localRecords.text = localDataManager.readFish()
        count = fishArray.count
        if coreDataDebug { print("\(count) local records found") }
        cloudDataManager.uploadToCloud(array: fishArray, saveFunc: localDataManager.saveFish) { (shouldSegue) in
            if shouldSegue {
                self.performSegue(withIdentifier: K.Segue.goToLoginView, sender: self)
            }
        }
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
    
    // "shouldPerformSegue" is called before a segue is performed to determine if it should be performed.
    // It passes in the segue's identifier, which is used in a switch statement to decide what should happen.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case K.Segue.goToMapView:
            if currentLocation == nil {
                return false
            } else {
                return true
            }
        case K.Segue.goToLoginView:
            return true

        default:
            return true
        }
    }
    
    // "prepare" is called before a segue is performed, but only if shouldPerformSegue returns true.
    // It passes in the segue object, which is used in a switch statement to decide what should happen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case K.Segue.goToMapView:
            let mapVC = segue.destination as! MapViewController
            mapVC.location = currentLocation
        case K.Segue.goToLoginView:
            return
        default:
            return
        }
    }
    
    @IBAction func unwindToMainViewController(_ unwindSegue: UIStoryboardSegue) {
    }
    
}

//MARK: - LocationManager Delegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            // Update currentLocation for use in the MapView
            currentLocation = location
            
            if locationDebug { print("location in locationManager = \(String(describing: currentLocation))") }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
