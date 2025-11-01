import Foundation
import WebKit

public protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? { get set }
    func loadAuthView()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from navigationAction: WKNavigationAction) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewControllerProtocol?
    var authHelper: AuthHelperProtocol
        
        init(authHelper: AuthHelperProtocol) {
            self.authHelper = authHelper
        }
    
    func loadAuthView() {
        guard let request = authHelper.authRequest() else { return }
        
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideprogress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideprogress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        authHelper.code(from: navigationAction)
    }
    
}

