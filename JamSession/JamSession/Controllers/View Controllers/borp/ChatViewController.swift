//
//  ChatViewController.swift
//  JamSession
//
//  Created by Gavin Craft on 6/21/21.
//

import UIKit
import Firebase
import MessageKit

class ChatViewController: UIViewController {
    //MARK: things relating to this self
    private var docReference: DocumentReference?
    var messages: [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadChats(){
        let db = Firestore.firestore().collection("Chats").whereField("users", arrayContains: UserController.sharedInstance.currentUser?.uuid ?? "Not Found self")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
