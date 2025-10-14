import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - UI
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Private properties
    private var profileImageServiceObserver: NSObjectProtocol?
    private let tokenStorage = OAuth2TokenStorage.shared
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .ypBlackIOS)
        setUpProfileImage()
        setUpExitButton()
        setUpNameLabel()
        setUpLoginNameLabel()
        setUpDescriptionLabel()
        
        if let profile = ProfileService.sharedProfile.profile {
            updateProfileDetails(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    //MARK: - Private methods
    private func setUpProfileImage() {
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    private func setUpExitButton() {
        let exitButton = UIButton.systemButton(
            with: UIImage(resource: .exitButton),
            target: self,
            action: nil
        )
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.tintColor = UIColor(resource: .ypRedIOS)
        exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 89).isActive = true
    }
    
    private func setUpNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = UIColor(resource: .ypWhiteIOS)
        nameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 241).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 154).isActive = true
    }
    
    private func setUpLoginNameLabel() {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = UIColor(resource: .ypGrayIOS)
        loginNameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        loginNameLabel.widthAnchor.constraint(equalToConstant: 99).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
    }
    
    private func setUpDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor(resource: .ypWhiteIOS)
        descriptionLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: 77).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 206).isActive = true
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        print("imageUrl: \(profileImageURL)")
        
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in
                
                switch result {
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name.isEmpty
            ? "Имя не указано"
            : profile.name
        loginNameLabel.text = profile.loginName.isEmpty
            ? "@неизвестный_пользователь"
            : profile.loginName
        descriptionLabel.text = (profile.bio?.isEmpty ?? true)
            ? "Профиль не заполнен"
            : profile.bio
    }
}

