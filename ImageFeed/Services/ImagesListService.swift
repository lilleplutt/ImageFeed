import Foundation

//MARK: - Models
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let fullImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let created_at: String?
    let description: String?
    let liked_by_user: Bool?
    let urls: UrlsResult
}

struct UrlsResult: Decodable {
    let thumb: String?
    let full: String?
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
    private var task: URLSessionTask?
    
    //MARK: - Methods
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()
        if isLoading { return }
        isLoading = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let token = OAuth2TokenStorage.shared.token, !token.isEmpty else {
            assertionFailure("[ImagesListService] Bearer token is missing")
            return
        }
        
        guard let request = makePhotosRequest(token: token) else {
            print("[ImagesListService] Failed to create photos request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResults): //array from unsplash
                let newPhotos = photoResults.map { self.convert(photoResult: $0) }
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                self.isLoading = false //to free server for next loading
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )
                
            case .failure(let error):
                self.isLoading = false
                print("[ImagesListService] Failed to load photos: \(error)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    //MARK: - Private Methods
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
            return nil
        }
        
        var request = URLRequest(url: photosUrl)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func convert(photoResult: PhotoResult) -> Photo {
        let dateFormatter = DateFormatter()
        let createdAt = dateFormatter.date(from: photoResult.created_at ?? "")
        let size = CGSize(width: photoResult.width, height: photoResult.height)
        return Photo(id: photoResult.id,
                     size: size,
                     createdAt: createdAt,
                     welcomeDescription: photoResult.description,
                     thumbImageURL: photoResult.urls.thumb ?? "",
                     fullImageURL: photoResult.urls.full ?? "",
                     isLiked: photoResult.liked_by_user ?? false)
    }
    
}
