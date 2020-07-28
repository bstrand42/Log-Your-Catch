//
//  RegisterViewController.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 7/27/20.
//  Copyright © 2020 Rajan Maheshwari. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailField1: UITextField!
    @IBOutlet weak var emailField2: UITextField!
    @IBOutlet weak var passwordField1: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    @IBOutlet weak var emailMarker: UIImageView!
    @IBOutlet weak var passwordMarker: UIImageView!
    
    @IBAction func textFieldEditingEnded(_ sender: UITextField) {
        
        checkUserInput()
        
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        checkUserInput()
        //execute code to register as a new user using emailField1 and passwordField1
        
    }
    
    @IBAction func returnToLoginButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func checkUserInput() {
        
        if emailField1.text != emailField2.text {
            emailMarker.alpha = 1
        } else if passwordField1.text != passwordField2.text {
            passwordMarker.alpha = 1
        } else {
            passwordMarker.alpha = 0
            emailMarker.alpha = 0
        }
        
    }
    
}
