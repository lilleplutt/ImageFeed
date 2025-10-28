import Foundation

//MARK: - Models
struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct UserResult: Codable {
    let profileImage: ProfileImage
}

final class ProfileImageService {
    
    //MARK: - Properties
    static let shared = ProfileImageService()
    private init() {}
    private(set) var avatarURL: String?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Dependencies
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    // MARK: - Methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let token = OAuth2TokenStorage.shared.token, !token.isEmpty else {
            assertionFailure("[ProfileImageService] Bearer token is missing")
            return
        }
        
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            print("[ProfileImageService] Failed to create profile image request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let userResult):
                let avatarURL = userResult.profileImage.medium
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": avatarURL]
                )
                
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func reset() {
       avatarURL = nil
    }
    
    //MARK: - Private methods
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard let profileURL = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("[ProfileImageService] Incorrect user public profile URL")
            return nil
        }
        
        var request = URLRequest(url: profileURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

