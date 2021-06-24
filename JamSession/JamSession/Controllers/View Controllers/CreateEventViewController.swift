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
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var eventTimeTextField: UITextField!
    @IBOutlet weak var instrumentsUsedTextField: UITextField!
    @IBOutlet weak var eventDetailsTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - Actions
    
    @IBAction func saveEventButtonTapped(_ sender: Any) {
        eventNameTextField.text = ""
        locationNameTextField.text = ""
        eventTimeTextField.text = ""
        instrumentsUsedTextField.text = ""
        eventDetailsTextField.text = ""
    }
    
    
    //MARK: - Properties
    
    var event: Event? = nil
    
    //MARK: - Functions
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
