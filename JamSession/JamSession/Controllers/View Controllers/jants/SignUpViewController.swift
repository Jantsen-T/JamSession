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
    //MARK: - Outlets
    static var successfulUUID: String?
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        kyboardDissapear()
        toggleTologin()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        // creates the toolbar in the keybaord with the done button
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        emailTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        confirmPasswordTextField.inputAccessoryView = toolBar
        createButton.layer.cornerRadius = 20
        emailTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        confirmPasswordTextField.layer.cornerRadius = 20
        
        
    }
    //MARK: - Functions
    @objc private func didTapDone() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
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
        self.activitySpinner.startAnimating()
        if confirmPasswordTextField.text == passwordTextField.text {
            let error = validateFields()
            if let error = error {
                // there is something wrong with the fields, show error message
                //showError(error)
                DispatchQueue.main.async {
                    self.activitySpinner.stopAnimating()
                    self.presentErrorToUser(localizedError: error)
                }
                
            }
            //create cleaned version of the data (strip out all white spaces from the fields) so we don't save white spaces and new lines in our database.
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            UserController.sharedInstance.createAuthUser(email: email, password: password){ uid in
                self.showToast(message: "create successful")
                SignUpViewController.successfulUUID = uid
                let sb = UIStoryboard(name: "borp", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "createUser")
                vc.modalPresentationStyle = .fullScreen
                DispatchQueue.main.async {
                    self.activitySpinner.stopAnimating()
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        else if confirmPasswordTextField.isHidden {
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
                            DispatchQueue.main.async {
                                self.activitySpinner.stopAnimating()
                                self.present(vc, animated: true, completion: nil)
                            }
                            
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.activitySpinner.stopAnimating()
                                self.presentErrorToUser(localizedError: error)
                            }
                        }
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.activitySpinner.stopAnimating()
                        self.presentErrorToUser(localizedError: "Incorect Email or Password")
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                self.activitySpinner.stopAnimating()
                self.presentErrorToUser(localizedError: "passwords must match")
            }
        }
    }
    // we can change these colors
    func toggleTologin() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.confirmPasswordTextField.alpha = 0
                self.confirmPasswordTextField.isHidden = true
                self.signUpButton.setTitleColor(.gray, for: .normal)
                self.loginButton.setTitleColor(Colors.blue, for: .normal)
                self.createButton.setTitle("Log In", for: .normal)
            }
        }
    }
    // we an change these colors
    func toggleToSignUp() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.confirmPasswordTextField.alpha = 1
                self.confirmPasswordTextField.isHidden = false
                self.signUpButton.setTitleColor(Colors.blue, for: .normal)
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

