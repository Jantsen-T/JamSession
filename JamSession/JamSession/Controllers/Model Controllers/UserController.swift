import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

protocol presDelegate: AnyObject{
    func err(_ s: String)
}
class UserController {
    let db = Firestore.firestore()
    //var users: [User] = []
    weak var presentationDelegate: presDelegate?
    static let sharedInstance = UserController()
    var currentUser: User?{didSet{
        //   ViewController.shared?.userAppeared()
        let userbase = db.collection("Users")
        let user2Doc = userbase.document(currentUser!.uuid)
        let friendRequestCollection = user2Doc.collection("friend_requests")
        friendRequestCollection.addSnapshotListener { snap, err in
            if let snap = snap{
                if !(snap.isEmpty){
                    self.loadCurrentFriendRequests()
                    print("req inbound")
                }
            }
        }
    }}
    var userFriends: [User] = []{
        didSet{
            //  FriendViewController.shared?.tableVieww.reloadData()
        }
    }
    //let storage = Storage.storage()
    init(){
    }
    
    func saveData(){
        let userbase = db.collection("Users")
        guard let u = currentUser else { return}
        let dict = u.toFireObj()
        let doc = userbase.document(u.uuid)
        doc.setData(dict)
        let collection = doc.collection("friend_requests")
        for req in u.friendRequests{
            let title = "\(req.initialUser) to \(req.receivingUser)"
            let doc = collection.document(title)
            doc.setData(req.toFireObj())
        }
        //FriendViewController.shared?.tableVieww.reloadData()
    }
    
    func sendFriendRequest(originatingUser: User, receivingUser: User){
        if originatingUser.friends.contains(receivingUser.username) {
            return
        }
        let userbase = db.collection("Users")
        let user2Doc = userbase.document(receivingUser.uuid)
        let friendRequestCollection = user2Doc.collection("friend_requests")
        let friendRequest = friendRequestCollection.document("\(originatingUser.uuid) to \(receivingUser.uuid)")
        friendRequest.setData(FriendRequest(initialUser: originatingUser.uuid, receivingUser: receivingUser.uuid).toFireObj())
    }
    
    
    
    
    
    func ignoreFriendRequest(origin: User, catcher: User){
        let userbase = db.collection("Users")
        let ref = FriendRequest(initialUser: origin.uuid, receivingUser: catcher.uuid)
        guard let index = catcher.friendRequests.firstIndex(of: ref) else { return}
        catcher.friendRequests.remove(at: index)
        let user2Doc = userbase.document(catcher.uuid)
        let friendRequestCollection = user2Doc.collection("friend_requests")
        let friendRequest = friendRequestCollection.document("\(origin.uuid) to \(catcher.uuid)")
        friendRequest.delete()
        saveData()
        // FriendViewController.shared?.tableVieww.reloadData()
    }
    func loadCurrentFriendRequests(){
        guard let user = currentUser else { return}
        let userbase = db.collection("Users")
        let user2Doc = userbase.document(user.uuid)
        let friendRequestCollection = user2Doc.collection("friend_requests")
        friendRequestCollection.getDocuments { snap, err in
            guard let snap = snap else { return}
            for doc in snap.documents{
                let fr = FriendRequest.fromStringAny(doc.data())
                if let fr = fr{
                    user.friendRequests.append(fr)
                }
            }
        }
    }
    func blockUser(user: User){
        guard let currentUser = currentUser else { return}
        if currentUser.friends.contains(user.username){
            unfriendUser(user: user)
        }
        currentUser.blocked.append(user.username)
        saveData()
    }
    func unfriendUser(user: User){
        guard let currentUser = currentUser else { return}
        guard let index = currentUser.friends.firstIndex(of: user.username) else { return}
        currentUser.friends.remove(at: index)
        guard let index2 = user.friends.firstIndex(of: currentUser.username) else { return}
        user.friends.remove(at: index2)
        saveUser(user: user)
        saveData()
        // FriendViewController.shared?.tableVieww.reloadData()
    }
    func saveUser(user: User){
        let userbase = db.collection("Users")
        let user2Doc = userbase.document(user.uuid)
        let dict = user.toFireObj()
        user2Doc.setData(dict)
        let requestCollection = user2Doc.collection("friend_requests")
        for req in user.friendRequests{
            let title = "\(req.initialUser) to \(req.receivingUser)"
            let doc = requestCollection.document(title)
            doc.setData(req.toFireObj())
        }
    }
    func acceptFriendRequest(originatingUser: User, receivingUser: User){
        let userbase = db.collection("Users")
        let user2Doc = userbase.document(receivingUser.uuid)
        let friendRequestCollection = user2Doc.collection("friend_requests")
        print("\(originatingUser.uuid) to \(receivingUser.uuid)")
        let friendRequest = friendRequestCollection.document("\(originatingUser.uuid) to \(receivingUser.uuid)")
        friendRequest.delete { err in
            
            print(err)
            if err == nil{
                if !(receivingUser.friends.contains(originatingUser.username)){
                    receivingUser.friends.append(originatingUser.username)
                    originatingUser.friends.append(receivingUser.username)
                    self.saveUser(user: originatingUser)
                    //self.saveUser(user: receivingUser)
                    guard let index = receivingUser.friendRequests.firstIndex(of: FriendRequest(initialUser: originatingUser.uuid, receivingUser: receivingUser.uuid)) else {
                        
                        
                        return}
                    receivingUser.friendRequests.remove(at: index)
                    self.saveData()
                }
            }
            
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
            if snap.count==0{
                return completion(.failure(.noSuchUser))
            }
            let stringAny = snap.documents[0].data()
            guard let user = User.fromStringAny(stringAny) else { return completion(.failure(.noSuchUser))}
            return completion(.success(user))
        }
    }
    func grabUserFromUuid(uuid: String, completion: @escaping(Result<User, ManErr>)->Void){
        let userRef = db.collection("Users")
        let query = userRef.whereField("uuid", isEqualTo: uuid)
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
                
<<<<<<< HEAD
                self.makeUserInDB(username: username, uuid: uid, location: "locatioin", bio: "bio", instrument: "instrument", experience: "seleccted experience") { user in
=======
                self.makeUserInDB(username: username, uuid: uid, location: "", bio: "", instrument: "", experience: "") { user in
>>>>>>> 6a9910b788549251d43f075d4ee22f47dffed6fb
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

// This File has the code from the ham intercession freidn requests
