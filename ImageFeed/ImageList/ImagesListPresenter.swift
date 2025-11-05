import Foundation
import UIKit

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func willDisplayRow(at indexPath: IndexPath, totalCount: Int)
    func didSelectRow(at indexPath: IndexPath)
    func didTapLike(at indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    //MARK: - Properties
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService: ImagesListService
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(imagesListService: ImagesListService = .shared) {
        self.imagesListService = imagesListService
    }
    
    //MARK: - Lifecycle
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.view?.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    //MARK: - Methods
    func willDisplayRow(at indexPath: IndexPath, totalCount: Int) {
        if indexPath.row + 1 == totalCount {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        if let vc = view as? ImagesListViewController {
            vc.performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
        }
    }
    
    func didTapLike(at indexPath: IndexPath) {
        let photos = imagesListService.photos
        guard indexPath.row < photos.count else { return }
        let photo = photos[indexPath.row]
        let newIsLike = !photo.isLiked
        
        view?.showBlockingHUD()
        view?.setIsLiked(newIsLike, at: indexPath)
        
        imagesListService.fetchLike(id: photo.id, isLike: newIsLike) { [weak self] result in
            guard let self else { return }
            self.view?.dismissBlockingHUD()
            if case .failure = result {
                // revert on failure
                self.view?.setIsLiked(photo.isLiked, at: indexPath)
            }
        }
    }
}


