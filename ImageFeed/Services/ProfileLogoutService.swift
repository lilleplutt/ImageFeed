import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private init() { }
    
    func logout() {
        OAuth2TokenStorage.shared.token = nil
        resetAllServices()
        cleanCookies()
        switchToSplashScreen()
    }
    
    private func resetAllServices() {
        ProfileService.sharedProfile.reset()
        ProfileImageService.shared.reset()
        ImagesListService.shared.reset()
        OAuth2Service.shared.reset()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func switchToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let splashVC = SplashViewController()
        window.rootViewController = splashVC
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}


