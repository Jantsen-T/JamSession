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
            showError(error)
        }
        else {
            //create cleaned version of the data (strip out all white spaces from the fields) so we don't save white spaces and new lines in our database.
            let username = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let location = locationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let instrument = instrumentTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let bio = bioTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
<<<<<<< HEAD
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print ("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    self.showError("Error creating user")
                }
                else {
                    //User created successfully
                    
                    let db = Firestore.firestore()
                    db.collection("Users").document(result!.user.uid).setData(["Firstname" : firstName, "Location" : location, "Instrument" : instrument, "Bio" : bio, "uid" : result!.user.uid]) { error in
                        if error != nil {
                            self.showError("error saving user data")
                        }
                    }
                    //transition to home screen in the UI after the user was created succssfully
                    self.transitionToHome()
                }
=======
            UserController.sharedInstance.authUser(email: email, password: password, username: username){
                self.showToast(message: "i logged u in")
>>>>>>> a1b877dca6df3868ec45e0caa5f379d494fcd38e
            }
        }
    }
    
    
