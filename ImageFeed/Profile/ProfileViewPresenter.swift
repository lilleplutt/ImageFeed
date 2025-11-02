import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogoutButton()
    func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let logoutService: ProfileLogoutService
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(
        profileService: ProfileService = .sharedProfile,
        profileImageService: ProfileImageService = .shared,
        logoutService: ProfileLogoutService = .shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.logoutService = logoutService
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        setupProfile()
        setupAvatarObserver()
        updateAvatar()
    }
    
    func didTapLogoutButton() {
        view?.showLogoutAlert()
    }
    
    // MARK: - Private methods
    private func setupProfile() {
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
    }
    
    private func setupAvatarObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    private func updateProfileDetails(profile: Profile) {
        let name = formatName(profile.name)
        let loginName = formatLoginName(profile.loginName)
        let description = formatDescription(profile.bio)
        
        view?.setProfileName(name)
        view?.setProfileLoginName(loginName)
        view?.setProfileDescription(description)
    }
    
    private func formatName(_ name: String) -> String {
        name.isEmpty ? "Имя не указано" : name
    }
    
    private func formatLoginName(_ loginName: String) -> String {
        loginName.isEmpty ? "@неизвестный_пользователь" : loginName
    }
    
    private func formatDescription(_ bio: String?) -> String {
        (bio?.isEmpty ?? true) ? "Профиль не заполнен" : bio ?? ""
    }
    
    private func updateAvatar() {
        let avatarURL = profileImageService.avatarURL
        view?.setAvatar(url: avatarURL)
    }
    
    func logout() {
        logoutService.logout()
    }
}

