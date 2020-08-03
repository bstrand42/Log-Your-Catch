//
//  RegisterViewController.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 7/27/20.
//  Copyright © 2020 Rajan Maheshwari. All rights reserved.
//

import UIKit

// use user defaults to store (key,value) pairs
let defaults = UserDefaults.standard

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailField1: UITextField!
    @IBOutlet weak var emailField2: UITextField!
    @IBOutlet weak var passwordField1: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    @IBOutlet weak var emailMarker: UIImageView!
    @IBOutlet weak var passwordMarker: UIImageView!
    
    var saveCredentials = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        emailField2.delegate = self
        passwordField2.delegate = self
        
        print("registerViewController page loaded")
        
        if let user = defaults.string(forKey: "User") {
            print("retrieved user = \(user)")
        } else {
            print("no username credentials found")
        }
        
        if let password = defaults.string(forKey: "Password") {
            print("retrieved user = \(password)")
        } else {
            print("no user password credentials found")
        }
        
    }
    
    // toggle whether we're to save the user's credentials...defaults to true
    @IBAction func rememberMeButton(_ sender: Any) {
        saveCredentials = !saveCredentials
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        print("registerButtonPressed")
        _ = checkUserInput()
        //execute code to register as a new user using emailField1 and passwordField1
        
        print("email = \(String(describing: self.emailField1.text))")
        print("password = \(String(describing: self.passwordField1.text))")
        
        if saveCredentials == true {
            print("would save user credentials here")
            // TODO: handle the case where either string is nil
            defaults.set(self.emailField1.text, forKey: "User")
            defaults.set(self.passwordField1.text, forKey: "Password")
            print("saved user credentials")
        }

    }
    
    @IBAction func returnToLoginButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func checkUserInput() -> Bool {
        
        if emailField1.text != emailField2.text {
            emailMarker.alpha = 1
            return false
        } else if passwordField1.text != passwordField2.text {
            passwordMarker.alpha = 1
            return false
        } else {
            passwordMarker.alpha = 0
            emailMarker.alpha = 0
            return true
        }
        
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return checkUserInput()
    }
    
}
