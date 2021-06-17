import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

protocol presDelegate: AnyObject{
    func err(_ s: String)
}
class UserController {
    let db = Firestore.firestore()
    var users: [User] = []
    weak var presentationDelegate: presDelegate?
    
    
    static let sharedInstance = UserController()
    
    func createUserWith(username: String, password: String, profilePic: UIImage, location: String, insturment: String, experienceLevel: String, completion: @escaping (Result<User?, UserError>) -> Void) {
        
//        let newUser = User(username: username, password: password, profilePic: profilePic, location: location, instrument: insturment, experienceLevel: experienceLevel)
        
    }
    func authUser(email: String, password: String, username: String, completion:@escaping()->Void){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print ("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                self.presentationDelegate?.err("error")
            }
            else {
                //User created successfully
                guard let result = result else { return}
                let uid = result.user.uid
                
                self.makeUserInDB(username: username, uuid: uid, location: "nowhere", bio: "i am a literal bot", instrument: "keyboard", experience: "none") { user in
                    completion()
                }
            }
        }
    }
    func makeUserInDB(username: String,uuid:String, /*friends will always be []*/location: String, bio: String, instrument: String /*frindrequests will alwasy be empty aswell*/, experience: String, completion: @escaping(User)->Void){
        let user = User(username: username, profilePic: UIImage(named: "blank")!, location: location, bio: bio, instrument: instrument, experienceLevel: experience, UUID: uuid, friends: [])
        let dict = user.toFireObj()
        let userCollection = db.collection("Users")
        let document = userCollection.document(uuid)
        document.setData(dict) { _ in
            completion(user)
        }
    }
    func grabUserFromUsername(username: String, completion: @escaping(Result<User, ManErr>)->Void){
        let userRef = db.collection("Users")
        let query = userRef.whereField("username", isEqualTo: username)
        query.getDocuments { snap, err in
            if let err = err{
                return completion(.failure(.firebaseError(err)))
            }
            guard let snap = snap else { return completion(.failure(.noSuchUser))}
            if snap.count > 1{
                return completion(.failure(.tooManySameUsername))
            }
            if snap.count == 0{
                return completion(.failure(.noSuchUser))
            }
            let stringAny = snap.documents[0].data()
            guard let user = User.fromStringAny(stringAny) else { return completion(.failure(.noSuchUser))}
            return completion(.success(user))
        }
    }
    func dbContainsUsername(username: String, completion:@escaping(Bool)->Void){
        self.grabUserFromUsername(username: username) { result in
            switch result{
            case .success(_):
                return completion(true)
            case .failure(_):
                return completion(false)
            }
        }
    }
}// End of class
