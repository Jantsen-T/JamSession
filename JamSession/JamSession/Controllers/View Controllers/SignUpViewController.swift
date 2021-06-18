//
//  SignUpViewController.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/15/21.
//

import UIKit
import FirebaseAuth
import Firebase


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var instrumentTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func validateFields() -> String? {
        //Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        //check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Password.isPasswordValid(cleanedPassword) == false {
            // Password isnt secure enough
            return " Please make sure password has at least 8 characters, contains a special character and a number."
        }
        return nil
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        let error = validateFields()
        if let error = error {
            // there is something wrong with the fields, show error message
        }
        else {
            //create cleaned version of the data (strip out all white spaces from the fields) so we don't save white spaces and new lines in our database.
            let username = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let location = locationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let instrument = instrumentTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let bio = bioTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            

        }
    }
    
    
