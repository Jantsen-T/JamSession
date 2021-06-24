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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confrimPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func validateFields() -> String? {
        //Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "\(presentErrorToUser(localizedError: "Please fill in all fields"))"
        }
        //check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Password.isPasswordValid(cleanedPassword) == false {
            // Password isnt secure enough
            return "\(presentErrorToUser(localizedError: " Please make sure password has at least 8 characters, contains a special character and a number."))"
        }
        return nil
    }
    
    
    @IBAction func createButtonTapped(_ sender: Any) {
        
        if confrimPasswordTextField.text == passwordTextField.text {
            
            let error = validateFields()
            if let error = error {
                // there is something wrong with the fields, show error message
                presentErrorToUser(localizedError: error)
            }
            else {
                //create cleaned version of the data (strip out all white spaces from the fields) so we don't save white spaces and new lines in our database.
                let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let confirmPassword = confrimPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                UserController.sharedInstance.dbContainsUsername(username: username) { validate in
                    if validate == false{
                        UserController.sharedInstance.authUser(email: email, password: password, username: username){
                            self.showToast(message: "i logged u in")
                        }
                    }else{
                        self.presentErrorToUser(localizedError: "Username Taken")
                    }
                }
            }

        }
        else if confrimPasswordTextField.text == "" {
            guard let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), !(email.isEmpty),
                  let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), !(password.isEmpty) else {return}
            LoginController.sharedInstance.loginUser(email: email, password: password) { result in
                switch result {
                
                case success(_):
                
                case failure(_):
                print("error")
                
                }
            }
                  
    
        }
        else {
            presentErrorToUser(localizedError: "passwords must match")
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        toggleToSignUp()
    
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        toggleLogin()
    }
    
    func toggleLogin() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.confrimPasswordTextField.alpha = 0
                self.confrimPasswordTextField.isHidden = true
                self.signUpButton.setTitleColor(.gray, for: .normal)
                self.loginButton.setTitleColor(.blue, for: .normal)
                self.createButton.setTitle("Log In", for: .normal)
            }
        }
    }
    
    func toggleToSignUp() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.confrimPasswordTextField.alpha = 1
                self.confrimPasswordTextField.isHidden = false
                self.signUpButton.setTitleColor(.gray, for: .normal)
                self.loginButton.setTitleColor(.blue, for: .normal)
                self.createButton.setTitle("Create Account", for: .normal)
                
            }
        }
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
