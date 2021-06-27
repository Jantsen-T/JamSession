//
//  EventDetailViewController.swift
//  JamSession
//
//  Created by Tanner Roberts on 6/21/21.
//

import UIKit

class EventDetailViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventInstrumentsLabel: UILabel!
    @IBOutlet weak var eventDetailsLabel: UITextView!
    

    
    //MARK: - Properties
    
    var finalName = ""
    var finalLocation = ""
    var finalTime = ""
    var finalInstuments = ""
    var finalDetails = ""
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passInText()
    }
    
    //MARK: - Actions
    @IBAction func doneButtonTapped(_ sender: Any) {
    }
    
    
    //MARK: - Functions
    
    func passInText() {
        eventNameLabel.text = finalName
        eventLocationLabel.text = finalLocation
        eventTimeLabel.text = finalTime
        eventInstrumentsLabel.text = finalInstuments
        eventDetailsLabel.text = finalDetails
    }
    
    
    

}//End of class
