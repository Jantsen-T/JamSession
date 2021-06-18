//
//  ViewController.swift
//  HamIntercessionFriendRequestsTest
//
//  Created by Gavin Craft on 6/16/21.
//

import UIKit

class ViewController: UIViewController {
    static var shared: ViewController?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.shared = self
    }
    func userAppeared(){
        guard let u = UserController.shared.currentUser else { return}
        imageView.image = u.profilePic
    }
    
}

