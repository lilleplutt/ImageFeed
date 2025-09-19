import UIKit

class AuthViewController: UIViewController {
    
    //MARK: - Properties
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    //MARK: - Methods
    
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
        unsplashLogoImageView.contentMode = .scaleAspectFit //for saving image proportion
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
        
        loginButton.backgroundColor = UIColor(named: "YP White iOS")
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(UIColor(named: "YP Black iOS"), for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loginButton.layer.cornerRadius = 16
        
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
        
        //action
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Actions
    
    @objc func loginButtonTapped() {
        let webViewVC = WebViewViewController()
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    

    
}
