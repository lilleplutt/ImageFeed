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

final class ImagesListService {
    //MARK: - Private Properties
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    //MARK: - Methods
    func fetchPhotosNextPage() {
        
    }
}
