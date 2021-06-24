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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
pickerData = ["Beginner", "Intermediate", "advanced", "Expert"]
    }
    
    
    
    @IBAction func createProfileButtonTapped(_ sender: Any) {
      
        
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
