//
//  LoginViewController.swift
//  Log-Your-Catch
//
//  Created by Liam Strand on 7/27/20.
//  Copyright © 2020 Rajan Maheshwari. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        //execute login code using emailField and passwordField
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToRegisterView", sender: self)
        
    }
    

    
}
