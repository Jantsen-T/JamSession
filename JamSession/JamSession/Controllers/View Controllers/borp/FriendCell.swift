//
//  FriendCell.swift
//  JamSession
//
//  Created by Gavin Craft on 6/23/21.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var buttonContainingProfilePic: UIButton!
    
    var sender: UIViewController?
    var user: User?{didSet{
        usernameLabel.text = user!.username
        buttonContainingProfilePic.setImage(user!.profilePic, for: .normal)
    }}
    override func awakeFromNib() {
        super.awakeFromNib()
        if let user = user{
            usernameLabel.text = user.username
            buttonContainingProfilePic.setImage(user.profilePic, for: .normal)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func messageUser(){
        guard let currentUser = UserController.sharedInstance.currentUser,
              let user = user else { return}
        let sb = UIStoryboard(name: "borp", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "chatVC") as! ChatViewController
        vc.currentUser = currentUser
        vc.targetUser = user
        vc.modalPresentationStyle = .fullScreen
        FriendViewController.sharedInstance?.present(vc, animated: true, completion: nil)
    }
    @IBAction func messageTapped(_ sender: Any){
        guard let _ = user else { return}
        messageUser()
    }
    @IBAction func pfpButtonTapped(_ sender: Any) {
        //go to uservc for user
        guard let user = user else {
            return}
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "friendDetail") as? FriendDetailViewController else {
            return}
        vc.target = user
        self.sender?.present(vc, animated: true, completion: nil)
    }
}
