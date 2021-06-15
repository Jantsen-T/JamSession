//
//  User.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/15/21.
//

import UIKit

class User {
    
    let username: String
    let profilePic: UIImage
    let location: String
    let bio: String?
    let instrument: String
    let experienceLevel: String
    
    init(username: String, profilePic: UIImage, location: String, bio: String, instrument: String, experienceLevel: String){
        self.username = username
        self.profilePic = profilePic
        self.location = location
        self.bio = bio
        self.instrument = instrument
        self.experienceLevel = experienceLevel
    }
}// End of class



