import Foundation

//MARK: - Models
struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?

    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

final class ProfileService {
    
    //MARK: - Properties
    static let sharedProfile = ProfileService()
    private init() {}
    private(set) var profile: Profile?
    
    // MARK: - Dependencies
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    // MARK: - Public methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
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
                let profile = Profile(
                    username: profileResult.username,
                    name: "\(profileResult.firstName) \(profileResult.lastName)",
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
    
    //MARK: - Private Methods
    private func makeProfileRequest() -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token, !token.isEmpty else {
            assertionFailure("Bearer token is missing")
            return nil
        }
        
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}

