import UIKit

final class ProfileService {
    
    struct ProfileResult: Codable {
        let first_name: String
        let last_name: String
        let username: String
        let bio: String
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
        
        init(username: String, name: String, loginName: String, bio: String) {
            self.username = username
            self.name = name
            self.loginName = loginName
            self.bio = bio
        }
        
        init(result: ProfileResult) {
            self.username = result.username
            self.name = "\(result.first_name) \(result.last_name)"
            self.loginName = "@\(result.username)"
            self.bio = result.bio
        }
    }
    
}
