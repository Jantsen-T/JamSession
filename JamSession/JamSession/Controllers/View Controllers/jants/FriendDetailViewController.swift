//
//  FriendDetailViewController.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/28/21.
//

import UIKit

class FriendDetailViewController: UIViewController {
    var target: User?
    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var locationField: UILabel!
    @IBOutlet weak var instrumentField: UILabel!
    @IBOutlet weak var experienceField: UILabel!
    @IBOutlet weak var bioField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let target = target{
            usernameField.text = target.username
            picView.image = target.profilePic
            locationField.text = target.location
            instrumentField.text = target.instrument
            experienceField.text = target.experienceLevel
            bioField.text = target.bio
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
