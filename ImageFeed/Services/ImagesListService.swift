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
    
    //MARK: - Methods
    func fetchPhotosNextPage() {
        
    }
}
