//
//  ChatViewController.swift
//  JamSession
//
//  Created by Gavin Craft on 6/21/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    //MARK: things relating to this self
    var currentUser = UserController.sharedInstance.currentUser!
    private var docReference: DocumentReference?
    var messages: [Message] = []
    var targetUser: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        //When use press send button this method is called.
        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.uuid, senderName: currentUser.username)
        //calling function to insert and save message
        insertNewMessage(message)
        save(message)
        //clearing input field
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        // messagesCollectionView.scrollToBottom(animated: true)
    }
    private func insertNewMessage(_ message: Message) {
        //add the message to the messages array and reload it
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    func currentSender() -> SenderType {
        return ChatUser(senderId: Auth.auth().currentUser!.uid, displayName: (Auth.auth().currentUser?.displayName)!)
        // return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
    }
    //This return the MessageType which we have defined to be text in Messages.swift
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    //Return the total number of messages
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0 {
            print("There are no messages")
            return 0
        } else {
            return messages.count
        }
    }
    
    private func save(_ message: Message) {
        //Preparing the data as per our firestore collection
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        //Writing it to the thread using the saved document reference we saved in load chat function
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        })
    }
        //MARK: chatty functions that i have NO CLUE about
    func createNewChat() {
        guard let targetUser = targetUser else { return}
        let users = [self.currentUser.uuid, targetUser.uuid]
        let data: [String: Any] = [
            "users":users
        ]
        let db = Firestore.firestore().collection("Chats")
        db.addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                self.loadChat()
            }
        }
    }
    func loadChat() {
        //Fetch all the chats which has current user in it
        guard let targetUser = targetUser else { return}
        let db = Firestore.firestore().collection("Chats").whereField("users", arrayContains: currentUser.uuid)
        db.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                if queryCount == 0 {
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    self.createNewChat()
                }
                else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        let chat = Chat(dictionary: doc.data())
                        //Get the chat which has user2 id
                        if (chat?.users.contains(targetUser.uuid)) == true {
                            self.docReference = doc.reference
                            //fetch it's thread collection
                            doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                                    if let error = error {
                                        print("Error: \(error)")
                                        return
                                    } else {
                                        self.messages.removeAll()
                                        for message in threadQuery!.documents {
                                            let msg = Message(dictionary: message.data())
                                            self.messages.append(msg!)
                                            print("Data: \(msg?.content ?? "No message found")")
                                        }
                                        //We'll edit viewDidload below which will solve the error
                                        self.messagesCollectionView.reloadData()
                                        self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                                    }
                                })
                            return
                        } //end of if
                    } //end of for
                    self.createNewChat()
                } else {
                    print("if you see this, i am a literal failure - borp")
                }}}}
}
