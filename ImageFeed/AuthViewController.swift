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
        unsplashLogoImageView.contentMode = .scaleAspectFit //new
        view.addSubview(unsplashLogoImageView)
        
        unsplashLogoImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        unsplashLogoImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        unsplashLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 376).isActive = true
        unsplashLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true //new
        //unsplashLogoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 158).isActive = true
        unsplashLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true //new
        
        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        //loginButton.tintColor = UIColor(named: "YP White iOS")
        loginButton.backgroundColor = .white //new
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loginButton.layer.cornerRadius = 16 //new
        
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        //loginButton.widthAnchor.constraint(equalToConstant: 343).isActive = true
        //loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 640).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true //fix
        loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true //new
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true //new
    }
    

    
}
