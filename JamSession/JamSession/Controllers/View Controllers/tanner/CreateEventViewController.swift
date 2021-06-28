//
//  CreateEventViewController.swift
//  JamSession
//
//  Created by Tanner Roberts on 6/21/21.
//

import UIKit

class CreateEventViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var instrumentsUsedTextField: UITextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    
    @IBAction func saveEventButtonTapped(_ sender: UITextField) {
        
        self.name = eventNameTextField.text!
        self.location = eventLocationTextField.text!
        self.selectedDate = self.eventDatePicker.date
        self.instruments = instrumentsUsedTextField.text!
        self.details = eventDetailsTextView.text
        performSegue(withIdentifier: "toDetailVC", sender: self)
        print(name,location,time,instruments,details)
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

}//End of class
