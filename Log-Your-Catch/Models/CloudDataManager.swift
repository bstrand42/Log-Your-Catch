//
//  CloudDataManager.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 8/3/20.
//  Copyright © 2020 Strand. All rights reserved.
//

import Foundation
import CoreData

class CloudDataManager {
    
    var context: NSManagedObjectContext?
    
    func uploadToCloud(array: [CaughtFish], saveFunc: () -> Void) {
       
        checkLogin()
        //add functionality to upload to cloud
        clearLocalData(array, saveFunc)
        
    }
    
    func checkLogin() {
        //check login and perform segue if necessary to go to loginView
    }
    
    func clearLocalData(_ array: [CaughtFish], _ saveFunc: () -> Void) {
        
        var count = array.count
        
        print("clearLocalData called: record count = \(array.count)")
        
        while (count > 0) {
            print("fish length \(array[count-1].length) being removed")
            context!.delete(array[count-1])
            saveFunc()
            count = count - 1
        }
        
    }
    
}
