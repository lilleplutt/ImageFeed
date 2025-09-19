import UIKit

class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP Black iOS")
        setUpLoginScreen()
    }
    
    func setUpLoginScreen() {
        let unsplashLogoImage = UIImage(named: "logo_of_unsplash")
        let unsplashLogoImageView = UIImageView(image: unsplashLogoImage)
        unsplashLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(unsplashLogoImageView)
        
        unsplashLogoImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        unsplashLogoImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        let loginButton = UIButton.systemButton(
            with: UIImage(named: "login_button")!,
            target: self,
            action: nil
        )
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        loginButton.tintColor = UIColor(named: "YP White iOS")
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 343).isActive = true
        
    }

    
}
