//
//  CloudDataManager.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 8/3/20.
//  Copyright © 2020 Strand. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class CloudDataManager {
    
    let db = Firestore.firestore()
    
    var context: NSManagedObjectContext?
    
    let authenticationManager = AuthenticationManager()
    let localDataManager = LocalDataManager()
    
    func uploadToCloud(array: [CaughtFish], saveFunc: @escaping() -> Void, completion: @escaping(_ shouldSegue: Bool) -> Void) {
        
        if authenticationManager.checkLoginInput() {
            
            performUpload()
            clearLocalData(array, saveFunc)
            if attemptToUploadCasesDebug { print("already logged in") }
            completion(false)
            
        } else {
            let user = defaults.string(forKey: "User") ?? ""
            let password = defaults.string(forKey: "Password") ?? ""
            if user != "" && password != "" {
                
                if coreDataDebug || firestoreDebug {
                    print("user is \(String(describing: user))")
                    print("password is \(String(describing: password))")
                }
                
                authenticationManager.attemptLogin(user, password) { (success) in
                    if success {
                        if attemptToUploadCasesDebug { print("logged in from local data") }
                        self.performUpload()
                        self.clearLocalData(array, saveFunc)
                        completion(false)
                    } else {
                        if attemptToUploadCasesDebug { print("error logging in") }
                        completion(true)
                    }
                }
            } else {
                if attemptToUploadCasesDebug { print("no info in local storage") }
                completion(true)
            }
        }
        
    }
    
    
    
    func performUpload() {
        
        let fishArray: [CaughtFish] = localDataManager.readFish()
        
        if let logger = Auth.auth().currentUser?.email {
            
            for fish in fishArray {
                
                db.collection(K.FStore.collectionName).addDocument(data: [
                    K.FStore.fishTypeField: fish.species ?? "",
                    K.FStore.lengthField: fish.length,
                    K.FStore.releasedField: fish.released,
                    K.FStore.latitudeField: fish.latitude,
                    K.FStore.longitudeField: fish.longitude,
                    K.FStore.loggerField: logger,
                    K.FStore.dateField: fish.date ?? ""
                    
                ])
            }
        } else {
            if firestoreDebug { print("couldn't find user, so no upload") }
        }
    }
    
    func clearLocalData(_ array: [CaughtFish], _ saveFunc: () -> Void) {
        
        var count = array.count
        
        if coreDataDebug || firestoreDebug { print("clearLocalData called: record count = \(array.count)") }
        
        while (count > 0) {
            if coreDataDebug { print("fish length \(array[count-1].length) being removed") }
            context!.delete(array[count-1])
            saveFunc()
            count = count - 1
        }
        
    }
    
}
