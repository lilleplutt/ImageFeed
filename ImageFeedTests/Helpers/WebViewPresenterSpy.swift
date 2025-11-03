import ImageFeed
import Foundation
import WebKit

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var loadAuthViewCalled: Bool = false
   
    var view: WebViewControllerProtocol?
    
    func loadAuthView() {
        loadAuthViewCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        return nil
    }
}
