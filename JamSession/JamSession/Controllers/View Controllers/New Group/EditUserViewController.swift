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
        
pickerData = ["Beginner", "Intermediate", "advanced", "Expert"]
        // Do any additional setup after loading the view.
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
