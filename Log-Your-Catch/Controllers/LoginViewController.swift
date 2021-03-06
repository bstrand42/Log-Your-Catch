//
//  LoginViewController.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 7/27/20.
//  Copyright © 2020-2021 Strand. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: - Global Variables
    
    var saveCredentials = true
    let authenticationManager = AuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.delegate = self
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func saveCredentialSwitch(_ sender: Any) {
        saveCredentials = !saveCredentials
        if loginDebug { print("saveCredentials is now \(saveCredentials)") }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            if saveCredentials == true {
                  // TODO: handle the case where either string is nil
                  defaults.set(self.emailField.text, forKey: K.CoreDataCredentials.userKey)
                  defaults.set(self.passwordField.text, forKey: K.CoreDataCredentials.passwordKey)
                  if loginDebug { print("saved user credentials") }
              } else {
                if loginDebug { print("set user credentials to empty strings") }
                  defaults.set("", forKey: K.CoreDataCredentials.userKey)
                  defaults.set("", forKey: K.CoreDataCredentials.passwordKey)
              }
            authenticationManager.attemptLogin(email, password) { (shouldSegue) in
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            if loginDebug { print("something's wrong with mailField and passwordField") }
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.Segue.goToRegisterView, sender: self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let email = emailField.text, let password = passwordField.text {
            authenticationManager.attemptLogin(email, password) { (shouldSegue) in
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            if loginDebug { print("something's wrong with mailField and passwordField") }
            
        }
        return true
    }
}
