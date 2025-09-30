import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: - Properties
    
    private let storage = OAuth2TokenStorage()
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    //MARK: - Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.token != nil {
            
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
}

    //MARK: - Extensions

