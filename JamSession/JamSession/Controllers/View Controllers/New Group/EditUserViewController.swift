//
//  EditUserViewController.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/21/21.
//

import UIKit
import CoreLocation

class EditUserViewController: UIViewController {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var instrumentTextField: UITextField!
    
    @IBOutlet weak var experienceLevelPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //do this shit last
        pickerData = ["Beginner", "Intermediate", "Dadvanced", "Expert"]
        guard let currentUser = UserController.sharedInstance.currentUser else { return}
        profilePicImageView.image = currentUser.profilePic
        usernameTextField.text = currentUser.username
        locationTextField.text = currentUser.location
        instrumentTextField.text = currentUser.instrument
    }
    
    
    
    
    func saveNewData(){
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else { self.presentErrorToUser(localizedError: "You cannot have an empty username!") ;return}
        guard let location = locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !location.isEmpty else {self.presentErrorToUser(localizedError: "You gotta let people know where you be. Even if youre super vague") ;return}
    }
    
}
