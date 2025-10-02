import UIKit

final class OAuth2Service {
    
    //MARK: - Properties
    static let shared = OAuth2Service() //static provide global access and uniqueness
    private init() {} //make single exemple
    private let decoder = JSONDecoder()
    
    //MARK: - Methods
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[OAuth2Service] Failed to create URLRequest")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let decoder = self.decoder
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let tokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let token = tokenResponse.accessToken
                    
                    OAuth2TokenStorage.shared.token = token
                    print("[OAuth2Service] Successfully take and save token")
                    completion(.success(token))
                } catch {
                    print("[OAuth2Service] Failed to decode JSON: \(error.localizedDescription)")
                    completion(.failure(NetworkError.decodingError(error)))
                }
                
            case .failure(let error):
                print("[OAuth2Service] Network error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    //MARK: - Private Methods
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let authTokenUrl = urlComponents.url else { return nil }
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
}
