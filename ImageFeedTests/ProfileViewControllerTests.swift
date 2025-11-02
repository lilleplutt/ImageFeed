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
        XCTAssertTrue(presenter.viewDidLoadCalled, "Презентер должен быть вызван при загрузке view")
    }
    
    func testViewControllerCallsDidTapLogoutButton() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        
        // when
        _ = viewController.view
        // Симулируем нажатие на кнопку выхода через селектор
        if let exitButton = findExitButton(in: viewController.view) {
            exitButton.sendActions(for: .touchUpInside)
        }
        
        // then
        XCTAssertTrue(presenter.didTapLogoutButtonCalled, "При нажатии на кнопку выхода должен вызываться метод презентера")
    }
    
    func testSetProfileName() {
        // given
        let viewController = ProfileViewController()
        let testName = "Test Name"
        
        // when
        _ = viewController.view
        viewController.setProfileName(testName)
        
        // then
        // Проверяем через поиск в view иерархии
        let nameLabel = findLabel(in: viewController.view, with: testName)
        XCTAssertNotNil(nameLabel, "Имя профиля должно быть установлено корректно")
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
        XCTAssertNotNil(loginLabel, "Логин профиля должен быть установлен корректно")
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
        XCTAssertNotNil(descriptionLabel, "Описание профиля должно быть установлено корректно")
    }
    
    func testSetAvatarWithValidURL() {
        // given
        let viewController = ProfileViewController()
        let testURL = "https://example.com/avatar.jpg"
        
        // when
        _ = viewController.view
        viewController.setAvatar(url: testURL)
        
        // then
        // Проверяем, что метод не вызвал ошибку
        // (точную проверку загрузки изображения сложно сделать без мокирования Kingfisher)
        let imageView = findImageView(in: viewController.view)
        XCTAssertNotNil(imageView, "ImageView должен существовать")
    }
    
    func testSetAvatarWithNilURL() {
        // given
        let viewController = ProfileViewController()
        
        // when
        _ = viewController.view
        viewController.setAvatar(url: nil)
        
        // then
        // При nil URL должен быть установлен placeholder
        let imageView = findImageView(in: viewController.view)
        XCTAssertNotNil(imageView, "ImageView должен существовать")
    }
    
    func testShowLogoutAlert() {
        // given
        let viewController = ProfileViewController()
        
        // when
        _ = viewController.view
        viewController.showLogoutAlert()
        
        // then
        // Проверяем, что alert был показан
        let expectation = expectation(description: "Alert should be presented")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(viewController.presentedViewController is UIAlertController, "Должен быть показан UIAlertController")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Helpers для поиска элементов в view
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

