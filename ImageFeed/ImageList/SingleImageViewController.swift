import UIKit

final class SingleImageViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Properties
    
    var image: UIImage?
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    

}
