import Foundation

//MARK: - Models
struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
    
    private enum CodingKeys: String, CodingKey {
        case small
        case medium
        case large
    }
}

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

final class ProfileImageService {
    
    // MARK: - Dependencies
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private var imageTask: URLSessionTask?
    
    // MARK: - Public methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        imageTask?.cancel()
        
        guard let request = makeProfileImageRequest() else {
            print("[ProfileImageService] Failed to create profile image request")
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
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard let profileURL = URL(string: "https://api.unsplash.com/users/\(username)") else {
            return nil
        }
        
        var request = URLRequest(url: profileURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

