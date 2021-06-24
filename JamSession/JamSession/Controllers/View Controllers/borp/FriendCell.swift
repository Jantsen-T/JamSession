//
//  FriendCell.swift
//  JamSession
//
//  Created by Gavin Craft on 6/23/21.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: User?{didSet{
        usernameLabel.text = user!.username
    }}
    override func awakeFromNib() {
        super.awakeFromNib()
        if let user = user{
            usernameLabel.text = user.username
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func messageUser(){
        guard let currentUser = UserController.sharedInstance.currentUser,
              let user = user else { return}
        let sb = UIStoryboard(name: "borp", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "chatVC") as! ChatViewController
        vc.currentUser = currentUser
        vc.targetUser = user
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        FriendViewController.shared?.present(vc, animated: true, completion: nil)
    }
    @IBAction func messageTapped(_ sender: Any){
        guard let _ = user else { return}
        messageUser()
    }
}
