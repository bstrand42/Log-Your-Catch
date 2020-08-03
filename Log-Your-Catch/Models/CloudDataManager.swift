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
    
    func uploadToCloud(arr: [CaughtFish], saveFunc: () -> Void) {
        
        var count = arr.count
        
        print("uploadToCloud called: record count = \(arr.count)")
        
        while (count > 0) {
            print("fish length \(arr[count-1].length) being removed")
            context!.delete(arr[count-1])
            saveFunc()
            count = count - 1
        }
        
    }
    
}
