import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Properties
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}

