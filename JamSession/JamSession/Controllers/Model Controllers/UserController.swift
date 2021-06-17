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
}// End of class
