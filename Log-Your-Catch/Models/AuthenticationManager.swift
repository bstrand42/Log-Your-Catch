//
//  AuthenticationManager.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 8/5/20.
//  Copyright © 2020 Strand. All rights reserved.
//

import UIKit
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
}

