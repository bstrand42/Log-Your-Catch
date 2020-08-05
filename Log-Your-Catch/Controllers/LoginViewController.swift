//
//  LoginViewController.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 7/27/20.
//  Copyright © 2020 Strand. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Global Variables
    
    var saveCredentials = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.delegate = self
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func saveCredentialSwitch(_ sender: Any) {
        saveCredentials = !saveCredentials
        print("saveCredentials is now \(saveCredentials)")
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        //execute login code using emailField and passwordField
        
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
