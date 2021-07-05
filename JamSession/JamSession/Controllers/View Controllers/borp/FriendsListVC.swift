
//
//  FriendsController.swift
//  HamIntercessionFriendRequestsTest
//
//  Created by Gavin Craft on 6/17/21.
//

import UIKit
class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    //MARK: outlets
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var usernameField: UITextField!
    static var sharedInstance: FriendViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        friendsTableView.addSubview(refreshControl)
        keyboardDissapear()
        self.usernameField.delegate = self
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        FriendViewController.sharedInstance = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        friendsTableView.reloadData()
    }
    @objc func refresh(_ sender: AnyObject){
        friendsTableView.reloadData()
        sender.endRefreshing()
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
                        DispatchQueue.main.async {
                            self.showToast(message: "Friend Request Sent")
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.presentErrorToUser(localizedError: error)
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
            if UserController.sharedInstance.currentUser!.friends.indices.contains(indexPath.row){
                //cell.usernameLabel.text = UserController.sharedInstance.currentUser!.friends[indexPath.row]
                UserController.sharedInstance.grabUserFromUsername(username: UserController.sharedInstance.currentUser!.friends[indexPath.row]){result in
                    switch result{
                    case .success(let user):
                        cell.user = user
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            cell.sender = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
            guard let cuser = UserController.sharedInstance.currentUser else {
                return cell}
            if UserController.sharedInstance.currentUser!.friendRequests.indices.contains(indexPath.row){
                UserController.sharedInstance.grabUserFromUuid(uuid: cuser.friendRequests[indexPath.row].initialUser){result in
                    switch result{
                    case .success(let user):
                        cell.user = user
                        cell.buttonContainingProfilePic.setImage(user.profilePic, for: .normal)
                        cell.usernameLabel.text = user.username
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            cell.sender = self
            return cell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==0{
            return "Friends"
        }else{return "Incoming requests"}
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = self.friendsTableView.cellForRow(at: indexPath) as? FriendCell else {
            return nil}
        if indexPath.section==0{
            let unfriendAction = UIContextualAction(style: .normal, title: "unfriend") { action, view, handler in
                print("unfriend")
                let str = cell.usernameLabel.text
                if let str = str{
                    UserController.sharedInstance.grabUserFromUsername(username: str) { result in
                        switch result{
                        case .success(let user):
                            UserController.sharedInstance.unfriendUser(user: user)
                        case .failure(let error):
                            print("err "+error.localizedDescription)
                        }
                    }
                }
                
            }
            let blockAction = UIContextualAction(style: .destructive, title: "block") { action, view, handler in
                let str = cell.user?.uuid
                if let str = str{
                    UserController.sharedInstance.grabUserFromUsername(username: str) { result in
                        switch result{
                        case .success(let user):
                            UserController.sharedInstance.blockUser(user: user)
                        case .failure(let error):
                            print("err "+error.localizedDescription)
                        }
                    }
                }
            }
            return UISwipeActionsConfiguration(actions: [unfriendAction, blockAction])
        }else{
            let unfriendAction = UIContextualAction(style: .normal, title: "ignore") { action, view, handler in
                let str = cell.user?.uuid
                if let str = str{
                    UserController.sharedInstance.grabUserFromUuid(uuid: str) { result in
                        switch result{
                        case .success(let user):
                            guard let cu = UserController.sharedInstance.currentUser else { return}
                            UserController.sharedInstance.ignoreFriendRequest(origin: user, catcher: cu)
                        case .failure(let error):
                            print("err "+error.localizedDescription)
                        }
                    }
                }
            }
            let blockAction = UIContextualAction(style: .destructive, title: "block") { action, view, handler in
                let str = cell.usernameLabel.text
                if let str = str{
                    UserController.sharedInstance.grabUserFromUuid(uuid: str) { result in
                        switch result{
                        case .success(let user):
                            UserController.sharedInstance.unfriendUser(user: user)
                        case .failure(let error):
                            print("err "+error.localizedDescription)
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
            case .success(let user):
                UserController.sharedInstance.acceptFriendRequest(originatingUser: user, receivingUser: UserController.sharedInstance.currentUser!)
                DispatchQueue.main.async {
                    self.friendsTableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentErrorToUser(localizedError: error)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardDissapear() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
   
}// End of class

