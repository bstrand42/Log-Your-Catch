//
//  Constants.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 8/6/20.
//  Copyright © 2020 Strand. All rights reserved.
//

import Foundation

//MARK: - Debugging
//set to true to print debug logs
let UIDebug = true
let coreDataDebug = true
let locationDebug = true
let loginDebug = true
let registerDebug = true
let firestoreDebug = true
let attemptToUploadCasesDebug = true

//MARK: - Konstants

struct K {
    
    struct Segue {
        static let goBackToMain = "registerSuccess"
        static let goToRegisterView = "goToRegisterView"
        static let goToLoginView = "goToLoginView"
        static let goToMapView = "goToMapView"
    }
    
    struct CoreDataCredentials {
        static let userKey = "User"
        static let passwordKey = "Password"
    }
    
    struct FishType {
        static let bluefish = "Bluefish"
        static let striper = "Striper"
        static let nilFish = ""
    }
    
    struct FStore {
        static let collectionName = "fishCollection"
        static let collectionTestName = "fishTestCollection"
        static let loggerField = "logger"
        static let latitudeField = "latitude"
        static let longitudeField = "longitude"
        static let lengthField = "length"
        static let fishTypeField = "fishType"
        static let releasedField = "released"
        static let dateField = "date"
    }
    
    static let dateFormat = "yyyy-MM-dd HH:mm"
    
}
