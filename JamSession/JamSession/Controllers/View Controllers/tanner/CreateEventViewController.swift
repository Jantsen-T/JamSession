//
//  CreateEventViewController.swift
//  JamSession
//
//  Created by Tanner Roberts on 6/21/21.
//

import UIKit
import CoreLocation
import SearchTextField
import Contacts

class CreateEventViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventLocationTextField: SearchTextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var instrumentsUsedTextField: UITextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventNameTextField.delegate = self
        self.eventLocationTextField.delegate = self
        self.instrumentsUsedTextField.delegate = self
        kyboardDissapear()
        eventLocationTextField.userStoppedTypingHandler = {
            self.userStoppedTyping()
        }
        if let event = event{
            let backslide = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(goBack))
            backslide.edges = .left
            self.view.addGestureRecognizer(backslide)
            eventNameTextField.text = event.title
            LocationManager.sharedInstance.getAddressFromLatLon(event.location) { res in
                switch res{
                case .success(let address):
                    DispatchQueue.main.async {
                        self.eventLocationTextField.text = address
                    }
                case .failure(let err):
                    DispatchQueue.main.async {
                        self.presentErrorToUser(localizedError: err)
                        self.eventLocationTextField.text = "NOT FOUND"
                    }
                }
            }
            instrumentsUsedTextField.text = event.instruments
            eventDatePicker.date = event.eventTime
            eventDetailsTextView.text = event.descriptionness
        }
        //creates a toolbar for the keyboard with the done button that dismisses the keyboard
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        eventNameTextField.inputAccessoryView = toolBar
        eventLocationTextField.inputAccessoryView = toolBar
        instrumentsUsedTextField.inputAccessoryView = toolBar
    }
    
    //MARK: - Properties
    var event: Event?
    var selectedDate = Date()
    
    var name = ""
    var location = ""
    var instruments = ""
    var details = ""
    var datePicker = UIDatePicker()
    
    //MARK: - Actions
    
    @IBAction func saveEventButtonTapped(_ sender: Any) {
        guard let currentUser = UserController.sharedInstance.currentUser else { return}
        guard let title = eventNameTextField.text, !title.isEmpty,
              let location = eventLocationTextField.text, !location.isEmpty,
              let instruments = instrumentsUsedTextField.text, !instruments.isEmpty else { return}
        if let event = event{
            event.descriptionness = eventDetailsTextView.text
            event.title = title
            let address = eventLocationTextField.text ?? ""
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let locationy = placemarks.first?.location
                else {
                    // handle no location found
                    return
                }
                event.location = locationy
            }
            event.descriptionness = description
            event.instruments = instruments
            EventController.sharedInstance.saveEvent(event)
            dismiss(animated: true, completion: nil)
        }else{
            let description = eventDetailsTextView.text ?? ""
            let address = eventLocationTextField.text ?? ""
            let geoCoder = CLGeocoder()
            var addressLocation = CLLocation()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let locationy = placemarks.first?.location
                else {
                    // handle no location found
                    return
                }
                addressLocation = locationy
                let newEvent = Event(title: title, eventTime: self.eventDatePicker.date, location: addressLocation, creator: currentUser, descriptoin: description, attending: [], instruments: instruments)
                EventController.sharedInstance.saveEvent(newEvent)
            }
            hideKeyboard()
            showToast(message: "Event Saved")
            eventNameTextField.text = ""
            eventLocationTextField.text = ""
            instrumentsUsedTextField.text = ""
            eventDetailsTextView.text = ""
            
            
        }
    }
    
    @objc func didTapDone() {
        eventNameTextField.resignFirstResponder()
        eventLocationTextField.resignFirstResponder()
        instrumentsUsedTextField.resignFirstResponder()
    }
    
    func hideKeyboard() {
        eventNameTextField.resignFirstResponder()
        eventLocationTextField.resignFirstResponder()
        instrumentsUsedTextField.resignFirstResponder()
        eventDetailsTextView.resignFirstResponder()
    }
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    func userStoppedTyping(){
        let formatter = CNPostalAddressFormatter()
        let address = eventLocationTextField.text ?? ""
        var strings:[String] = []
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard let placemarks = placemarks
                else {
                    // handle no location found
                    return
                }
                for loc in placemarks{
                    if let postal = loc.postalAddress{
                        strings.append(formatter.string(from: postal))
                    }
                }
            }
        eventLocationTextField.filterStrings(strings)
    }
    //MARK: - Functions
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! EventDetailViewController
        vc.finalName = self.name
        vc.finalLocation = self.location
        vc.finalTime =  "\(self.selectedDate)"
        vc.finalInstuments = self.instruments
        vc.finalDetails = self.details
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
    func kyboardDissapear() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

}//End of class
