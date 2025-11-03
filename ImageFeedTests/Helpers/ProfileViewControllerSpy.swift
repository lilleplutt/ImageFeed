import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    var setProfileNameCalled: Bool = false
    var setProfileLoginNameCalled: Bool = false
    var setProfileDescriptionCalled: Bool = false
    var setAvatarCalled: Bool = false
    var showLogoutAlertCalled: Bool = false
    
    var profileName: String?
    var profileLoginName: String?
    var profileDescription: String?
    var avatarURL: String?
    
    func setProfileName(_ name: String) {
        setProfileNameCalled = true
        profileName = name
    }
    
    func setProfileLoginName(_ loginName: String) {
        setProfileLoginNameCalled = true
        profileLoginName = loginName
    }
    
    func setProfileDescription(_ description: String) {
        setProfileDescriptionCalled = true
        profileDescription = description
    }
    
    func setAvatar(url: String?) {
        setAvatarCalled = true
        avatarURL = url
    }
    
    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
}

