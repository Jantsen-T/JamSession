//
//  ChatsController.swift
//  BlamConfession
//
//  Created by Gavin Craft on 6/22/21.
//

import Foundation
import FirebaseFirestore
class ChatsController{
    static let sharedInstance = ChatsController()
    var chats: [Chat] = []{
        didSet{
            MessageTableController.sharedInstance?.tableView.reloadData()
        }
    }
    init(){
        self.getNumberofChats()
    }
    func createNewChatWith(user: User) {
        guard let cu = UserController.sharedInstance.currentUser else { return}
        let users = [cu.uuid, user.uuid]
        let data: [String: Any] = [
            "users":users
        ]
        let db = Firestore.firestore().collection("Chats")
        db.addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                print("yes?")
            }
        }
    }
    func getNumberofChats(){
//        self.chats = []
        guard let user = UserController.sharedInstance.currentUser else { return}
        let db = Firestore.firestore().collection("Chats").whereField("users", arrayContains: user.uuid)
        db.getDocuments{ (chatQuerySnap, error) in
            if let error = error{
                print(error)
                return
            }
            for doc in chatQuerySnap!.documents{
                let chat = Chat(dictionary: doc.data())
                if let chat = chat{
                    self.chats.append(chat)
                }
            }
            MessageTableController.sharedInstance?.tableView.reloadData()
        }
        
    }
    func deleteChatsBetween(user1: User, user2: User){
        let db = Firestore.firestore().collection("Chats").whereField("users", arrayContains: user1.uuid)
                                                          
        db.getDocuments { snap, error in
            if let err = error{
                print(err)
            }
            guard let snap = snap else { return}
            if snap.documents.count > 0{
                for i in snap.documents.indices{
                    let name = snap.documents[i].documentID
                    guard let t = Chat(dictionary: snap.documents[i].data()) else {continue}
                    guard(t.users.contains(user2.uuid))else{continue}
                    let chatDoc = Firestore.firestore().collection("Chats").document(name)
                    chatDoc.delete()
                }
            }
        }
    }
}
