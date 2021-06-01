//
//  AuthenticationManager.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 8/5/20.
//  Copyright © 2020-2021 Strand. All rights reserved.
//

import Foundation
import Firebase

struct AuthenticationManager {
    
    func attemptLogin (_ email: String, _ password: String, completion: @escaping(_ success: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func checkLoginInput() -> Bool {
        
        if Auth.auth().currentUser == nil {
            return false
        } else {
            return true
        }
        
    }
    
}

