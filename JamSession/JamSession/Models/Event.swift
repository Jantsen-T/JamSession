//
//  Event.swift
//  JamSession
//
//  Created by Gavin Craft on 6/21/21.
//

import Foundation
import CoreLocation
class Event{
    var title: String
    var eventTime: Date
    var location: CLLocation
    let creator: User
    var instruments: String
    
    var description: String
    var attending: [User]
    init(title: String, eventTime: Date, location: CLLocation, creator: User, descriptoin: String, attending: [User], instruments: String){
        self.title = title
        self.eventTime = eventTime
        self.location = location
        self.creator = creator
        self.description = descriptoin
        self.attending = attending
        self.instruments = instruments
    }
    func toFireObj()->[String: Any]{
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .full
        var dict:[String: Any] = [:]
        dict["title"] = title
        dict["eventTime"] = dateFormat.string(from:eventTime)
        let long = location.coordinate.longitude.binade
        let lat = location.coordinate.latitude.binade
        dict["location"] = "\(lat),\(long)"
        dict["creator"] = creator.uuid
        dict["description"] = description
        dict["attending"] = attending.map({$0.uuid})
        dict["instruments"] = instruments
        
        return dict
    }
    static func fromFireObj(_ s: [String: Any], completion: @escaping(Result<Event, FireError>)->Void){
        guard let title = s["title"] as? String,
              let eventTime = s["eventTime"] as? String,
              let locationn = s["location"] as? String,
              let creatorId = s["creator"] as? String,
              let description = s["description"]as? String,
              let attendings = s["attending"] as? [String],
              let instruments = s["instruments"] as? String else { return completion(.failure(.IncorrectFormat))}
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .full
        let time = dateFormat.date(from: eventTime)
        let array = locationn.split(separator: ",")
        let lat = Double(array[0])
        let long = Double(array[1])
        guard let lat = lat,
              let long = long else { return completion(.failure(.StringDecode))}
        let location = CLLocation(latitude: lat, longitude: long)
        var creator: User? = nil
        var attending: [User] = []
        //time for nested completions
        UserController.shared.grabUserFromUuid(uuid: creatorId) { res in
            switch res{
            case .success(let mainUser):
                creator = mainUser
                for uuid in attendings{
                    UserController.shared.grabUserFromUuid(uuid: uuid) { res in
                        switch res{
                        case .success(let user):
                            attending.append(user)
                        case .failure(let err):
                            return completion(.failure(.Fat(err)))
                        }
                    }
                    guard let time = time,
                          let creator = creator else { return completion(.failure(.IncorrectFormat))}
                    let event = Event(title: title, eventTime: time, location: location, creator: creator, descriptoin: description, attending: attending, instruments: instruments)
                    return completion(.success(event))
                }
            case .failure(let err):
                return completion(.failure(.Fat(err)))
            }
        }
    }
}
