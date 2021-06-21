//
//  MapViewController.swift
//  MapKitTest
//
//  Created by Tanner Roberts on 6/15/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Properties
    
    var resultSearchController: UISearchController? = nil
    
    let locationManager = CLLocationManager()
    
    let placeholderLocation = CLLocationCoordinate2D()
    
    //MARK: - Outlets
    @IBOutlet weak var textFieldForAddress: UITextField!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
    }//end of View Did Load
    
    //MARK: - Actions
    
    @IBAction func getDirectionsTapped(_ sender: Any) {
        getAddress()
        
    }
    
    
    //MARK: - Functions
    
    
    private let locationButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(askToOpenMap), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    
    func setButton() -> Bool {
        view.addSubview(locationButton)
        locationButton.backgroundColor = .systemBlue
        locationButton.setTitle("Show Directions in Maps", for: .normal)
        locationButton.layer.cornerRadius = 8
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        return true
    }
    @objc func askToOpenMap() {
        mapJamSesh(destinationCord: placeholderLocation, in: self, sourceView: locationButton)
        
    }
    
    
    //gets the address from the string typed into the text field
    func getAddress() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(textFieldForAddress.text!) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
            else {
                print("No location found")
                return }
            print(location)
            self.mapJamSesh(destinationCord: location.coordinate, in: self, sourceView: self.locationButton)
            
        }
    }
    
    
    //shows the users location
    func showUserLocation(with location: CLLocation) {
        
        mapView.showsUserLocation = true
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)), animated: true)
        
        resolveLocationName(with: location) { [weak self] locationName in
            self?.title = locationName
        }
        
    }
    
    
    public func resolveLocationName(with location: CLLocation, completion: @escaping((String?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let placemarks = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            
            print(placemarks)
            self.mapJamSesh(destinationCord: location.coordinate, in: self, sourceView: self.locationButton)
            
            var name = ""
            
            if let locality = placemarks.locality {
                name += locality
            }
            
            if let adminRegion = placemarks.administrativeArea {
                name += ", \(adminRegion)"
            }
            
            completion(name)
        }
    }//End of func
    
    // The master function of all functions
    
    func mapJamSesh(destinationCord: CLLocationCoordinate2D, in viewController: UIViewController, sourceView: UIView) {
        
        let sourceCoordinate = (locationManager.location?.coordinate)!
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        
        let pin = MKPointAnnotation()
        pin.coordinate = destPlaceMark.coordinate
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
                return
            }
            //creating the route
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            self.mapView.addAnnotation(pin)
        }
        
        //alert controller for the Open in Maps button
        let alertController = UIAlertController(title: "Open Route in Maps", message: "Would you like to open this route in Maps?", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
            //the alertController needs to be in this func so that it can take in destinationCord
            // destinationCord is the address that the user inputed into the system and now is being put into Maps
            let coordinate = destinationCord
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            mapItem.name = "Jam Sesh Location"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }))
        
        alertController.popoverPresentationController?.sourceRect = sourceView.bounds
        alertController.popoverPresentationController?.sourceView = sourceView
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }//End of func
    
    //function that draws the line between source and dest coordinates
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .red
        return render
    }
    
    
}//End of class
