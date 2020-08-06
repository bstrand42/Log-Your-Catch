//
//  CloudDataManager.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 8/3/20.
//  Copyright © 2020 Strand. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class CloudDataManager {
    
    var context: NSManagedObjectContext?
    
    let authenticationManager = AuthenticationManager()
    
    func uploadToCloud(array: [CaughtFish], saveFunc: @escaping() -> Void, completion: @escaping(_ shouldSegue: Bool) -> Void) {
        
        if checkLogin() {
            
            performUpload(array)
            clearLocalData(array, saveFunc)
            print("already logged in")
            completion(false)
            
        } else {
            let user = defaults.string(forKey: "User") ?? ""
            let password = defaults.string(forKey: "Password") ?? ""
            if user != "" && password != "" {
                
                print("user is \(String(describing: user))")
                print("password is \(String(describing: password))")
                authenticationManager.attemptLogin("1@2.com", "poop") { (success) in
                    if success {
                        print("logged in from local data")
                        self.performUpload(array)
                        self.clearLocalData(array, saveFunc)
                        completion(false)
                    } else {
                        print("error logging in")
                        completion(true)
                    }
                }
            } else {
                print("no info in local storage")
                completion(true)
            }
        }
        
    }
    
    func checkLogin() -> Bool {
        
        if Auth.auth().currentUser == nil {
            return false
        } else {
            return true
        }
        
    }
    
    func performUpload(_ array: [CaughtFish]) {
        
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
