import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated()
    func showBlockingHUD()
    func dismissBlockingHUD()
    func setIsLiked(_ isLiked: Bool, at indexPath: IndexPath)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    //MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Properties
    var presenter: ImagesListPresenterProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.viewDidLoad()
    }
    
    deinit {
        if let imagesListServiceObserver {
            NotificationCenter.default.removeObserver(imagesListServiceObserver)
        }
    }
    
    //MARK: - Methods
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newServicePhotos = ImagesListService.shared.photos
        let newCount = newServicePhotos.count
        
        photos = newServicePhotos
        
        if newCount > oldCount {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.performBatchUpdates {
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        } else if newCount == oldCount {
            guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else { return }
            for indexPath in visibleIndexPaths {
                guard indexPath.row < photos.count,
                      let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { continue }
                cell.setIsLiked(photos[indexPath.row].isLiked)
            }
        } else {
            tableView.reloadData()
        }
    }
    
    //MARK: - Methods
    func showBlockingHUD() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissBlockingHUD() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func setIsLiked(_ isLiked: Bool, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        cell.setIsLiked(isLiked)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("[ImagesListViewController] Invalid segue destination")
                return
            }
            let photo = photos[indexPath.row]
            viewController.imageURL = photo.fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        cell.cellImage.kf.cancelDownloadTask()
        cell.cellImage.kf.indicatorType = .activity
        
        if let url = URL(string: photo.thumbImageURL) {
            let options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
            cell.cellImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: "stub_image"),
                options: options
            ) { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    print("[ImagesListViewController] Failed to load image: \(error)")
                }
            }
        } else {
            cell.cellImage.image = UIImage(named: "stub_image")
        }
        
        if let date = photo.createdAt {
            let dateString = ImagesListCell.dateFormatter.string(from: date)
            cell.dateLabel.text = dateString
        } else {
            cell.dateLabel.text = ""
        }
        cell.setIsLiked(photo.isLiked)
    }
}

//MARK: - Extensions
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageSize = photo.size
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageSize.width
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplayRow(at: indexPath, totalCount: photos.count)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.didTapLike(at: indexPath)
    }
}
