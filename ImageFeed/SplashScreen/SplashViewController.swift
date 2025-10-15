import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: - Private properties
    private let storage = OAuth2TokenStorage.shared
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.sharedProfile
    
    //MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpLogoImage()
        
        if let token = storage.token, !token.isEmpty {
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    //MARK: - Private methods
    private func setUpLogoImage() {
        view.backgroundColor = UIColor(resource: .ypBlackIOS)
        let splashLogoImage = UIImage(resource: .splashScreenLogo)
        let splashLogoImageView = UIImageView(image: splashLogoImage)
        splashLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        splashLogoImageView.contentMode = .scaleAspectFit
        view.addSubview(splashLogoImageView)
        
        splashLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        splashLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func switchToTabBarController() {
        let window = self.view.window ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
        
        guard let window else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case let .success(profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                print("[SplashViewController] fetchProfile error: \(error)")
                self.showAlert()
            }
        }
    }
    
}

//MARK: - Extensions
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else { return }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.navigationController?.dismiss(animated: true)
        
        if let token = storage.token, !token.isEmpty {
            fetchProfile(token: token)
        } else {
            print("[SplashViewController] Warning: token is missing after auth")
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
}
