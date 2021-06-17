//
//  User.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/15/21.
//
import UIKit

class User: Equatable{
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    let username: String
    let profilePic: UIImage
    let uuid: String
    var friends: [String] = []
    let location: String
    let bio: String?
    let instrument: String
    var friendRequests: [FriendRequest] = [] {
        willSet{
            if newValue.count > friendRequests.count{
                print("adding a request")
            }else{
                print("i hope you accepted bc otherwise theres a problem")
            }
        }
    }
    let experienceLevel: String
    
    init(username: String, profilePic: UIImage, location: String, bio: String, instrument: String, experienceLevel: String, UUID: String = UUID().uuidString, friends: [String] = []){
        self.username = username
        self.profilePic = profilePic
        self.location = location
        self.bio = bio
        self.instrument = instrument
        self.experienceLevel = experienceLevel
        uuid = UUID
        self.friends = friends
    }
    func toFireObj()->[String: Any]{
        var dict: [String: Any] = [:]
        dict["username"] = self.username
        dict["profilePic"] = self.profilePic.jpegData(compressionQuality:0.5)
        dict["location"] = self.location
        dict["bio"] = self.bio
        dict["uuid"] = self.uuid
        dict["instrument"] = self.instrument
        dict["friends"] = self.friends
        dict["experienceLevel"] = self.experienceLevel
        return dict
    }
}// End of class

extension User{
    static func fromStringAny(_ s: [String: Any])->User?{
        guard let bio = s["bio"] as? String,
              let experienceLevel = s["experienceLevel"] as? String,
              let friendsy = s["friends"] as? [String],
              let profilePic = s["profilePic"] as? Data,
              let instrument = s["instrument"] as? String,
              let location = s["location"] as? String,
              let username = s["username"] as? String,
              let uuid = s["uuid"] as? String else { return nil        }
        guard let pfp = UIImage(data: profilePic) else { return nil}
        return User(username: username, profilePic: pfp, location: location, bio: bio, instrument: instrument, experienceLevel: experienceLevel, UUID: uuid, friends: friendsy)
    }
}
