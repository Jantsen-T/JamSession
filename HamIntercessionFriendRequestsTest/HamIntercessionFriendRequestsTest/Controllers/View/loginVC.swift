//
//  loginVC.swift
//  HamIntercessionFriendRequestsTest
//
//  Created by Gavin Craft on 6/17/21.
//

import UIKit
class LoginVC: UIViewController, UITextFieldDelegate{
    //MARK: outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    //MARK: vdl
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passField.delegate = self
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
              let pass = passField.text, !pass.isEmpty else { presentErrorToUser(localizedError: "You did not fill in the fields. DO THAT");return}
        LoginController.shared.loginUser(email: email, password: pass){result in
            switch result{
            case .success(let user):
                UserController.shared.grabUserFromUuid(username: user) { result in
                    switch result{
                    case .success(let user):
                        UserController.shared.currentUser = user
                    case .failure(let err):
                        DispatchQueue.main.async {
                            self.presentErrorToUser(localizedError: err)
                        }
                    }
                }
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "tabby")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
                
            case .failure(let manErr):
                self.presentErrorToUser(localizedError: manErr)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
