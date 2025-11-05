import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func setProfileName(_ name: String)
    func setProfileLoginName(_ loginName: String)
    func setProfileDescription(_ description: String)
    func setAvatar(url: String?)
    func showLogoutAlert()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: - Properties
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - UI
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .ypBlackIOS)
        setUpProfileImage()
        setUpExitButton()
        setUpNameLabel()
        setUpLoginNameLabel()
        setUpDescriptionLabel()
        
        presenter?.viewDidLoad()
    }
    
    //MARK: - Private methods
    private func setUpProfileImage() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 35
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setUpExitButton() {
        let exitButton = UIButton.systemButton(
            with: UIImage(resource: .exitButton),
            target: self,
            action: #selector(exitButtonTapped)
        )
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.tintColor = UIColor(resource: .ypRedIOS)
        exitButton.accessibilityIdentifier = "exit button"
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 89)
        ])
    }
    
    private func setUpNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = UIColor(resource: .ypWhiteIOS)
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.widthAnchor.constraint(equalToConstant: 241),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 154)
        ])
    }
    
    private func setUpLoginNameLabel() {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = UIColor(resource: .ypGrayIOS)
        NSLayoutConstraint.activate([
            loginNameLabel.heightAnchor.constraint(equalToConstant: 18),
            loginNameLabel.widthAnchor.constraint(equalToConstant: 99),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180)
        ])
    }
    
    private func setUpDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor(resource: .ypWhiteIOS)
        NSLayoutConstraint.activate([
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 77),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 206)
        ])
    }
    
    // MARK: - Public methods
    func setProfileName(_ name: String) {
        nameLabel.text = name
    }
    
    func setProfileLoginName(_ loginName: String) {
        loginNameLabel.text = loginName
    }
    
    func setProfileDescription(_ description: String) {
        descriptionLabel.text = description
    }
    
    func setAvatar(url: String?) {
        guard let profileImageURL = url,
              let url = URL(string: profileImageURL)
        else {
            setPlaceholderAvatar()
            return
        }
        
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
            ]
        ) { result in
            switch result {
            case .success(let value):
                print("[ProfileViewController] avatar loaded, cache: \(value.cacheType), source: \(value.source)")
            case .failure(let error):
                print("[ProfileViewController] avatar load error: \(error)")
            }
        }
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.presenter?.logout()
        })
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - Private methods
    private func setPlaceholderAvatar() {
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        profileImageView.image = placeholderImage
    }
    
    @objc private func exitButtonTapped() {
        presenter?.didTapLogoutButton()
    }
}
