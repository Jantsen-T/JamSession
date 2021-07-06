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
    var uuid: String
    
    var descriptionness: String
    var attending: [User]
    init(title: String, eventTime: Date, location: CLLocation, creator: User, descriptoin: String, attending: [User], instruments: String, uuid: String = UUID().uuidString){
        self.title = title
        self.eventTime = eventTime
        self.location = location
        self.creator = creator
        self.descriptionness = descriptoin
        self.attending = attending
        self.instruments = instruments
        self.uuid = uuid
    }
    func toFireObj()->[String: Any]{
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .full
        var dict:[String: Any] = [:]
        dict["title"] = title
        dict["eventTime"] = dateFormat.string(from:eventTime)
        let long = location.coordinate.longitude
        let lat = location.coordinate.latitude
        dict["location"] = "\(lat),\(long)"
        dict["creator"] = creator.uuid
        dict["description"] = descriptionness
        dict["attending"] = attending.map({$0.uuid})
        dict["instruments"] = instruments
        dict["uuid"] = uuid
        return dict
    }
    static func fromFireObj(_ s: [String: Any], completion: @escaping(Result<Event, FireError>)->Void){
        guard let title = s["title"] as? String,
              let eventTime = s["eventTime"] as? String,
              let locationn = s["location"] as? String,
              let creatorId = s["creator"] as? String,
              let description = s["description"]as? String,
              let attendings = s["attending"] as? [String]?,
              let uuid = s["uuid"] as? String,
              let instruments = s["instruments"] as? String else {
            return completion(.failure(.IncorrectFormat))}
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .full
        let time = dateFormat.date(from: eventTime)
        let array = locationn.split(separator: ",")
        let lat = Double(array[0])!
        let long = Double(array[1])!
        
        let location = CLLocation(latitude: lat, longitude: long)
        var creator: User? = nil
        var attending: [User] = []
        //time for nested completions
        UserController.sharedInstance.grabUserFromUuid(uuid: creatorId) { res in
            DispatchQueue.main.async {
                switch res{
                case .success(let mainUser):
                    creator = mainUser
                    if (attendings ?? []).count > 0{
                        for uuids in attendings?.sorted() ?? []{
                            UserController.sharedInstance.grabUserFromUuid(uuid: uuids) { res in
                                DispatchQueue.main.async {
                                    switch res{
                                    case .success(let user):
                                        DispatchQueue.main.async {
                                            attending.append(user)
                                            if user.uuid == attendings?.last{
                                                guard let time = time,
                                                      let creator = creator else {
                                                    return completion(.failure(.IncorrectFormat))}
                                                let event = Event(title: title, eventTime: time, location: location, creator: creator, descriptoin: description, attending: attending, instruments: instruments, uuid: uuid)
                                                return completion(.success(event))
                                            }
                                        }
                                    case .failure(let error):
                                        return completion(.failure(.Generic(error)))
                                    }
                                }
                            }
                        }
                    }else{
                        guard let time = time,
                              let creator = creator else {
                            return completion(.failure(.IncorrectFormat))}
                        let event = Event(title: title, eventTime: time, location: location, creator: creator, descriptoin: description, attending: [], instruments: instruments, uuid: uuid)
                        return completion(.success(event))
                    }
                    
                case .failure(let error):
                    return completion(.failure(.Generic(error)))
                }
            }
        }
    }
}// End of class

