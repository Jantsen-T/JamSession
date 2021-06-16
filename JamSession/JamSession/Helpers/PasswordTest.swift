//
//  PasswordTest.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/15/21.
//

import Foundation

class Password {
    
    let sharedInstance = Password()
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
