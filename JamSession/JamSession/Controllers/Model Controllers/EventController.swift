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
    var documents: [DocumentSnapshot] = []
    
    
    //MARK: functions
    func docsToEvents(completionn: @escaping([Event])->Void){
        var events: [Event] = []
        for i in self.documents.indices{
            guard let data = documents[i].data() else {
                return completionn([]) }
            Event.fromFireObj(data) { result in
                switch result{
                case .success(let event):
                    events.append(event)
                    if i == self.documents.count-1{
                        return completionn(events)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    func fetchDocuments(term: String, completion: @escaping(Bool)->Void){
        let eventBase = db.collection("Events")
        let query = eventBase.whereField("title", isEqualTo: term)
        query.getDocuments { snap, err in
            DispatchQueue.main.async {
                if let _ = err{
                    return completion(false)
                }
                if let snap = snap{
                    self.documents = snap.documents
                    return completion(true)
                }
                return completion(false)
            }
        }
    }
    func fetchDocuments(completion: @escaping(Bool)->Void){
        let eventBase = db.collection("Events")
        eventBase.getDocuments { snap, err in
            DispatchQueue.main.async {
                if let _ = err{
                    return completion(false)
                }
                if let snap = snap{
                    self.documents = snap.documents
                    return completion(true)
                }
                return completion(false)
            }
        }
    }
    func getAllEventsMatching(term: String, completion: @escaping(Result<[Event], FireError>)->Void){
        let eventBase = db.collection("Events")
        let query = eventBase.whereField("title", isEqualTo: term)
        var docs: [QueryDocumentSnapshot] = []
        var events: [Event] = []
        query.getDocuments { snap, err in
            DispatchQueue.main.async {
                if let snap = snap{
                    docs = snap.documents
                }
            }
        }
        DispatchQueue.main.async {
            for doc in docs{
                Event.fromFireObj(doc.data()) { res in
                    switch res{
                    case .success(let event):
                        events.append(event)
                    case .failure(let error):
                        return completion(.failure(.Generic(error)))
                    }
                }
            }
            return completion(.success(events))
        }
    }
    func saveEvent(_ event: Event){
        let dict = event.toFireObj()
        let eventBase = db.collection("Events")
        let eventDoc = eventBase.document(event.uuid)
        eventDoc.setData(dict)
    }
}
