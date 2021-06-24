//
//  MenTableViewController.swift
//  BlamConfession
//
//  Created by Gavin Craft on 6/22/21.
//

import UIKit

class MenTableViewController: UITableViewController {
    static var sharedInstance: MenTableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        MenTableViewController.sharedInstance = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
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
                case .failure(let err):
                    print(err)
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
                    let vc = sb.instantiateViewController(identifier: "ppchat") as! ChatViewController
                    vc.targetUser = otherGuy[0]
                    vc.modalPresentationStyle = .fullScreen
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                case .failure(let err):
                    print(err)
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
                case .failure(let err):
                    print(err)
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
                case .failure(let err):
                    print(err)
                }
                
            }
        }else if index==0{
            UserController.sharedInstance.grabUserFromUuid(uuid: chat.users[1]) { r in
                switch r{
                case .success(let u):
                    cell.nameLabel.text = u.username
                    cell.pfpView.image = u.profilePic
                case .failure(let err):
                    print(err)
                }
                
            }
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
