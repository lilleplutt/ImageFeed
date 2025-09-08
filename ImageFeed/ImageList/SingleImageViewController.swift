import UIKit

final class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    //MARK: - IBActions
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
