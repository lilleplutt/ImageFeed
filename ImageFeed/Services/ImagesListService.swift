import Foundation

//MARK: - Models
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let created_at: String?
    let description: String?
    let liked_by_user: Bool
}

struct UrlsResult: Decodable {
    let thumb: String
    let large: String
}

final class ImagesListService {
    //MARK: - Private Properties
    static let shared = ImagesListService()
    private init() {}
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var isLoading = false
    private let urlSession = URLSession.shared
    private var task: URLSessionDataTask?
    
    //MARK: - Methods
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if isLoading { return }
        isLoading = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
    }
    
    private func makePhotosRequest(token: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else {
            assertionFailure("[ImagesListService] Failed to create URL")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(lastLoadedPage ?? 1)),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard let photosUrl = urlComponents.url else {
            print("[ImagesListService] Incorrect token request URL with parameters")
            return nil }
        
        var request = URLRequest(url: photosUrl)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
