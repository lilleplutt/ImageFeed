import UIKit

final class ProfileService {
    
    //MARK: - Models
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
    
    //MARK: - Private Methods
    private func makeProfileRequest() -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token, !token.isEmpty else {
            assertionFailure("Bearer token is missing")
            return nil
        }
        
        let url = Constants.defaultBaseURL.appendingPathComponent("me")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
