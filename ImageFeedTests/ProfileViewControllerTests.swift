import XCTest
@testable import ImageFeed

final class ProfileViewControllerTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsDidTapLogoutButton() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        
        // when
        _ = viewController.view
        if let exitButton = findExitButton(in: viewController.view) {
            exitButton.sendActions(for: .touchUpInside)
        }
        
        // then
        XCTAssertTrue(presenter.didTapLogoutButtonCalled)
    }
    
    func testSetProfileName() {
        // given
        let viewController = ProfileViewController()
        let testName = "Test Name"
        
        // when
        _ = viewController.view
        viewController.setProfileName(testName)
        
        // then
        let nameLabel = findLabel(in: viewController.view, with: testName)
        XCTAssertNotNil(nameLabel)
    }
    
    func testSetProfileLoginName() {
        // given
        let viewController = ProfileViewController()
        let testLoginName = "@testuser"
        
        // when
        _ = viewController.view
        viewController.setProfileLoginName(testLoginName)
        
        // then
        let loginLabel = findLabel(in: viewController.view, with: testLoginName)
        XCTAssertNotNil(loginLabel)
    }
    
    func testSetProfileDescription() {
        // given
        let viewController = ProfileViewController()
        let testDescription = "Test description"
        
        // when
        _ = viewController.view
        viewController.setProfileDescription(testDescription)
        
        // then
        let descriptionLabel = findLabel(in: viewController.view, with: testDescription)
        XCTAssertNotNil(descriptionLabel)
    }
    
    func testSetAvatarWithValidURL() {
        // given
        let viewController = ProfileViewController()
        let testURL = "https://example.com/avatar.jpg"
        
        // when
        _ = viewController.view
        viewController.setAvatar(url: testURL)
        
        // then
        let imageView = findImageView(in: viewController.view)
        XCTAssertNotNil(imageView)
    }
    
    func testSetAvatarWithNilURL() {
        // given
        let viewController = ProfileViewController()
        
        // when
        _ = viewController.view
        viewController.setAvatar(url: nil)
        
        // then
        let imageView = findImageView(in: viewController.view)
        XCTAssertNotNil(imageView)
    }
    
    func testShowLogoutAlert() {
        // given
        let window = UIWindow()
        let viewController = ProfileViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        // when
        _ = viewController.view
        viewController.showLogoutAlert()
        
        // then
        let expectation = expectation(description: "Alert should be presented")
        DispatchQueue.main.async {
            let presented = viewController.presentedViewController
            XCTAssertTrue(presented is UIAlertController, "Должен быть показан UIAlertController")
            if let alert = presented as? UIAlertController {
                XCTAssertEqual(alert.title, "Пока, пока!")
                XCTAssertEqual(alert.message, "Уверены, что хотите выйти?")
                XCTAssertEqual(alert.actions.count, 2)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Helpers 
extension ProfileViewControllerTests {
    func findLabel(in view: UIView, with text: String) -> UILabel? {
        for subview in view.subviews {
            if let label = subview as? UILabel, label.text == text {
                return label
            }
            if let found = findLabel(in: subview, with: text) {
                return found
            }
        }
        return nil
    }
    
    func findImageView(in view: UIView) -> UIImageView? {
        for subview in view.subviews {
            if let imageView = subview as? UIImageView {
                return imageView
            }
            if let found = findImageView(in: subview) {
                return found
            }
        }
        return nil
    }
    
    func findExitButton(in view: UIView) -> UIButton? {
        for subview in view.subviews {
            if let button = subview as? UIButton, button.tintColor == UIColor(resource: .ypRedIOS) {
                return button
            }
            if let found = findExitButton(in: subview) {
                return found
            }
        }
        return nil
    }
}

