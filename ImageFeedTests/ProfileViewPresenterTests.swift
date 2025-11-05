import XCTest
@testable import ImageFeed

final class ProfileViewPresenterTests: XCTestCase {
    
    func testViewDidLoad() {
        // given
        let presenter = ProfileViewPresenter()
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.setAvatarCalled)
    }
    
    func testDidTapLogoutButton() {
        // given
        let presenter = ProfileViewPresenter()
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController
        
        // when
        presenter.didTapLogoutButton()
        
        // then
        XCTAssertTrue(viewController.showLogoutAlertCalled)
    }
    
    func testUpdateAvatar() {
        // given
        let presenter = ProfileViewPresenter()
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.setAvatarCalled)
    }
}

