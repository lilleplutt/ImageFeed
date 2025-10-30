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
    let createdAt: String
    let description: String?
    let likedByUser: Bool?
    let urls: UrlsResult
}

struct UrlsResult: Decodable {
    let thumb: String?
    let regular: String?
    let full: String?
}

private struct LikeResponse: Decodable {
    let photo: PhotoResult
}

final class ImagesListService {
    //MARK: - Private properties
    static let shared = ImagesListService()
    private init() {}
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private lazy var dateFormatter = ISO8601DateFormatter()
    
    private var isLoading = false
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    
    //MARK: - Methods
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if isLoading { return }
        isLoading = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let token = OAuth2TokenStorage.shared.token, !token.isEmpty else {
            assertionFailure("[ImagesListService] Bearer token is missing")
            isLoading = false
            return
        }
        
        guard let request = makePhotosRequest(token: token, page: nextPage) else {
            print("[ImagesListService] Failed to create photos request")
            isLoading = false
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { self.convert(photoResult: $0) }
                
                let existingIDs = Set(self.photos.map { $0.id })
                let uniqueNewPhotos = newPhotos.filter { !existingIDs.contains($0.id) }
                if !uniqueNewPhotos.isEmpty {
                    self.photos.append(contentsOf: uniqueNewPhotos)
                    self.lastLoadedPage = nextPage
                } else {
                }
                
                self.isLoading = false
                
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
    
    func fetchLike(id: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        likeTask?.cancel()
        
        guard let index = self.photos.firstIndex(where: { $0.id == id }) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let oldPhoto = self.photos[index]
        
        let newPhoto = Photo(
            id: oldPhoto.id,
            size: oldPhoto.size,
            createdAt: oldPhoto.createdAt,
            welcomeDescription: oldPhoto.welcomeDescription,
            thumbImageURL: oldPhoto.thumbImageURL,
            fullImageURL: oldPhoto.fullImageURL,
            isLiked: !oldPhoto.isLiked
        )
        self.photos[index] = newPhoto
        
        NotificationCenter.default.post(
            name: ImagesListService.didChangeNotification,
            object: self
        )
        
        guard let token = OAuth2TokenStorage.shared.token, !token.isEmpty else {
            self.photos[index] = oldPhoto
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        guard let request = makeLikeRequest(token: token, id: id, isLike: isLike) else {
            self.photos[index] = oldPhoto
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResponse, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let likeResponse):
                let serverPhoto = self.convert(photoResult: likeResponse.photo)
                self.photos[index] = serverPhoto
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )
                completion(.success(()))
                
            case .failure(let error):
                self.photos[index] = oldPhoto
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )
                
                completion(.failure(error))
            }
            self.likeTask = nil
        }
        self.likeTask = task
        task.resume()
    }
    
    func reset() {
        photos = []
    }
    
    //MARK: - Private methods
    private func makePhotosRequest(token: String, page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else {
            assertionFailure("[ImagesListService] Failed to create URL")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
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
    
    private func makeLikeRequest(token: String, id: String, isLike: Bool) -> URLRequest? {
        guard let likeUrl = URL(string: "https://api.unsplash.com/photos/\(id)/like") else {
            print("[ImagesListService] Incorrect like URL")
            return nil
        }
        
        var request = URLRequest(url: likeUrl)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func convert(photoResult: PhotoResult) -> Photo {
        let size = CGSize(width: photoResult.width, height: photoResult.height)
        
        return Photo(
            id: photoResult.id,
            size: size,
            createdAt: dateFormatter.date(from: photoResult.createdAt),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.regular ?? "",
            fullImageURL: photoResult.urls.full ?? "",
            isLiked: photoResult.likedByUser ?? false
        )
    }
    
}
