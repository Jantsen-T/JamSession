//
//  Friend.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/15/21.
//

import Foundation

class FriendRequest: Equatable{
    static func == (lhs: FriendRequest, rhs: FriendRequest) -> Bool {
        return ((lhs.initialUser)==(rhs.initialUser))&&((lhs.receivingUser)==(rhs.receivingUser))
    }
    
    let initialUser: String
    let receivingUser: String
    init(initialUser: String, receivingUser: String){
        self.initialUser = initialUser
        self.receivingUser = receivingUser
    }
    func toFireObj()->[String: Any]{
        var dir: [String: Any] = [:]
        dir["sendingUser"] = initialUser
        dir["receivingUser"] = receivingUser
        return dir
    }
    static func fromStringAny(_ s: [String: Any])->FriendRequest?{
        guard let receivingUser = s["receivingUser"] as? String,
              let sendingUser = s["sendingUser"] as? String else { return nil}
        return FriendRequest(initialUser: sendingUser, receivingUser: receivingUser)
    }
}
