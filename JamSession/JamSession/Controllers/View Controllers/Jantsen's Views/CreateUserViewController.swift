//
//  CreateUserViewController.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/21/21.
//

import UIKit
import CoreLocation

class CreateUserViewController: UIViewController {
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var experienceLevelPicker: UIPickerView!
    @IBOutlet weak var bioTextView: UITextView!
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var instrumentTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pickerData = ["Beginner", "Intermediate", "advanced", "Expert"]
    }
    
    var currentUser: User?
    
    @IBAction func createProfileButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
              let profilePic = profilePicImageView.image,
              let location = locationTextField.text,
              let experience = experienceLevelPicker.dataSource,
              let bio = bioTextView.text,
              let instrument = instrumentTextField.text else {return}
        
        UserController.sharedInstance.makeUserInDB(username: username, uuid: , location: location, bio: bio, instrument: instrument, experience: experience) { result in
            <#code#>
        }
        
    }
    
    
    //transitionToHome()
}


func transitionToHome(){
    //Call this function instead of a segue?
    
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
