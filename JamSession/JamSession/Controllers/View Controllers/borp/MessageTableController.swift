//
//  MenTableViewController.swift
//  BlamConfession
//
//  Created by Gavin Craft on 6/22/21.
//

import UIKit

class MessageTableController: UITableViewController {
    static var sharedInstance: MessageTableController?
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageTableController.sharedInstance = self
    }

    @IBAction func plusPressed(_ sender: Any) {
        let vc = UIAlertController(title: "new message", message: nil, preferredStyle: .alert)
        vc.addTextField(configurationHandler: nil)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            guard let text = vc.textFields![0].text, !(text.isEmpty) else { return}
            UserController.sharedInstance.grabUserFromUsername(username: text) { r in
                switch r{
                case .success(let user):
                    print(user.uuid)
                    ChatsController.sharedInstance.createNewChatWith(user: user)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        vc.addAction(action)
        present(vc, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cu = UserController.sharedInstance.currentUser else { return}
        let chat = ChatsController.sharedInstance.chats[indexPath.row]
        let index = chat.users.firstIndex(of: cu.uuid)
        var otherGuy: [User] = []
        if index==1{
            UserController.sharedInstance.grabUserFromUuid(uuid: chat.users[0]) { r in
                switch r{
                case .success(let user):
                    otherGuy = [user]
                    let sb = UIStoryboard(name: "borp", bundle: nil)
                    let vc = sb.instantiateViewController(identifier: "chatVC") as! ChatViewController
                    vc.targetUser = otherGuy[0]
                    vc.modalPresentationStyle = .fullScreen
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                }
                
            }
        }else if index==0{
            UserController.sharedInstance.grabUserFromUuid(uuid: chat.users[1]) { r in
                switch r{
                case .success(let user):
                    otherGuy = [user]
                    let sb = UIStoryboard(name: "borp", bundle: nil)
                    let vc = sb.instantiateViewController(identifier: "chatVC") as! ChatViewController
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.targetUser = otherGuy[0]
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ChatsController.sharedInstance.chats.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell,
              let cu = UserController.sharedInstance.currentUser else {
            
            return UITableViewCell()}
        let chat = ChatsController.sharedInstance.chats[indexPath.row]
        let index = chat.users.firstIndex(of: cu.uuid)
        
        if index==1{
            UserController.sharedInstance.grabUserFromUuid(uuid: chat.users[0]) { r in
                switch r{
                case .success(let u):
                    cell.nameLabel.text = u.username
                    cell.pfpView.image = u.profilePic
                case .failure(let error):
                    print(error)
                }
                
            }
        }else if index==0{
            UserController.sharedInstance.grabUserFromUuid(uuid: chat.users[1]) { r in
                switch r{
                case .success(let u):
                    cell.nameLabel.text = u.username
                    cell.pfpView.image = u.profilePic
                case .failure(let error):
                    print(error)
                }
                
            }
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
