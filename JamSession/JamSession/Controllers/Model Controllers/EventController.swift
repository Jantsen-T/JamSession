//
//  EventController.swift
//  JamSession
//
//  Created by Gavin Craft on 6/21/21.
//

import Foundation
import FirebaseFirestore

class EventController{
    static let sharedInstance = EventController()
    let db = Firestore.firestore()

    func getAllEventsMatching(term: String, completion: @escaping(Result<[Event], FireError>)->Void){
        let eventBase = db.collection("Events")
        let query = eventBase.whereField("title", isEqualTo: term)
                             .whereField("eventTime", isEqualTo: term)
                             .whereField("instruments", isEqualTo: term)
                             .whereField("attending", arrayContains: term)
        query.getDocuments { snap, err in
            if let err = err{ return completion(.failure(.Fat(err)))}
            guard let snap = snap, !snap.isEmpty else { return completion(.failure(.NoData))}
            var results: [Event] = []
            for doc in snap.documents{
                Event.fromFireObj(doc.data()) { res in
                    switch res{
                    case .success(let event):
                        results.append(event)
                    case .failure(let err):
                        print(err)
                    }
                }
            }
            return completion(.success(results))
        }
    }
}
