import Foundation

//MARK: - Models
struct UserResult: Decodable {
    let profileImage: ProfileImage
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}

final class ProfileImageService {
    
    // MARK: - Dependencies
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    
    // MARK: - Public methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeProfileImageRequest() else {
            print("[ProfileService] Failed to create profile request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let decoder = self.decoder
        
        let task = urlSession.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let profileImage = try decoder.decode(ProfileImage.self, from: data)
                    
                    let userResult = UserResult(profileImage: profileImage.small)
                    
                    self?.userResult = userResult
                    completion(.success(userResult))
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
    private func makeProfileImageRequest() -> URLRequest? {
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

