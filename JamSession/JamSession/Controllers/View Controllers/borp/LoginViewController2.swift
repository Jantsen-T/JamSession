//
//  LoginViewController.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/21/21.
//

import UIKit

class LoginViewController2: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        
        LoginController.sharedInstance.loginUser(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                
                case .success(let user):
                    UserController.sharedInstance.grabUserFromUuid(uuid: user) { result in
                        switch result{
                        case .success(let user):
                            UserController.sharedInstance.currentUser = user
                            let sb = UIStoryboard(name: "borp", bundle: nil)
                            let vc = sb.instantiateViewController(identifier: "tabbar")
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                        case .failure(let err):
                            DispatchQueue.main.async {
                                self.presentErrorToUser(localizedError: err)
                            }
                        }
                    }
                case .failure(let error):
                    
                    print ("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
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
