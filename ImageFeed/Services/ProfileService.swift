import UIKit

final class ProfileService {
    
    // MARK: - Dependencies
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    
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
    
    // MARK: - Public methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeProfileRequest() else {
            print("[ProfileService] Failed to create profile request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let decoder = self.decoder
        
        let task = urlSession.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let profileResult = try decoder.decode(ProfileResult.self, from: data)
                    let profile = Profile(result: profileResult)
                    completion(.success(profile))
                } catch {
                    print("[ProfileService] Decoding error: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                print("[ProfileService] Network error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self?.task = nil
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

