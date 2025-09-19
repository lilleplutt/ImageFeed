import UIKit

class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP Black iOS")
        setUpLogo()
        setUpLoginButton()
    }
    
    func setUpLogo() {
        let unsplashLogoImage = UIImage(named: "logo_of_unsplash")
        let unsplashLogoImageView = UIImageView(image: unsplashLogoImage)
        unsplashLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        unsplashLogoImageView.contentMode = .scaleAspectFit
        view.addSubview(unsplashLogoImageView)
        
        unsplashLogoImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        unsplashLogoImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        unsplashLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 418).isActive = true
        unsplashLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        unsplashLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
    }
    
    func setUpLoginButton() {
        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        loginButton.backgroundColor = .white
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loginButton.layer.cornerRadius = 16
        
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
    }
    

    
}
