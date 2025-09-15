import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImage = UIImage(named: "profile_image")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
    }
    
    
    
    
    
}


