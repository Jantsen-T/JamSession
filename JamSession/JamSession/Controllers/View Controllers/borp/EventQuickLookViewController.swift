//
//  EventQuickLookViewController.swift
//  JamSession
//
//  Created by Gavin Craft on 6/21/21.
//

import UIKit

class EventQuickLookViewController: UIViewController {
    //MARK: vars and outlets
    var event: Event?
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var instrumentsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = UserController.sharedInstance.currentUser{
            if let event = event{
                if event.creator.uuid == user.uuid{
                    editButton.isEnabled = true
                }else{
                    editButton.isEnabled = false
                }
                eventNameLabel.text = event.title
                instrumentsLabel.text = event.instruments
                LocationManager.sharedInstance.getAddressFromLatLon(event.location) { res in
                    switch res{
                    case .success(let address):
                        DispatchQueue.main.async {
                            self.locationLabel.text = address
                        }
                    case .failure(let err):
                        DispatchQueue.main.async {
                            self.presentErrorToUser(localizedError: err)
                            self.locationLabel.text = "NOT FOUND"
                        }
                    }
                }
                let dateFormat = DateFormatter()
                dateFormat.dateStyle = .full
                eventTimeLabel.text = dateFormat.string(from: event.eventTime)
                descriptionLabel.text = event.description
            }
        }
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        guard let event = event else { return}
        let sb = UIStoryboard(name: "tanman", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "createEvent")as? CreateEventViewController else { return}
        vc.event = event
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}
