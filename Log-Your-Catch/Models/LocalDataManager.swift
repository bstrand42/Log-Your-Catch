//
//  LocalDataManager.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 8/3/20.
//  Copyright © 2020 Strand. All rights reserved.
//

import Foundation
import CoreData

class LocalDataManager {
    
    var fishArray = [CaughtFish]()
    
    var context: NSManagedObjectContext?
    
    func getDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = K.dateFormat
        let formattedDate = format.string(from: date)
        // print(formattedDate)
        return(formattedDate)
    }
    
    func createRecord(_ released: Bool, _ fishType: String, _ len: Float, _ locLogging: Bool, _ currentLatitude: Double, _ currentLongitude: Double) {
        
        let thisFish = CaughtFish(context: context!)
        
        thisFish.date = getDate()
        thisFish.released = released
        thisFish.species = fishType
        thisFish.length = len
        if (locLogging) {
            thisFish.latitude = currentLatitude
            thisFish.longitude = currentLongitude
        } else {
            thisFish.latitude = 0.0
            thisFish.longitude = 0.0
        }
        
    }
    
    func saveFish() {
        do {
            try context!.save()
        } catch {
            if coreDataDebug { print("Error saving context: \(error)") }
        }
    }
    
    func readFish() -> String {
        
        let request : NSFetchRequest <CaughtFish> = CaughtFish.fetchRequest()
        do {
            fishArray = try context!.fetch(request)
            if coreDataDebug { print("count of records read = \(fishArray.count)") }
            return "Local records stored: \(fishArray.count)"
        } catch {
            if coreDataDebug { print("Error fetching data from context: \(error)") }
            return("Error fetching data from context: \(error)")
        }
    }
    
    func readFish() -> [CaughtFish] {
        
        let request : NSFetchRequest <CaughtFish> = CaughtFish.fetchRequest()
        do {
            fishArray = try context!.fetch(request) //this is failing to unwrap, causing a fatal error.
            if coreDataDebug { print("count of records read = \(fishArray.count)") }
        } catch {
            if coreDataDebug { print("Error fetching data from context: \(error)") }
        }
        
        return fishArray
        
    }
    
}
