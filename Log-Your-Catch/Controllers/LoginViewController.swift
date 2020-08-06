//
//  LoginViewController.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 7/27/20.
//  Copyright © 2020 Strand. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: - Global Variables
    
    var saveCredentials = true
    let authenticationManager = AuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("about to set delegate")
        passwordField.delegate = self
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func saveCredentialSwitch(_ sender: Any) {
        saveCredentials = !saveCredentials
        print("saveCredentials is now \(saveCredentials)")
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = emailField.text, let password = passwordField.text {
            
            authenticationManager.attemptLogin(email, password) { (shouldSegue) in
                self.dismiss(animated: true, completion: nil)
            }
            
        } else {
            if ViewController.debugPrint { print("something's wrong with mailField and passwordField") }
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToRegisterView", sender: self)
        
    }
    

    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //execute login code and
        
        return true
    }
    
}
