//
//  AttendingTableViewCell.swift
//  JamSession
//
//  Created by Gavin Craft on 6/28/21.
//

import UIKit

class AttendingTableViewCell: UITableViewCell {
    //MARK: not fun stuff
    var sender: UIViewController?
    var user:User?{
        didSet{
            if let user = user{
                usernameLabel.text = user.username
                imageViewOfProfilePic.image = user.profilePic
                if let currentUser = UserController.sharedInstance.currentUser{
                    if currentUser.friends.contains(user.username) || currentUser == user{
                        friendRequestButton.isEnabled = false
                    }
                }
            }
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var friendRequestButton: UIButton!
    @IBOutlet weak var imageViewOfProfilePic: UIImageView!
    
    
    //MARK: fun stuff
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addButtonSelect(_ senderlol: Any) {
        guard let user = user,
              let currentUser = UserController.sharedInstance.currentUser else { return}
        UserController.sharedInstance.sendFriendRequest(originatingUser: currentUser, receivingUser: user)
        sender?.showToast(message: "Sent friend req")
        friendRequestButton.isEnabled = false
    }
    @IBAction func messageButtonSelect(_ senderlol: Any) {
        let sb = UIStoryboard(name: "borp", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "chatVC") as? ChatViewController else { return}
        vc.modalPresentationStyle = .fullScreen
        vc.targetUser = user
        sender?.present(vc, animated: true)
    }
    
}
