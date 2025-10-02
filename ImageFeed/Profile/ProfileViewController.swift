import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .ypBlackIOS)
        setUpProfileImage()
        setUpExitButton()
        setUpNameLabel()
        setUpLoginNameLabel()
        setUpDescriptionLabel()
    }
    
    //MARK: - Methods
        
        func setUpProfileImage() {
            let profileImage = UIImage(named: "profile_image")
            let imageView = UIImageView(image: profileImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        }
            
        func setUpExitButton() {
            let exitButton = UIButton.systemButton(
                with: UIImage(named: "exit_button")!,
                target: self,
                action: nil
            )
            exitButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(exitButton)
            exitButton.tintColor = UIColor(named: "YP Red iOS")
            exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
            exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 89).isActive = true
        }
        
        func setUpNameLabel() {
            let nameLabel = UILabel()
            nameLabel.text = "Екатерина Новикова"
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(nameLabel)
            nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
            nameLabel.textColor = UIColor(named: "YP White iOS")
            nameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 241).isActive = true
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 154).isActive = true
        }
        
        func setUpLoginNameLabel() {
            let loginNameLabel = UILabel()
            loginNameLabel.text = "@ekaterina_nov"
            loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loginNameLabel)
            loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            loginNameLabel.textColor = UIColor(named: "YP Gray iOS")
            loginNameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
            loginNameLabel.widthAnchor.constraint(equalToConstant: 99).isActive = true
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            loginNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
        }
        
        func setUpDescriptionLabel() {
            let descriptionLabel = UILabel()
            descriptionLabel.text = "Hello, world!"
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionLabel)
            descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            descriptionLabel.textColor = UIColor(named: "YP White iOS")
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
            descriptionLabel.widthAnchor.constraint(equalToConstant: 77).isActive = true
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 206).isActive = true
        }
    
}


