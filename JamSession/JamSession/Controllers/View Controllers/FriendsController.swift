//
//  FriendsController.swift
//  HamIntercessionFriendRequestsTest
//
//  Created by Gavin Craft on 6/17/21.
//

import UIKit
class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //MARK: outlets
    @IBOutlet weak var tableVieww: UITableView!
    @IBOutlet weak var usernameField: UITextField!
    static var shared: FriendViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVieww.delegate = self
        tableVieww.dataSource = self
        FriendViewController.shared = self
    }
    @IBAction func addUserButtonPressed(_ sender: Any) {
        guard let current = UserController.sharedInstance.currentUser else {
            
            return}
        guard let un = usernameField.text, !un.isEmpty else {
            return}
        UserController.sharedInstance.dbContainsUsername(username: un) { val in
            if val==false{
                DispatchQueue.main.async {
                    self.presentErrorToUser(localizedError: "User does not exist")
                }
            }else{
                UserController.sharedInstance.grabUserFromUsername(username: un) { result in
                    switch result{
                    case .success(let user):
                        UserController.sharedInstance.sendFriendRequest(originatingUser: current, receivingUser: user)
                    case .failure(let err):
                        DispatchQueue.main.async {
                            self.presentErrorToUser(localizedError: err)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: tableview funcs
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section==0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
            if UserController.sharedInstance.currentUser!.friends.indices.contains(indexPath.row){
                cell.textLabel?.text = UserController.sharedInstance.currentUser!.friends[indexPath.row]
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
            guard let user = UserController.sharedInstance.currentUser else { return cell}
            if UserController.sharedInstance.currentUser!.friendRequests.indices.contains(indexPath.row){
                cell.textLabel?.text = user.friendRequests[indexPath.row].initialUser
            }
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==0{
            return "frends"
        }else{return "incoming requests"}
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section==0{
            let unfriendAction = UIContextualAction(style: .normal, title: "unfriend") { action, view, handler in
                print("unfriend")
                let str = self.tableVieww.cellForRow(at: indexPath)?.textLabel?.text
                if let str = str{
                    UserController.sharedInstance.grabUserFromUsername(username: str) { result in
                        switch result{
                        case .success(let user):
                            UserController.sharedInstance.unfriendUser(user: user)
                        case .failure(let err):
                            print("err "+err.localizedDescription)
                        }
                    }
                }
                
            }
            let blockAction = UIContextualAction(style: .destructive, title: "block") { action, view, handler in
                let str = self.tableVieww.cellForRow(at: indexPath)?.textLabel?.text
                if let str = str{
                    UserController.sharedInstance.grabUserFromUsername(username: str) { result in
                        switch result{
                        case .success(let user):
                            UserController.sharedInstance.blockUser(user: user)
                        case .failure(let err):
                            print("err "+err.localizedDescription)
                        }
                    }
                }
            }
            return UISwipeActionsConfiguration(actions: [unfriendAction, blockAction])
        }else{
            let unfriendAction = UIContextualAction(style: .normal, title: "ignore") { action, view, handler in
                let str = self.tableVieww.cellForRow(at: indexPath)?.textLabel?.text
                if let str = str{
                    UserController.sharedInstance.grabUserFromUuid(uuid: str) { result in
                        switch result{
                        case .success(let user):
                            guard let cu = UserController.sharedInstance.currentUser else { return}
                            UserController.sharedInstance.ignoreFriendRequest(origin: user, catcher: cu)
                        case .failure(let err):
                            print("err "+err.localizedDescription)
                        }
                    }
                }
            }
            let blockAction = UIContextualAction(style: .destructive, title: "block") { action, view, handler in
                let str = self.tableVieww.cellForRow(at: indexPath)?.textLabel?.text
                if let str = str{
                    UserController.sharedInstance.grabUserFromUuid(uuid: str) { result in
                        switch result{
                        case .success(let user):
                            UserController.sharedInstance.unfriendUser(user: user)
                        case .failure(let err):
                            print("err "+err.localizedDescription)
                        }
                    }
                }
            }
            return UISwipeActionsConfiguration(actions: [unfriendAction, blockAction])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addFwen(ir: indexPath.row, section: indexPath.section)
    }
    func addFwen(ir: Int, section: Int){
        var un = ""
        print(section)
        if section==1{
            un = UserController.sharedInstance.currentUser!.friendRequests[ir].initialUser
        }else{
            return
        }
        UserController.sharedInstance.grabUserFromUuid(uuid: un) { res in
            switch res{
            case .success(let userr):
                UserController.sharedInstance.acceptFriendRequest(originatingUser: userr, receivingUser: UserController.sharedInstance.currentUser!)
                DispatchQueue.main.async {
                    self.tableVieww.reloadData()
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self.presentErrorToUser(localizedError: err)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = UserController.sharedInstance.currentUser else {
            
            return 0 }
        if section==0{
            return user.friends.count
        }else{
            return user.friendRequests.count
        }
    }
}
