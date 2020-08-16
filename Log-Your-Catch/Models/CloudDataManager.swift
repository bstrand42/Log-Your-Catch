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
            if attemptToUploadCasesDebug { print("already logged in") }
            performUpload()
            // TODO:  I think we should consider making this optional
            clearLocalData(array, saveFunc)
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
                        // TODO: I think we should consider making this optional
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
        
        var count = 0
        
        // TODO: this was put here to test getRecordsFromCloud() without UI changes
        //getRecordsFromCloud()
        
        // TODO: perhaps this is causing an unnecessary call/read to Firestore?
        // If we are already logged in, we know who the user is...no need to ask Firestore
        
        if let logger = Auth.auth().currentUser?.email {
            
            for fish in fishArray {
                count += 1
                db.collection(K.FStore.collectionName).addDocument(data: [
                    K.FStore.fishTypeField: fish.species ?? "",
                    K.FStore.lengthField: fish.length,
                    K.FStore.releasedField: fish.released,
                    K.FStore.latitudeField: fish.latitude,
                    K.FStore.longitudeField: fish.longitude,
                    K.FStore.loggerField: logger,
                    K.FStore.dateField: fish.date ?? ""
                    
                ])
                
                // TODO:  can the addDocument() call ever fail?
                
            }
            // TODO: here's where we would give visual feedback to user that their
            // data had been successfully sent to cloud
            
            // TODO: make these two into Debug prints?
            print("sent \(count) fish records to Firestore")
        } else {
            if firestoreDebug { print("couldn't find user, so no upload") }
        }

    }
 
    
    // Reads the data from Firestore.  This prints to debug log, but could do anything with the data
    func getRecordsFromCloud () {
        
        var count = 0
        var rstring = ""
        
        // This is done asynchronously...
        db.collection(K.FStore.collectionName).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("Error retrieving data from Firestore: \(e)")
                return
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        count += 1
                        let data = doc.data()
                        
                        if let logger = data[K.FStore.loggerField],
                            let date = data[K.FStore.dateField],
                            let length = data[K.FStore.lengthField],
                            let released = data[K.FStore.releasedField] as? Bool,  // otherwise just returns 0 or 1
                            let species = data[K.FStore.fishTypeField],
                            let latitude = data[K.FStore.latitudeField],
                            let longitude = data[K.FStore.longitudeField]  {
                            
                            //print("released = \(released)")
                            
                            if (released == true) {
                                rstring = "released"
                            } else {
                                rstring = "kept"
                            }
 
                            // print to debug log in CSV format
                            print("\(date),\(logger),\(rstring),\(length),\(species),\(latitude),\(longitude)")
                            
                        } // end if
                    }  // end for doc
                } // end if let
            } // end else
        }  // end getDocuments
    } // end func
    
    
    
    func clearLocalData(_ array: [CaughtFish], _ saveFunc: () -> Void) {
        
        var count = array.count
        
        // TODO:  Suggest a switch to make this optional
        
        if coreDataDebug || firestoreDebug { print("clearLocalData called: record count = \(array.count)") }
        
        while (count > 0) {
            if coreDataDebug { print("fish length \(array[count-1].length) being removed") }
            context!.delete(array[count-1])
            saveFunc()
            count = count - 1
        }
        
    }
    
}
