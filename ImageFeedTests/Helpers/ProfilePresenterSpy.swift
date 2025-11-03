import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfileViewPresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    var didTapLogoutButtonCalled: Bool = false
    var logoutCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
    
    func logout() {
        logoutCalled = true
    }
}

