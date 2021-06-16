import UIKit

class UserController {
    
    var users: [User] = []
    
    static let sharedInstance = UserController()
    
    func createUserWith(username: String, password: String, profilePic: UIImage, location: String, insturment: String, experienceLevel: String, completion: @escaping (Result<User?, UserError>) -> Void) {
        
//        let newUser = User(username: username, password: password, profilePic: profilePic, location: location, instrument: insturment, experienceLevel: experienceLevel)
        
    }
}// End of class
