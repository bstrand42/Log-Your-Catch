//
//  RegisterViewController.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 7/27/20.
//  Copyright © 2020-2021 Strand. All rights reserved.
//

import UIKit
import Firebase

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
       
        emailField1.delegate = self
        emailField2.delegate = self
        passwordField1.delegate = self
        passwordField2.delegate = self
        
        if registerDebug { print("registerViewController page loaded") }
        
        if let user = defaults.string(forKey: K.CoreDataCredentials.userKey), let password = defaults.string(forKey: K.CoreDataCredentials.passwordKey) {
            if coreDataDebug || registerDebug { print("retrieved user = \(user), password = \(password) h") }
        } else {
            if coreDataDebug || registerDebug { print("no valid credentials found") }
            return
        }
        
    }
    
    // toggle whether we're to save the user's credentials...defaults to true
    @IBAction func rememberMeButton(_ sender: Any) {
        saveCredentials = !saveCredentials
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if registerDebug { print("registerButtonPressed") }
        
        let checked = checkUserInput()
        //execute code to register as a new user using emailField1 and passwordField1
        
        if registerDebug {
            print("email = \(String(describing: self.emailField2.text))")
            print("password = \(String(describing: self.passwordField2.text))")
        }
        
        if saveCredentials == true {
            // TODO: handle the case where either string is nil
            defaults.set(self.emailField1.text, forKey: K.CoreDataCredentials.userKey)
            defaults.set(self.passwordField1.text, forKey: K.CoreDataCredentials.passwordKey)
            if coreDataDebug { print("saved user credentials") }
        } else {
            print("set user credentials to empty strings")
            defaults.set("", forKey: K.CoreDataCredentials.userKey)
            defaults.set("", forKey: K.CoreDataCredentials.passwordKey)
        }
        
        if checked == true {
            if let email = emailField2.text, let password = passwordField2.text {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        self.performSegue(withIdentifier: K.Segue.goBackToMain , sender: self)
                    }
                }
            }
        } else {
            if registerDebug { print("don't match") }
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
    
    // TODO change this to select next textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField1:
            return true
        case emailField2:
            return checkUserInput()
        case passwordField1:
            return true
        case passwordField2:
            return checkUserInput()
        default:
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(textField) ended editing")
    }
}
