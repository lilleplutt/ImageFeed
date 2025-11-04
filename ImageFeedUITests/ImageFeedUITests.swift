import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        usleep(300_000)
        typeTextReliably("alin.alin.alin2000@yandex.ru", into: loginTextField)
        
        tapKeyboardArrowDownIfPresent()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        usleep(300_000)
        typeTextReliably("gospodi-pomil1987", into: passwordTextField)

        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button off"].tap()
        cellToLike.buttons["like button on"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Alina Turlaeva"].exists)
        XCTAssertTrue(app.staticTexts["@lilleplutt2000"].exists)
        
        app.buttons["exit button"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        let authenticateButton = app.buttons["Authenticate"]
        XCTAssertTrue(authenticateButton.waitForExistence(timeout: 5))
    }
}

// MARK: - Helpers
extension ImageFeedUITests {
    private func typeTextReliably(_ text: String, into element: XCUIElement) {
        UIPasteboard.general.string = text
        element.press(forDuration: 0.5)
        let paste = app.menuItems["Paste"]
        if paste.waitForExistence(timeout: 1.0) {
            paste.tap()
            return
        }
        for ch in text {
            element.typeText(String(ch))
            usleep(40_000)
        }
    }

    private func tapKeyboardArrowDownIfPresent() {
        let toolbar = app.toolbars.firstMatch
        guard toolbar.waitForExistence(timeout: 2) else { return }
        let candidates = ["Chevron Down", "Down", "Вниз", "↓", "next", "Next"]
        for title in candidates {
            let btn = toolbar.buttons[title]
            if btn.exists {
                btn.tap()
                usleep(300_000)
                return
            }
        }
        let allButtons = toolbar.buttons.allElementsBoundByIndex
        if let last = allButtons.last, last.exists {
            last.tap()
            usleep(300_000)
        }
    }

    private func tapKeyboardArrowUpIfPresent() {
        let toolbar = app.toolbars.firstMatch
        guard toolbar.waitForExistence(timeout: 2) else { return }
        let candidates = ["Chevron Up", "Up", "Вверх", "↑", "previous", "Previous"]
        for title in candidates {
            let btn = toolbar.buttons[title]
            if btn.exists {
                btn.tap()
                usleep(300_000)
                return
            }
        }
        let allButtons = toolbar.buttons.allElementsBoundByIndex
        if let first = allButtons.first, first.exists {
            first.tap()
            usleep(300_000)
        }
    }
}
