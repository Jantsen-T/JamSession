//
//  EventQuickLookViewController.swift
//  JamSession
//
//  Created by Gavin Craft on 6/21/21.
//

import UIKit
import CoreLocation
import MapKit

class EventQuickLookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: vars and outlets
    var event: Event?
    @IBOutlet weak var attendingTableView: UITableView!
    @IBOutlet weak var imInButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var instrumentsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendingTableView.dataSource = self
        attendingTableView.delegate = self
        if let user = UserController.sharedInstance.currentUser{
            if let event = event{
                if event.creator.uuid == user.uuid{
                    editButton.isEnabled = true
                }else{
                    editButton.isEnabled = false
                }
                if event.attending.contains(user){
                    imInButton.isEnabled = false
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
        let sb = UIStoryboard(name: "borp", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "createEvent")as? CreateEventViewController else { return}
        vc.event = event
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func mapButtonPressed(_ sender: Any) {
        guard let event = event else { return}
        let lat = event.location.coordinate.latitude
        let lon = event.location.coordinate.longitude
        self.openMapForPlace(lat: lat, long: lon)
    }
    func openMapForPlace(lat: CLLocationDegrees, long: CLLocationDegrees) {
        guard let event = event else { return}
        let latitude:CLLocationDegrees =  lat
        let longitude:CLLocationDegrees =  long
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(event.title)"
        mapItem.openInMaps(launchOptions: options)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let event = event else { return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendeeCell", for: indexPath) as! AttendingTableViewCell
        let user = event.attending[indexPath.row]
        cell.oozernameLabel.text = user.username
        cell.pfpView.image = user.profilePic
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let event = event{
            return event.attending.count
        }else {return 0}
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    @IBAction func imInPressed(_ sender: Any) {
        guard let event = event,
              let user = UserController.sharedInstance.currentUser else { return}
        event.attending.append(user)
        EventController.sharedInstance.saveEvent(event)
        attendingTableView.reloadData()
        imInButton.isEnabled = false
    }
    
}
