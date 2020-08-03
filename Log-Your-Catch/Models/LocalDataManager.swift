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
        format.dateFormat = "yyyy-MM-dd HH:mm"
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
            print("Error saving context: \(error)")
        }
    }
    
    func readFish() -> String {
        
        let request : NSFetchRequest <CaughtFish> = CaughtFish.fetchRequest()
        do {
            fishArray = try context!.fetch(request)
            print("count of records read = \(fishArray.count)")
            return "Local records stored: \(fishArray.count)"
        } catch {
            print("Error fetching data from context: \(error)")
            return("Error fetching data from context: \(error)")
        }
    }
    
}
