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
}
