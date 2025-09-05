import UIKit

final class SingleImageViewController: UIViewController {
    
    //MARK: - Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    

}
