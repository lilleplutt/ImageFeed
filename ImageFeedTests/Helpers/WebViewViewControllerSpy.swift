import ImageFeed
import Foundation
import WebKit

final class WebViewViewControllerSpy: WebViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    var lastProgressValue: Float = -1
    var isProgressHidden: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        lastProgressValue = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        isProgressHidden = isHidden
    }
    
    
}
