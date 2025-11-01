import Foundation
import WebKit

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from navigationAction: WKNavigationAction) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
}
