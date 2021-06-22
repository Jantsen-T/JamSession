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
            UserController.sharedInstance.dbContainsUsername(username: username) { val in
                if val == false{
                    UserController.sharedInstance.authUser(email: email, password: password, username: username){
                        self.showToast(message: "i logged u in")
                    }
                }else{
                    self.presentErrorToUser(localizedError: "Username Taken")
                }
            }
            
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
