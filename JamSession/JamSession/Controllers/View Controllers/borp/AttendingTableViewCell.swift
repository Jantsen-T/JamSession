//
//  AttendingTableViewCell.swift
//  JamSession
//
//  Created by Gavin Craft on 6/28/21.
//

import UIKit

class AttendingTableViewCell: UITableViewCell {
    var sendery: UIViewController?
    var user:User?{
        didSet{
            if let user = user{
                oozernameLabel.text = user.username
                pfpView.image = user.profilePic
                if let currentUser = UserController.sharedInstance.currentUser{
                    if currentUser.friends.contains(user.username) || currentUser == user{
                        friendRequestButton.isEnabled = false
                    }
                }
            }
        }
    }
    @IBOutlet weak var oozernameLabel: UILabel!
    @IBOutlet weak var friendRequestButton: UIButton!
    @IBOutlet weak var pfpView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addButtonSelect(_ sender: Any) {
        guard let user = user,
              let currentUser = UserController.sharedInstance.currentUser else { return}
        UserController.sharedInstance.sendFriendRequest(originatingUser: currentUser, receivingUser: user)
        sendery?.showToast(message: "Sent friend req")
        friendRequestButton.isEnabled = false
    }
    @IBAction func messageButtonSelect(_ sender: Any) {
        let sb = UIStoryboard(name: "borp", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "chatVC")
        vc.modalPresentationStyle = .fullScreen
        sendery?.present(vc, animated: true)
    }
    
}
