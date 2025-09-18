import UIKit

class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP Black iOS")
        setUpSceneLoginScreen()
    }
    
    func setUpSceneLoginScreen() {
        let unsplashLogoImage = UIImage(named: "logo_of_unsplash")
        let unsplashLogoImageView = UIImageView(image: unsplashLogoImage)
        unsplashLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(unsplashLogoImageView)
        
        
        
    }

    
}
