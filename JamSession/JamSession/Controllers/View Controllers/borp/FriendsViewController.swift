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
        guard let current = UserController.shared.currentUser else {
            
            
            return}
        guard let un = usernameField.text, !un.isEmpty else {
            return}
        UserController.shared.dbContainsUsername(username: un) { val in
            if val==false{
                DispatchQueue.main.async {
                    self.presentErrorToUser(localizedError: "User does not exist")
                }
            }else{
                UserController.shared.grabUserFromUsername(username: un) { result in
                    switch result{
                    case .success(let user):
                        UserController.shared.sendFriendRequest(originatingUser: current, receivingUser: user)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
            if UserController.shared.currentUser!.friends.indices.contains(indexPath.row){
                cell.usernameField.text = UserController.shared.currentUser!.friends[indexPath.row]
                UserController.shared.grabUserFromUsername(username: UserController.shared.currentUser!.friends[indexPath.row]){result in
                    switch result{
                    case .success(let user):
                        cell.user = user
                    case .failure(let err):
                        print(err)
                    }
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
            guard let user = UserController.shared.currentUser else { return cell}
            if UserController.shared.currentUser!.friendRequests.indices.contains(indexPath.row){
                cell.usernameField.text = user.friendRequests[indexPath.row].initialUser
                UserController.shared.grabUserFromUsername(username: user.friendRequests[indexPath.row].initialUser){result in
                    switch result{
                    case .success(let user):
                        cell.user = user
                    case .failure(let err):
                        print(err)
                    }
                }
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
                    UserController.shared.grabUserFromUsername(username: str) { result in
                        switch result{
                        case .success(let user):
                            UserController.shared.unfriendUser(user: user)
                        case .failure(let err):
                            print("err "+err.localizedDescription)
                        }
                    }
                }
                
            }
            let blockAction = UIContextualAction(style: .destructive, title: "block") { action, view, handler in
                let str = self.tableVieww.cellForRow(at: indexPath)?.textLabel?.text
                if let str = str{
                    UserController.shared.grabUserFromUsername(username: str) { result in
                        switch result{
                        case .success(let user):
                            UserController.shared.blockUser(user: user)
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
                    UserController.shared.grabUserFromUuid(username: str) { result in
                        switch result{
                        case .success(let user):
                            guard let cu = UserController.shared.currentUser else { return}
                            UserController.shared.ignoreFriendRequest(origin: user, catcher: cu)
                        case .failure(let err):
                            print("err "+err.localizedDescription)
                        }
                    }
                }
            }
            let blockAction = UIContextualAction(style: .destructive, title: "block") { action, view, handler in
                let str = self.tableVieww.cellForRow(at: indexPath)?.textLabel?.text
                if let str = str{
                    UserController.shared.grabUserFromUuid(username: str) { result in
                        switch result{
                        case .success(let user):
                            UserController.shared.unfriendUser(user: user)
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
            un = UserController.shared.currentUser!.friendRequests[ir].initialUser
        }else{
            return
        }
        UserController.shared.grabUserFromUuid(username: un) { res in
            switch res{
            case .success(let userr):
                UserController.shared.acceptFriendRequest(originatingUser: userr, receivingUser: UserController.shared.currentUser!)
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
        guard let user = UserController.shared.currentUser else {
            
            return 0 }
        if section==0{
            return user.friends.count
        }else{
            return user.friendRequests.count
        }
    }
}
