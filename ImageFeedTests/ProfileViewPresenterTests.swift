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
        XCTAssertTrue(viewController.setAvatarCalled, "При viewDidLoad должен быть вызван setAvatar")
    }
    
    func testDidTapLogoutButton() {
        // given
        let presenter = ProfileViewPresenter()
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController
        
        // when
        presenter.didTapLogoutButton()
        
        // then
        XCTAssertTrue(viewController.showLogoutAlertCalled, "При нажатии на кнопку выхода должен показываться alert")
    }
    
    func testUpdateAvatar() {
        // given
        let presenter = ProfileViewPresenter()
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.setAvatarCalled, "setAvatar должен быть вызван при viewDidLoad")
    }
}

