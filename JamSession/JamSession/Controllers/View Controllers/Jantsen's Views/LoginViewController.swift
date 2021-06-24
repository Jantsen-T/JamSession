//
//  LoginViewController.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/21/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
<<<<<<< HEAD:JamSession/JamSession/Controllers/View Controllers/Jantsen's Views/LoginViewController.swift
//    @IBAction func logInButtonTapped(_ sender: Any) {
//
//        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
//              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
//
//        LoginController.sharedInstance.loginUser(email: email, password: password) { result in
//            DispatchQueue.main.async {
//                switch result {
//
//                case .success(_):
//
//                case .failure(let error):
//
//                    print ("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                }
//            }
//        }
//    }
=======
    @IBAction func logInButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        
        LoginController.sharedInstance.loginUser(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                
                case .success(_):
                    print("pp")
                case .failure(let error):
                    
                    print ("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
>>>>>>> 6a9910b788549251d43f075d4ee22f47dffed6fb:JamSession/JamSession/Controllers/View Controllers/LoginViewController.swift
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
