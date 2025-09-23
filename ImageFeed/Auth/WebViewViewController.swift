import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP White iOS")
        
        setUpWebView()
        webView.navigationDelegate = self

        loadAuthView()
    }
    
    //MARK: - Constants
    
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    //MARK: - Properties
    
    weak var delegate: WebViewViewControllerDelegate?
    private var webView: WKWebView!
    
    //MARK: - Private methods
    
    private func setUpWebView() {
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    private func loadAuthView() { //show authorization screen
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

}

    //MARK: - Extensions

extension WebViewViewController: WKNavigationDelegate {
    
    func webView( //to understand if user authorized
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
          if let code = code(from: navigationAction) {
              delegate?.webViewViewController(self, didAuthenticateWithCode: code)
              decisionHandler(.cancel)
          } else {
              decisionHandler(.allow)
          }
      }
    
    private func code(from navigationAction: WKNavigationAction) -> String? { //to find url with parameter "code"
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString), //all parameters in url
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

