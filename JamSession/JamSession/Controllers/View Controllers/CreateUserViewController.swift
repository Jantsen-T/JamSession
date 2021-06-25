//
//  CreateUserViewController.swift
//  JamSession
//
//  Created by Jantsen Tanner on 6/21/21.
//

import UIKit
import CoreLocation

class CreateUserViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var instrumentTextField: UITextField!
    @IBOutlet weak var experienceLevelPicker: UIPickerView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    var pickerData: [String] = []
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
=======
        imageButton.imageView?.contentMode = .scaleAspectFit
        imagePicker.delegate = self
>>>>>>> 801d7d802aa0629e9d16a305c4c77029244349ee
        pickerData = ["Beginner", "Intermediate", "Advanced", "Expert"]
        experienceLevelPicker.dataSource = self
        experienceLevelPicker.delegate = self
        imageButton.addTarget(self, action: #selector(setImage), for: .touchUpInside)
        
        //do this last
        guard let user = UserController.sharedInstance.currentUser else { return}
        usernameTextField.text = user.username
        locationTextField.text = user.location
        instrumentTextField.text = user.instrument
        bioTextView.text = user.bio
        if user.experienceLevel.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)=="beginner"{
            experienceLevelPicker.selectRow(0, inComponent: 1, animated: true)
        }else if user.experienceLevel.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)=="intermediate"{
            experienceLevelPicker.selectRow(1, inComponent: 1, animated: true)
        }else if user.experienceLevel.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)=="advanced"{
            experienceLevelPicker.selectRow(2, inComponent: 1, animated: true)
        }else if user.experienceLevel.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)=="expert"{
            experienceLevelPicker.selectRow(3, inComponent: 1, animated: true)
        }
    }
    
    
    
    @IBAction func createProfileTapped(_ sender: Any) {
        let selectedIndex = experienceLevelPicker.selectedRow(inComponent: 0)
        guard let uuid = SignUpViewController.successfulUUID else { return}
        var expString = ""
        switch selectedIndex{
        case 0:
            expString = "Beginner"
        case 1:
            expString = "Intermediate"
        case 2:
            expString = "Advanced"
        case 3:
            expString = "Expert"
        default:
            expString = ""
        }
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else { presentErrorToUser(localizedError: "You gotta have an username");return}
        guard let location = locationTextField.text, !location.isEmpty else {presentErrorToUser(localizedError: "In order to be able to effectively collalborate, please give others an idea of where you are located") ;return}
        var pfp = UIImage(named: "blank")!
        if let image = imageButton.image(for: .normal){
            pfp = image
        }
        guard let instruments = instrumentTextField.text, !instruments.isEmpty else {presentErrorToUser(localizedError: "Pls let others know what indstruments you play") ;return}
        guard let bio = bioTextView.text, !bio.isEmpty else {presentErrorToUser(localizedError: "Please provide a bio") ;return}
        if expString == ""{
            presentErrorToUser(localizedError: "Lemme know how good you are")
            return
        }
        UserController.sharedInstance.makeUserInDB(username: username, uuid: uuid, location: location, bio: bio, instrument: instruments, experience: expString, pfp: pfp) { user in
            UserController.sharedInstance.saveUser(user: user)
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    @objc func setImage(){
        let alert = UIAlertController(title: "Select image", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        let useCameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.openPickerWith(option: .camera)
        }
        let usePhotoLibAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.openPickerWith(option: .photoLibrary)
        }
        alert.addAction(cancelAction)
        alert.addAction(useCameraAction)
        alert.addAction(usePhotoLibAction)
        present(alert, animated: true)
    }
    func openPickerWith(option: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(option){
            imagePicker.sourceType = option
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true)
        }
        else{
            presentErrorToUser(localizedError: "sourcetype is not allowed: no access. Please allow access to use")
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage{
            imageButton.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }

}// End of class

