//
//  SignUpViewController.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/15/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    static var successfulUUID: String?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        kyboardDissapear()
        toggleTologin()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
       
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
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        toggleToSignUp()
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        toggleTologin()
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        
    
        
        if confirmPasswordTextField.text == passwordTextField.text {
            
            let error = validateFields()
            if let error = error {
                // there is something wrong with the fields, show error message
                //showError(error)
                presentErrorToUser(localizedError: error)
            }
            else {
                
                //create cleaned version of the data (strip out all white spaces from the fields) so we don't save white spaces and new lines in our database.
                let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                UserController.sharedInstance.createAuthUser(email: email, password: password){ uid in
                    self.showToast(message: "create successful")
                    SignUpViewController.successfulUUID = uid
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(identifier: "createUser")
                    vc.modalPresentationStyle = .fullScreen
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                }
            }
        }
        
        else if confirmPasswordTextField.text == "" {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            LoginController.sharedInstance.loginUser(email: email, password: password) { result in
                switch result {
                case .success(let userUuid):
                    UserController.sharedInstance.grabUserFromUuid(uuid: userUuid) { result in
                        switch result {
                        
                        case .success(let user):
                            UserController.sharedInstance.currentUser = user
                            let sb = UIStoryboard(name: "borp", bundle: nil)
                            let vc = sb.instantiateViewController(identifier: "tabbar")
                            vc.modalPresentationStyle = .fullScreen
                            //vc.modalTransitionStyle = .partialCurl
                            self.present(vc, animated: true, completion: nil)
                        case .failure(let error):
                            self.presentErrorToUser(localizedError: error)
                        }
                    }
                case .failure(let error):
                    print ("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        else {
            presentErrorToUser(localizedError: "passwords must match")
        }
    }
    
    func toggleTologin() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.confirmPasswordTextField.alpha = 0
                self.confirmPasswordTextField.isHidden = true
                self.signUpButton.setTitleColor(.gray, for: .normal)
                self.loginButton.setTitleColor(.blue, for: .normal)
                self.createButton.setTitle("Log In", for: .normal)
            }
        }
    }
    
    func toggleToSignUp() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.confirmPasswordTextField.alpha = 1
                self.confirmPasswordTextField.isHidden = false
                self.signUpButton.setTitleColor(.blue, for: .normal)
                self.loginButton.setTitleColor(.gray, for: .normal)
                self.createButton.setTitle("Create Account", for: .normal)
            }
        }
    }
    
    func kyboardDissapear() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
}// End of class

