import Foundation

//MARK: - Models
struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

struct ProfileResult: Decodable {
    let username: String
    let firstName: String?
    let lastName: String?
    let name: String?
    let bio: String?
}

final class ProfileService {
    
    //MARK: - Properties
    static let sharedProfile = ProfileService()
    private init() {}
    private(set) var profile: Profile?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    // MARK: - Public methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()
        
        guard let request = makeProfileRequest() else {
            print("[ProfileService] Failed to create profile request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let profileResult):
                let fullName: String
                if let first = profileResult.firstName, let last = profileResult.lastName, !(first.isEmpty && last.isEmpty) {
                    fullName = "\(first) \(last)"
                } else if let name = profileResult.name, !name.isEmpty {
                    fullName = name
                } else {
                    fullName = ""
                }
                
                let profile = Profile(
                    username: profileResult.username,
                    name: fullName,
                    loginName: "@\(profileResult.username)",
                    bio: profileResult.bio
                )
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("[ProfileService] Network error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func reset() {
        profile = nil
    }
    
    //MARK: - Private methods
    private func makeProfileRequest() -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token, !token.isEmpty else {
            assertionFailure("[ProfileService] Bearer token is missing")
            return nil
        }
        
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            print("[ProfileService] Incorrect user profile URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
