//
//  ViewController.swift
//  LocationManagerDemo
//
//  Created by Rajan Maheshwari on 22/10/16.
//  Copyright © 2016 Rajan Maheshwari. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    
    var len: float_t = 30.0
    var fishType: String = "none"
    var released = true
    var locLogging = true
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    var localRecordCnt = 0
    
     //singleton of current running context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in:.userDomainMask))
        
        readFish()
        print("viewDidLoad count = \(localRecordCnt)")
        localRecords.text = "Local records stored: \(localRecordCnt)"
    }

    func resetLabels() {
        latitudeLabel.text = "Latitude"
        longitudeLabel.text = "Longitude"
    }
    
    func alertMessage(message:String,buttonText:String,completionHandler:(()->())?) {
        let alert = UIAlertController(title: "Location", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default) { (action:UIAlertAction) in
            completionHandler?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- IBActions


    @IBAction func showCurrentLocationOnMap(_ sender: AnyObject) {
        //self.resetLabels()

        LocationManager.shared.getLocation { (location:CLLocation?, error:NSError?) in
            if error != nil {
                self.alertMessage(message: (error?.localizedDescription)!, buttonText: "OK", completionHandler: nil)
                return
            }
            guard let location = location else {
                return
            }

            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            
            mapVC.location = location
        }
    }
    
    @IBOutlet weak var lenLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var localRecords: UILabel!
    
    @IBAction func striperPressed(_ sender: Any) {
        // print("Striper pressed")
        self.fishType = "Striper"
        maskBluefish.alpha = 0.7
        maskStriper.alpha = 0.0
    }
    
    
    @IBAction func bluefishPressed(_ sender: Any) {
        // print("Bluefish pressed")
        self.fishType = "Bluefish"
        maskStriper.alpha = 0.7
        maskBluefish.alpha = 0.0
    }
    
    func uploadToCloud(arr: [CaughtFish]){
        
        var count = arr.count
        
        print("uploadToCloud called: record count = \(arr.count)")
        
        while (count > 0) {
            print("fish length \(arr[count-1].length) being removed")
            context.delete(arr[count-1])
            saveFish()
            count = count - 1
        }
        readFish()
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        
        var count = 0
        
        readFish()
        count = fishArray.count
        print("\(count) local records found")
        uploadToCloud(arr: fishArray)
    /*
        for i in 0...(count-1) {
            print("\(String(describing: fishArray[i].species))   \(fishArray[i].length) inches long")
        }
 */
    
    }
    
    func roundToHalf(inVal: float_t) -> float_t {
        var retval: float_t
    
        let intPart:Int = Int(inVal)
        var otherPart: float_t
        
        otherPart = inVal - Float(intPart)
        if (otherPart<0.5) {
            otherPart = 0.0
        } else {
            otherPart = 0.5
        }

        retval = Float(intPart) + otherPart
        return(retval)
    }
    
    func getDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = format.string(from: date)
        // print(formattedDate)
        return(formattedDate)
    }
/*
    var len: float_t = 30.0
    var fishType: String = "none"
    var released = true
    var locLogging = true
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    var localRecordCnt = 0
*/
    @IBOutlet weak var topLogLabel: UILabel!
    @IBOutlet weak var bottomLogLabel: UILabel!
    @IBOutlet weak var maskStriper: UIImageView!
    @IBOutlet weak var maskBluefish: UIImageView!
    
    // toggle whether location logging is desired
    @IBAction func loggingButton(_ sender: Any) {
        locLogging = !locLogging
        print("logging set to \(locLogging)")
    }
    
    // toggle released value
    @IBAction func releasedButton(_ sender: Any) {
        released = !released
        print("released set to \(released)")
    }
    
    @IBAction func lenSlider(_ sender: Any) {
        len = roundToHalf(inVal: slider.value)
        lenLabel.text = "\(len) inches"
    }
    
    func saveFish() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    var fishArray = [CaughtFish]()
    
    func readFish() {
        
        let request : NSFetchRequest<CaughtFish> = CaughtFish.fetchRequest()
        do {
            fishArray = try context.fetch(request)
            print("count of records read = \(fishArray.count)")
            localRecordCnt = fishArray.count
            localRecords.text = "Local records stored: \(localRecordCnt)"
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
  
    
    @IBAction func doneButton(_ sender: Any) {
        
        if (self.fishType == "none") {
            self.topLogLabel.text = "Please select species!"
            self.bottomLogLabel.text = ""
            return
        } else {
            print("fishtype = \(self.fishType)")
        }
        
        LocationManager.shared.getLocation { (location:CLLocation?, error:NSError?) in
                 
            if error != nil {
                self.alertMessage(message: (error?.localizedDescription)!, buttonText: "OK", completionHandler: nil)
                return
            }
            guard let location = location else {
                self.alertMessage(message: "Unable to fetch location", buttonText: "OK", completionHandler: nil)
                return
            }
    
            self.currentLatitude = location.coordinate.latitude
            self.currentLongitude = location.coordinate.longitude
            //print("lat = \(self.currentLatitude)")
            //print("long = \(self.currentLongitude)")
        
            if (self.released == true) {
                
                // \u{22} is how " character is printed in Swift
            
        
                self.topLogLabel.text = "\(String(describing: self.getDate())) \(self.fishType) \(self.len)\u{22} released"
            } else {
                self.topLogLabel.text = "\(String(describing: self.getDate())) \(self.fishType) \(self.len)\u{22} kept"
            }
            
            if (self.locLogging) {
                var dLat: Double
                var dLong: Double
                
                var iLat: Int
                var iLong: Int
                
                dLat = self.currentLatitude
                dLong = self.currentLongitude
                
                iLat = Int(dLat * 100000)
                dLat = Double( iLat ) / 100000.0
                
                iLong = Int(dLong * 100000)
                dLong = Double( iLong ) / 100000.0
                
                
                //let strLat = String(format: "%.5f",(\(self.currentLatitude)))
                //self.bottomLogLabel.text = "location \(self.currentLatitude), \(self.currentLongitude)"
                self.bottomLogLabel.text = "location = \(dLat), \(dLong)"
            //print("location = \(locValue.latitude) \(locValue.longitude)")
            } else {
                self.bottomLogLabel.text = ""
            }
            
            let thisFish = CaughtFish(context: self.context)
        
            thisFish.date = self.getDate()
            thisFish.released = self.released
            thisFish.species = self.fishType
            thisFish.length = self.len
            if (self.locLogging) {
                thisFish.latitude = self.currentLatitude
                thisFish.longitude = self.currentLongitude
            }
            // write the record to CoreData
            self.saveFish()
            
        }
        
        maskStriper.alpha = 0.0
        maskBluefish.alpha = 0.0
        localRecordCnt += 1
        localRecords.text = "Local records stored: \(localRecordCnt)"
        //print("about to reset fish type")
        //self.fishType = "none"
    }
    
}
