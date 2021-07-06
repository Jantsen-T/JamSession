//
//  LoginController.swift
//  HamIntercessionFriendRequestsTest
//
//  Created by Gavin Craft on 6/17/21.
//

import Foundation
import Firebase
class LoginController{
    static let sharedInstance = LoginController()
    
    func loginUser(email: String, password: String, completion: @escaping(Result<String, ManErr>)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                return completion(.failure(.firebaseError(error)))
            }
            guard let result = result else {
                return completion(.failure(.noSuchUser))}
            return completion(.success(result.user.uid))        }
    }
    
    func createUser(email: String, password: String, completion: @escaping(Result<String, ManErr>)-> Void){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print ("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                
            }
            else {
                guard let result = result else { return }
                let uid = result.user.uid
                return completion(.success(uid))
                
            }
        }
    }
        
    
}// End of class

