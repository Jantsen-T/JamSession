//
//  LocationManager.swift
//  JamSession
//
//  Created by Gavin Craft on 6/21/21.
//

import CoreLocation
import Foundation

class LocationManager{
    static let sharedInstance = LocationManager()
    func getAddressFromLatLon(_ loc: CLLocation, completion: @escaping(Result<String, FireError>)->Void){
            
            let ceo: CLGeocoder = CLGeocoder()

            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        return completion(.failure(.Generic(error!)))
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }


                        return completion(.success(addressString))
                  }
            })

        }
}
