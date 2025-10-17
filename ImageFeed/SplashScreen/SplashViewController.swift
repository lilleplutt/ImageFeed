import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: - Private properties
    private let storage = OAuth2TokenStorage.shared
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.sharedProfile
    private var splashLogoImageView: UIImageView!
    
    //MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpLogoImage()
        
        if let token = storage.token, !token.isEmpty {
            fetchProfile(token: token)
        } else {
            presentAuthViewController()
        }
    }
    
    //MARK: - Private methods
    private func setUpLogoImage() {
        view.backgroundColor = UIColor(resource: .ypBlackIOS)
        let splashLogoImage = UIImage(resource: .splashScreenLogo)
        splashLogoImageView = UIImageView(image: splashLogoImage)
        splashLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        splashLogoImageView.contentMode = .scaleAspectFit
        view.addSubview(splashLogoImageView)
        
        splashLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        splashLogoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    private func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
        
        guard let authViewController = authViewController as? AuthViewController else {
            assertionFailure("[SplashViewController] Could not find AuthViewController")
            return
        }
        
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        let window = self.view.window ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
        
        guard let window else {
            assertionFailure("[SplashViewController] Invalid window configuration")
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
