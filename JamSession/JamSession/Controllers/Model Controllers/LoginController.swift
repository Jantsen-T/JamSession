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
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, err in
            if let err = err{
                return completion(.failure(.firebaseError(err)))
            }
            guard let result = result else {
                return completion(.failure(.noSuchUser))}
            return completion(.success(result.user.uid))
            
        }
    }
}
