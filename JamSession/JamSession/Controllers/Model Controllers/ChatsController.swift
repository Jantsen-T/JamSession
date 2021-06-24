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
            MenTableViewController.sharedInstance?.tableView.reloadData()
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
        }
    }
    
}
